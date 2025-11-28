/// ==========================================
/// EXAMPLE: How to use IssueResolutionHandler
/// ==========================================
///
/// This example shows how to integrate the Hybrid Pattern
/// (WebSocket + Polling) for consistent issue resolution handling

import 'package:flutter/material.dart';
import '../../../../core/services/issue_resolution_handler.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../domain/repositories/issue_repository.dart';
import '../../../widgets/waiting_for_resolution_dialog.dart';
import '../../../../app/di/service_locator.dart';

/// Example: Report REROUTE issue and wait for staff to process
class RerouteReportExample {
  final IssueResolutionHandler _resolutionHandler;
  final IssueRepository _issueRepository;

  RerouteReportExample(this._resolutionHandler, this._issueRepository);

  Future<void> reportRerouteAndWait(BuildContext context) async {
    try {
      // 1️⃣ Report issue to backend
      print('📤 Reporting reroute issue...');
      final issueId = await _issueRepository.reportRerouteIssue(
        vehicleAssignmentId: 'xxx',
        issueTypeId: 'yyy',
        affectedSegmentId: 'zzz',
        description: 'Kẹt xe nghiêm trọng',
      );

      print('✅ Issue reported: $issueId');

      // 2️⃣ Show waiting dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            WaitingForResolutionDialog(issueCategory: IssueCategory.reroute),
      );

      // 3️⃣ Wait for resolution with dual listening
      final resolvedIssue = await _resolutionHandler.reportAndWaitForResolution(
        context: context,
        issueId: issueId,
        issueCategory: IssueCategory.reroute,
        onTimeout: () {
          // Show timeout dialog
          Navigator.of(context).pop(); // Close waiting dialog

          showDialog(
            context: context,
            builder: (context) => ResolutionTimeoutDialog(
              issueCategory: IssueCategory.reroute,
              onDismiss: () => Navigator.of(context).pop(),
            ),
          );
        },
      );

      // 4️⃣ Handle resolution
      if (resolvedIssue != null) {
        Navigator.of(context).pop(); // Close waiting dialog

        // Show success dialog
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.all(24),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.route,
                    color: Colors.green.shade600,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '🛣️ Lộ trình mới đã sẵn sàng',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Nhân viên đã tạo lộ trình mới để tránh khu vực gặp sự cố. Vui lòng kiểm tra và tiếp tục theo lộ trình mới.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _fetchNewRouteAndResume();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Xem lộ trình',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('❌ Error reporting reroute: $e');

      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lỗi'),
          content: Text('Không thể báo cáo sự cố: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _fetchNewRouteAndResume() async {
    print('🔄 Fetching new rerouted journey...');
    // Implement fetching new route logic
  }
}

/// Example: Report DAMAGE issue and wait for staff to resolve
class DamageReportExample {
  final IssueResolutionHandler _resolutionHandler;
  final IssueRepository _issueRepository;

  DamageReportExample(this._resolutionHandler, this._issueRepository);

  Future<void> reportDamageAndWait(BuildContext context) async {
    try {
      // 1️⃣ Report damage
      final issueId = await _issueRepository.reportDamageIssue(
        vehicleAssignmentId: 'xxx',
        issueTypeId: 'yyy',
        description: 'Hàng hóa bị hư hỏng trong quá trình vận chuyển',
        images: ['image1.jpg', 'image2.jpg'],
      );

      // 2️⃣ Show waiting dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            WaitingForResolutionDialog(issueCategory: IssueCategory.damage),
      );

      // 3️⃣ Wait for staff resolution
      final resolvedIssue = await _resolutionHandler.reportAndWaitForResolution(
        context: context,
        issueId: issueId,
        issueCategory: IssueCategory.damage,
        onTimeout: () {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (context) =>
                ResolutionTimeoutDialog(issueCategory: IssueCategory.damage),
          );
        },
      );

      // 4️⃣ Handle resolution
      if (resolvedIssue != null) {
        Navigator.of(context).pop();

        // Show resolved dialog
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('✅ Sự cố đã được xử lý'),
            content: const Text(
              'Nhân viên đã xác minh và xử lý sự cố hư hỏng. '
              'Bạn có thể tiếp tục hành trình.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Tiếp tục'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('❌ Error reporting damage: $e');
    }
  }
}

/// ==========================================
/// INTEGRATION IN NAVIGATION SCREEN
/// ==========================================
///
/// Replace old WebSocket-only pattern with Hybrid pattern

class NavigationScreenIntegrationExample {
  late IssueResolutionHandler _resolutionHandler;

  void initState() {
    // Initialize resolution handler
    _resolutionHandler = IssueResolutionHandler(
      getIt<NotificationService>(),
      getIt<IssueRepository>(),
    );
  }

  void dispose() {
    // Clean up
    _resolutionHandler.dispose();
  }

  /// Report reroute issue with hybrid pattern
  Future<void> handleReportReroute(BuildContext context) async {
    final example = RerouteReportExample(
      _resolutionHandler,
      getIt<IssueRepository>(),
    );
    await example.reportRerouteAndWait(context);
  }

  /// Report damage issue with hybrid pattern
  Future<void> handleReportDamage(BuildContext context) async {
    final example = DamageReportExample(
      _resolutionHandler,
      getIt<IssueRepository>(),
    );
    await example.reportDamageAndWait(context);
  }
}

/// ==========================================
/// OLD PATTERN (WebSocket only) - DON'T USE
/// ==========================================
/// 
/// ❌ This is the old unreliable pattern:
/// 
/// ```dart
/// // Report issue
/// await issueRepository.reportReroute(...);
/// 
/// // Only listen to WebSocket (no fallback!)
/// _rerouteResolvedSubscription = notificationService.rerouteResolvedStream.listen((data) {
///   showDialog(...); // May never show if WebSocket fails!
/// });
/// ```
/// 
/// ✅ Use Hybrid pattern instead (above examples)
