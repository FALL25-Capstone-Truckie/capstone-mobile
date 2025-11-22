import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/issue.dart';
import '../../domain/repositories/issue_repository.dart';
import 'notification_service.dart';

/// Hybrid handler for issue resolution notifications
/// Combines WebSocket (fast) + Polling (reliable) for consistent UX
class IssueResolutionHandler {
  final NotificationService _notificationService;
  final IssueRepository _issueRepository;
  
  Timer? _pollingTimer;
  StreamSubscription<Map<String, dynamic>>? _wsSubscription;
  int _pollCount = 0;
  
  // Configuration
  static const int POLL_INTERVAL_SECONDS = 5;
  static const int MAX_POLLS = 60; // 5 minutes timeout
  static const int RETRY_DELAY_MS = 300;
  
  IssueResolutionHandler(this._notificationService, this._issueRepository);
  
  /// Report issue and wait for resolution with dual listening
  /// Returns the resolved issue when staff processes it
  Future<Issue?> reportAndWaitForResolution({
    required BuildContext context,
    required String issueId,
    required IssueCategory issueCategory,
    VoidCallback? onTimeout,
  }) async {
    print('🔄 Starting dual listening for issue: $issueId');
    
    final completer = Completer<Issue?>();
    
    // Setup WebSocket listener (primary - fast)
    _setupWebSocketListener(issueId, issueCategory, (issue) {
      if (!completer.isCompleted) {
        print('✅ WebSocket delivered resolution');
        _cleanup();
        completer.complete(issue);
      }
    });
    
    // Setup polling fallback (secondary - reliable)
    _startPolling(issueId, (issue) {
      if (!completer.isCompleted) {
        print('✅ Polling detected resolution');
        _cleanup();
        completer.complete(issue);
      }
    }, onTimeout: () {
      if (!completer.isCompleted) {
        print('⏰ Timeout waiting for resolution');
        _cleanup();
        onTimeout?.call();
        completer.complete(null);
      }
    });
    
    return completer.future;
  }
  
  /// Setup WebSocket listener for specific issue category
  void _setupWebSocketListener(
    String issueId,
    IssueCategory category,
    Function(Issue) onResolved,
  ) {
    final stream = _getStreamForCategory(category);
    
    _wsSubscription = stream.listen(
      (data) async {
        print('📨 WebSocket notification received: ${data['type']}');
        
        final notificationIssueId = data['issueId'] as String?;
        
        if (notificationIssueId == issueId) {
          print('✅ Notification matches our issue: $issueId');
          
          // Fetch full issue details
          try {
            final issue = await _issueRepository.getIssueById(issueId);
            
            if (issue.status == IssueStatus.resolved) {
              onResolved(issue);
            }
          } catch (e) {
            print('❌ Error fetching issue details: $e');
          }
        }
      },
      onError: (error) {
        print('❌ WebSocket error: $error');
      },
    );
    
    print('🎧 WebSocket listener setup for category: ${category.value}');
  }
  
  /// Start polling issue status as fallback
  void _startPolling(
    String issueId,
    Function(Issue) onResolved, {
    VoidCallback? onTimeout,
  }) {
    _pollCount = 0;
    
    print('📊 Starting polling for issue: $issueId');
    
    _pollingTimer = Timer.periodic(
      Duration(seconds: POLL_INTERVAL_SECONDS),
      (timer) async {
        _pollCount++;
        
        print('🔍 Polling attempt ${_pollCount + 1}/$MAX_POLLS');
        
        // Timeout after max polls
        if (_pollCount >= MAX_POLLS) {
          print('⏰ Polling timeout reached');
          timer.cancel();
          onTimeout?.call();
          return;
        }
        
        try {
          final issue = await _issueRepository.getIssueById(issueId);
          
          print('📋 Issue status: ${issue.status.value}');
          
          if (issue.status == IssueStatus.resolved) {
            print('✅ Issue resolved detected by polling');
            timer.cancel();
            onResolved(issue);
          }
        } catch (e) {
          print('⚠️ Polling error (attempt $_pollCount): $e');
          // Continue polling despite errors
        }
      },
    );
  }
  
  /// Get appropriate stream for issue category
  Stream<Map<String, dynamic>> _getStreamForCategory(IssueCategory category) {
    switch (category) {
      case IssueCategory.reroute:
        return _notificationService.rerouteResolvedStream;
      case IssueCategory.damage:
        return _notificationService.damageResolvedStream;
      case IssueCategory.orderRejection:
        return _notificationService.returnPaymentSuccessStream;
      case IssueCategory.sealReplacement:
        // Seal replacement typically auto-resolves
        return _notificationService.rerouteResolvedStream; // Reuse or create dedicated
      default:
        print('⚠️ No dedicated stream for category: ${category.value}');
        return Stream.empty();
    }
  }
  
  /// Cleanup resources
  void _cleanup() {
    print('🧹 Cleaning up resources');
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _wsSubscription?.cancel();
    _wsSubscription = null;
    _pollCount = 0;
  }
  
  /// Cancel waiting (user navigates away or closes dialog)
  void cancel() {
    print('❌ User cancelled waiting');
    _cleanup();
  }
  
  /// Dispose resources
  void dispose() {
    _cleanup();
  }
}
