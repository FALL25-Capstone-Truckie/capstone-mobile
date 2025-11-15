import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive_extensions.dart';
import '../../../../../domain/entities/order_detail.dart';
import '../../../../../presentation/theme/app_colors.dart';
import '../../../../../presentation/theme/app_text_styles.dart';

/// Widget hiển thị thông tin seal của chuyến xe
class SealInfoSection extends StatelessWidget {
  /// Danh sách seal của chuyến xe
  final List<OrderSeal> seals;

  const SealInfoSection({super.key, required this.seals});

  @override
  Widget build(BuildContext context) {
    if (seals.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.security, size: 20.r, color: AppColors.primary),
                SizedBox(width: 8.w),
                Text('Thông tin seal', style: AppTextStyles.titleMedium),
              ],
            ),
            SizedBox(height: 12.h),

            // Seal list
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: seals.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final seal = seals[index];
                return _buildSealItem(seal);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSealItem(OrderSeal seal) {
    final statusColor = _getStatusColor(seal.status);
    final statusLabel = _getStatusLabel(seal.status);

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seal code and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  seal.sealCode,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  statusLabel,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Description
          Text(
            seal.description,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          // Removal info if seal was removed
          if (seal.sealRemovalTime != null) ...[
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thời gian gỡ: ${_formatDateTime(seal.sealRemovalTime!)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.red[700],
                    ),
                  ),
                  if (seal.sealRemovalReason != null && seal.sealRemovalReason!.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      'Lý do: ${seal.sealRemovalReason}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.red[700],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ACTIVE':
        return Colors.green;
      case 'IN_USED':
      case 'IN_USE': // Support both backend status values
        return Colors.blue;
      case 'REMOVED':
        return Colors.red;
      case 'USED':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'ACTIVE':
        return 'Hoạt động';
      case 'IN_USED':
      case 'IN_USE': // Support both backend status values
        return 'Đang sử dụng';
      case 'REMOVED':
        return 'Đã gỡ';
      case 'USED':
        return 'Đã dùng';
      default:
        return status;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
