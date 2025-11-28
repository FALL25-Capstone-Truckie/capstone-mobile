import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_mobile/presentation/features/notification/viewmodels/notification_viewmodel.dart';
import 'package:capstone_mobile/presentation/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:capstone_mobile/domain/entities/notification.dart' as entities;
import 'package:capstone_mobile/presentation/theme/app_colors.dart';
import 'package:capstone_mobile/presentation/common_widgets/skeleton_loader.dart';
import 'package:intl/intl.dart';

/// Chi tiết thông báo screen
/// Hiển thị đầy đủ thông tin của một thông báo
class NotificationDetailScreen extends StatefulWidget {
  final String notificationId;

  const NotificationDetailScreen({Key? key, required this.notificationId})
    : super(key: key);

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  entities.Notification? notification;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationDetail();
  }

  Future<void> _loadNotificationDetail() async {
    setState(() => isLoading = true);

    try {
      final viewModel = context.read<NotificationViewModel>();

      // Find notification from list
      final foundNotification = viewModel.notifications.firstWhere(
        (n) => n.id == widget.notificationId,
        orElse: () => throw Exception('Notification not found'),
      );

      setState(() {
        notification = foundNotification;
        isLoading = false;
      });

      // Mark as read if not already
      if (!foundNotification.isRead) {
        await viewModel.markAsRead(widget.notificationId);
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Không tìm thấy thông báo: $e')));
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Chi tiết thông báo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: isLoading
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SkeletonLoader(height: 24, width: 200),
                  SizedBox(height: 16),
                  SkeletonLoader(height: 16),
                  SizedBox(height: 8),
                  SkeletonLoader(height: 16),
                  SizedBox(height: 16),
                  SkeletonLoader(height: 120),
                ],
              ),
            )
          : notification == null
          ? const Center(child: Text('Không tìm thấy thông báo'))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with gradient
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.8),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Type badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _getNotificationTypeName(
                              notification!.notificationType,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Title
                        Text(
                          notification!.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Time
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Colors.white70,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatTime(notification!.createdAt),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Content header
                        Row(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Nội dung',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
                        // Description
                        Text(
                          notification!.description,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Related info
                  if (_hasRelatedInfo())
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Thông tin liên quan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(),
                          const SizedBox(height: 12),

                          if (notification!.relatedOrderId != null)
                            _buildInfoRow(
                              'Mã đơn hàng',
                              notification!.relatedOrderId!,
                              Icons.shopping_bag_outlined,
                            ),

                          if (notification!.relatedOrderDetailIds != null &&
                              notification!.relatedOrderDetailIds!.isNotEmpty)
                            _buildInfoRow(
                              'Số kiện hàng',
                              '${notification!.relatedOrderDetailIds!.length} kiện',
                              Icons.inventory_2_outlined,
                            ),

                          if (notification!.relatedIssueId != null)
                            _buildInfoRow(
                              'Mã sự cố',
                              notification!.relatedIssueId!,
                              Icons.warning_amber_outlined,
                            ),

                          if (notification!.relatedVehicleAssignmentId != null)
                            _buildInfoRow(
                              'Mã chuyến xe',
                              notification!.relatedVehicleAssignmentId!,
                              Icons.local_shipping_outlined,
                            ),
                        ],
                      ),
                    ),

                  // Action button (if has related order)
                  if (notification!.relatedOrderId != null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to order detail
                            Navigator.of(context).pushNamed(
                              '/order-detail',
                              arguments: notification!.relatedOrderId,
                            );
                          },
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Xem chi tiết đơn hàng'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  bool _hasRelatedInfo() {
    return notification!.relatedOrderId != null ||
        (notification!.relatedOrderDetailIds != null &&
            notification!.relatedOrderDetailIds!.isNotEmpty) ||
        notification!.relatedIssueId != null ||
        notification!.relatedVehicleAssignmentId != null;
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getNotificationTypeName(entities.NotificationType type) {
    const nameMap = {
      entities.NotificationType.sealReplacement: 'Thay seal',
      entities.NotificationType.orderRejection: 'Từ chối đơn hàng',
      entities.NotificationType.damage: 'Hư hỏng hàng hóa',
      entities.NotificationType.reroute: 'Thay đổi tuyến đường',
      entities.NotificationType.penalty: 'Phạt',
      entities.NotificationType.paymentSuccess: 'Thanh toán thành công',
      entities.NotificationType.paymentTimeout: 'Hết hạn thanh toán',
      entities.NotificationType.orderStatusChange: 'Cập nhật trạng thái',
      entities.NotificationType.issueStatusChange: 'Cập nhật sự cố',
      entities.NotificationType.general: 'Thông báo chung',
    };
    return nameMap[type] ?? 'Thông báo';
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm', 'vi_VN').format(dateTime);
  }
}
