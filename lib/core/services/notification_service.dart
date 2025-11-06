import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../constants/api_constants.dart';
import '../services/token_storage_service.dart';
import '../../presentation/widgets/common/seal_assignment_notification_dialog.dart';
import '../../app/di/service_locator.dart';

/// Singleton service for managing WebSocket notifications
/// Automatically connects when driver is authenticated
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  StompClient? _stompClient;
  String? _currentDriverId;
  GlobalKey<NavigatorState>? _navigatorKey;

  final StreamController<Map<String, dynamic>> _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get notificationStream =>
      _notificationController.stream;

  bool get isConnected => _stompClient?.connected ?? false;

  /// Initialize with navigator key for showing dialogs
  void initialize(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
    _listenToNotifications();
  }

  /// Connect to WebSocket with driver ID
  Future<void> connect(String driverId) async {
    debugPrint('🔄 [NotificationService] ========================================');
    debugPrint('🔄 [NotificationService] connect() called for driver: $driverId');
    debugPrint('🔄 [NotificationService] Current driver: $_currentDriverId');
    debugPrint('🔄 [NotificationService] Is connected: $isConnected');
    debugPrint('🔄 [NotificationService] Stomp client connected: ${_stompClient?.connected}');
    debugPrint('🔄 [NotificationService] ========================================');

    // Always disconnect to ensure fresh connection
    if (isConnected) {
      debugPrint('🔄 [NotificationService] Disconnecting existing connection...');
      disconnect();
    }

    _currentDriverId = driverId;
    debugPrint('🔌 [NotificationService] ========================================');
    debugPrint('🔌 [NotificationService] Connecting for driver ID: $driverId');
    debugPrint('🔌 [NotificationService] ========================================');

    // Get JWT token for authentication
    final tokenStorageService = getIt<TokenStorageService>();
    final jwtToken = tokenStorageService.getAccessToken();
    
    if (jwtToken == null || jwtToken.isEmpty) {
      debugPrint('❌ [NotificationService] No JWT token available');
      return;
    }

    final wsUrl = '${ApiConstants.wsBaseUrl}/vehicle-tracking';
    debugPrint('🔌 [NotificationService] Connecting to WebSocket URL: $wsUrl');

    _stompClient = StompClient(
      config: StompConfig(
        url: wsUrl,
        webSocketConnectHeaders: {'Authorization': 'Bearer $jwtToken'},
        onConnect: (StompFrame frame) {
          debugPrint('✅ [NotificationService] ========================================');
          debugPrint('✅ [NotificationService] WebSocket connected successfully!');
          debugPrint('✅ [NotificationService] Frame: ${frame.body}');
          debugPrint('✅ [NotificationService] Headers: ${frame.headers}');
          debugPrint('✅ [NotificationService] Command: ${frame.command}');
          debugPrint('✅ [NotificationService] ========================================');
          debugPrint('📡 [NotificationService] Now subscribing to driver notifications...');
          _subscribeToDriverNotifications(driverId);
        },
        onWebSocketError: (dynamic error) {
          debugPrint('❌ [NotificationService] WebSocket error: $error');
        },
        onStompError: (StompFrame frame) {
          debugPrint('❌ [NotificationService] STOMP error: ${frame.body}');
        },
        onDisconnect: (StompFrame frame) {
          debugPrint('🔌 [NotificationService] WebSocket disconnected');
        },
        reconnectDelay: const Duration(seconds: 5),
        heartbeatIncoming: const Duration(seconds: 10),
        heartbeatOutgoing: const Duration(seconds: 10),
      ),
    );

    debugPrint('🚀 [NotificationService] Activating StompClient...');
    _stompClient!.activate();
    debugPrint('🚀 [NotificationService] StompClient activated, waiting for connection...');
  }

  /// Subscribe to driver-specific notification topic
  void _subscribeToDriverNotifications(String driverId) {
    final topic = '/topic/driver/$driverId/notifications';
    debugPrint('📡 [NotificationService] ========================================');
    debugPrint('📡 [NotificationService] Subscribing to topic: $topic');
    debugPrint('📡 [NotificationService] Driver ID: $driverId');
    debugPrint('📡 [NotificationService] ========================================');

    _stompClient!.subscribe(
      destination: topic,
      callback: (StompFrame frame) {
        debugPrint('📬 [NotificationService] ========================================');
        debugPrint('📬 [NotificationService] Received message on topic: $topic');
        debugPrint('📬 [NotificationService] Frame body: ${frame.body}');
        debugPrint('📬 [NotificationService] ========================================');
        
        if (frame.body != null) {
          try {
            final notification = jsonDecode(frame.body!);
            debugPrint('📲 [NotificationService] Parsed notification type: ${notification['type']}');
            debugPrint('📲 [NotificationService] Notification data: $notification');
            _notificationController.add(notification);
          } catch (e) {
            debugPrint('❌ [NotificationService] Error parsing notification: $e');
            debugPrint('❌ [NotificationService] Raw body: ${frame.body}');
          }
        } else {
          debugPrint('⚠️ [NotificationService] Received frame with null body');
        }
      },
    );
  }

  /// Listen to notification stream and handle notifications
  void _listenToNotifications() {
    _notificationController.stream.listen((notification) {
      _handleNotification(notification);
    });
  }

  /// Handle incoming notification
  void _handleNotification(Map<String, dynamic> notification) {
    final type = notification['type'] as String?;

    switch (type) {
      case 'SEAL_ASSIGNMENT':
        _showSealAssignmentNotification(notification);
        break;
      default:
        debugPrint('⚠️ [NotificationService] Unknown notification type: $type');
    }
  }

  /// Show seal assignment notification dialog
  void _showSealAssignmentNotification(Map<String, dynamic> notification) {
    if (_navigatorKey == null) {
      debugPrint('❌ [NotificationService] Navigator key is null, cannot show dialog');
      return;
    }

    final issue = notification['issue'] as Map<String, dynamic>?;

    if (issue == null) {
      debugPrint('❌ [NotificationService] Missing issue data in notification');
      return;
    }

    // Extract seal codes from issue
    final oldSeal = issue['oldSeal'] as Map<String, dynamic>?;
    final newSeal = issue['newSeal'] as Map<String, dynamic>?;
    final staff = issue['staff'] as Map<String, dynamic>?;

    // 🆕 Check navigator key before showing dialog
    debugPrint('🔍 [NotificationService] Navigator key check:');
    debugPrint('   - Navigator key null: ${_navigatorKey == null}');
    debugPrint('   - Current context null: ${_navigatorKey?.currentContext == null}');
    
    if (_navigatorKey == null || _navigatorKey!.currentContext == null) {
      debugPrint('⚠️ [NotificationService] Navigator key is null, cannot show dialog');
      return;
    }
    
    // 🆕 Check if current route is navigation screen
    // Try to get route name from navigator state
    String? routeName;
    try {
      final navigator = _navigatorKey!.currentState;
      if (navigator != null) {
        // Get current route from overlay
        final overlay = navigator.overlay;
        if (overlay != null) {
          final context = overlay.context;
          final modalRoute = ModalRoute.of(context);
          routeName = modalRoute?.settings.name;
        }
      }
    } catch (e) {
      debugPrint('⚠️ [NotificationService] Error getting route name: $e');
    }
    
    debugPrint('🔍 [NotificationService] Current route: $routeName');
    
    // If we can't determine route, show dialog anyway (driver is likely on navigation screen)
    if (routeName != null && routeName != '/navigation') {
      debugPrint('⚠️ [NotificationService] Not on navigation screen, skipping dialog');
      return;
    }
    
    debugPrint('✅ [NotificationService] On navigation screen or route unknown - showing dialog');
    
    debugPrint('📱 [NotificationService] Showing seal assignment notification dialog...');
    
    // 🆕 Get vehicle assignment ID from notification to fetch pending seals
    final vehicleAssignment = issue['vehicleAssignmentEntity'] as Map<String, dynamic>?;
    final vehicleAssignmentId = vehicleAssignment?['id'] as String?;
    
    showDialog(
      context: _navigatorKey!.currentContext!,
      barrierDismissible: false,
      builder: (context) => SealAssignmentNotificationDialog(
        title: notification['title'] ?? 'Thông báo',
        message: notification['message'] ?? '',
        issueId: issue['id'] ?? '',
        newSealCode: newSeal?['sealCode'] ?? 'N/A',
        oldSealCode: oldSeal?['sealCode'] ?? 'N/A',
        staffName: staff?['fullName'] ?? 'N/A',
        vehicleAssignmentId: vehicleAssignmentId,
      ),
    );
    
    debugPrint('🔄 [NotificationService] Dialog displayed on navigation screen');
  }

  /// Refresh pending seals in navigation screen
  void refreshPendingSeals() {
    debugPrint('🔄 [NotificationService] Triggering pending seals refresh...');
    
    // 🆕 Navigate to navigation screen to trigger refresh
    if (_navigatorKey?.currentContext != null) {
      debugPrint('🔄 [NotificationService] Navigating to navigation screen for refresh...');
      
      // Navigate to navigation screen - this will trigger _fetchPendingSealReplacements()
      Navigator.of(_navigatorKey!.currentContext!).pushNamedAndRemoveUntil(
        '/navigation',
        (route) => false,
        arguments: {
          'orderId': null, // Navigation screen will find current active order
          'isSimulationMode': false,
        },
      );
    } else {
      debugPrint('⚠️ [NotificationService] Cannot navigate - navigator key or context is null');
    }
  }
  
  /// Trigger manual refresh of navigation screen without navigation
  void triggerNavigationScreenRefresh() {
    debugPrint('🔄 [NotificationService] Triggering navigation screen refresh...');
    
    // 🆕 Send a refresh signal to navigation screen
    // This will be handled by NavigationScreen through a stream or callback
    _refreshController.add(null);
  }
  
  // Stream controller for refresh signals
  final _refreshController = StreamController<void>.broadcast();
  Stream<void> get refreshStream => _refreshController.stream;

  /// Disconnect from WebSocket
  void disconnect() {
    if (_stompClient?.connected ?? false) {
      debugPrint('🔌 [NotificationService] Disconnecting WebSocket');
      _stompClient!.deactivate();
    }
    _currentDriverId = null;
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    _notificationController.close();
  }
}
