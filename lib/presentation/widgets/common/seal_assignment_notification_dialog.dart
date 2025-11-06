import 'package:flutter/material.dart';
import '../../../app/app_routes.dart';
import '../../../app/di/service_locator.dart';
import '../../../domain/repositories/issue_repository.dart';
import '../../features/delivery/widgets/confirm_seal_replacement_sheet.dart';
import '../../../domain/entities/issue.dart';
import '../../../core/services/notification_service.dart';

/// Dialog hiển thị thông báo gán seal mới từ staff
/// Hiển thị khi driver nhận được notification realtime
class SealAssignmentNotificationDialog extends StatefulWidget {
  final String title;
  final String message;
  final String issueId;
  final String newSealCode;
  final String oldSealCode;
  final String staffName;
  final String? vehicleAssignmentId;

  const SealAssignmentNotificationDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.issueId,
    required this.newSealCode,
    required this.oldSealCode,
    required this.staffName,
    this.vehicleAssignmentId,
  }) : super(key: key);

  @override
  State<SealAssignmentNotificationDialog> createState() => _SealAssignmentNotificationDialogState();
}

class _SealAssignmentNotificationDialogState extends State<SealAssignmentNotificationDialog> {
  @override
  void initState() {
    super.initState();
    
    // 🆕 Fetch pending seals ngay khi show dialog
    if (widget.vehicleAssignmentId != null) {
      debugPrint('🔄 [SealAssignmentDialog] Fetching pending seals for VA: ${widget.vehicleAssignmentId}');
      _fetchPendingSeals();
    }
  }
  
  Future<void> _fetchPendingSeals() async {
    try {
      final issueRepository = getIt<IssueRepository>();
      final pendingIssues = await issueRepository.getPendingSealReplacements(
        widget.vehicleAssignmentId!,
      );
      
      debugPrint('🔄 [SealAssignmentDialog] Fetched ${pendingIssues.length} pending seals');
      
      // 🆕 Trigger navigation screen refresh to show banner
      if (pendingIssues.isNotEmpty) {
        debugPrint('🔄 [SealAssignmentDialog] Triggering navigation screen refresh for banner...');
        getIt<NotificationService>().triggerNavigationScreenRefresh();
      }
    } catch (e) {
      debugPrint('❌ [SealAssignmentDialog] Error fetching pending seals: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_reset,
              color: Colors.orange,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Text(
                widget.message,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),

            // Seal info
            _buildInfoRow('Nhân viên:', widget.staffName, Icons.person),
            const SizedBox(height: 8),
            _buildInfoRow('Seal cũ:', widget.oldSealCode, Icons.lock_open, 
                color: Colors.red),
            const SizedBox(height: 8),
            _buildInfoRow('Seal mới:', widget.newSealCode, Icons.lock, 
                color: Colors.green),
            const SizedBox(height: 16),

            // Instructions
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, 
                          size: 20, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Hướng dẫn:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('1. Gắn seal mới vào container'),
                  const Text('2. Chụp ảnh seal đã gắn'),
                  const Text('3. Xác nhận hoàn thành'),
                  const Text('4. Tiếp tục chuyến đi'),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        // "Xử lý ngay" button - Open confirmation sheet
        ElevatedButton.icon(
          onPressed: () async {
            Navigator.of(context).pop();
            
            // 🆕 Open ConfirmSealReplacementSheet directly
            debugPrint('📱 [SealAssignmentDialog] Opening seal replacement confirmation sheet...');
            
            // Create Issue object from the data
            final issue = Issue(
              id: widget.issueId,
              description: widget.message,
              locationLatitude: 0.0, // Will be filled by backend
              locationLongitude: 0.0, // Will be filled by backend
              status: IssueStatus.inProgress,
              issueCategory: IssueCategory.sealReplacement,
              reportedAt: DateTime.now(),
              resolvedAt: null,
              // 🆕 Create Seal objects with seal codes from notification
              oldSeal: Seal(
                id: '', // Not needed for display
                sealCode: widget.oldSealCode,
                status: SealStatus.removed,
              ),
              newSeal: Seal(
                id: '', // Not needed for display
                sealCode: widget.newSealCode,
                status: SealStatus.inUse,
              ),
            );
            
            // Show confirmation bottom sheet
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => ConfirmSealReplacementSheet(
                issue: issue,
                onConfirm: (imageBase64) async {
                  try {
                    final issueRepository = getIt<IssueRepository>();
                    await issueRepository.confirmSealReplacement(
                      issueId: widget.issueId,
                      newSealAttachedImage: imageBase64,
                    );
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✅ Đã xác nhận gắn seal mới thành công'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      
                      // Navigate back to orders after successful confirmation
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.orders,
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi: $e')),
                      );
                    }
                  }
                },
              ),
            );
          },
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Xử lý ngay'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
          ),
        ),
        
        // "Đóng" button - Close dialog (pending seals already fetched)
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            
            // 🆕 No need to navigate - pending seals already fetched in initState
            debugPrint('🔄 [SealAssignmentDialog] Closing dialog - pending seals already fetched');
          },
          child: const Text('Đóng'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, 
      {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
