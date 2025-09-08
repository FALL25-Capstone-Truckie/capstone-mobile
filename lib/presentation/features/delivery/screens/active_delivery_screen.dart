import 'package:flutter/material.dart';

import '../../../../core/utils/responsive_extensions.dart';
import '../../../../presentation/common_widgets/responsive_layout_builder.dart';
import '../../../../presentation/theme/app_colors.dart';
import '../../../../presentation/theme/app_text_styles.dart';

class ActiveDeliveryScreen extends StatelessWidget {
  const ActiveDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giao hàng hiện tại'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ResponsiveLayoutBuilder(
        builder: (context, sizingInformation) {
          return Column(
            children: [
              _buildDeliveryProgress(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  child: sizingInformation.isTablet
                      ? _buildTabletLayout(context)
                      : _buildPhoneLayout(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOrderInfo(),
        SizedBox(height: 24.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationInfo(),
                  SizedBox(height: 24.h),
                  _buildCustomerInfo(),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: _buildActionButtons(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhoneLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOrderInfo(),
        SizedBox(height: 24.h),
        _buildLocationInfo(),
        SizedBox(height: 24.h),
        _buildCustomerInfo(),
        SizedBox(height: 24.h),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildDeliveryProgress() {
    return Container(
      padding: EdgeInsets.all(16.r),
      color: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Đang giao hàng',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.white, size: 16.r),
              SizedBox(width: 8.w),
              Text(
                'Thời gian còn lại: 15 phút',
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white, size: 12.r),
                    SizedBox(width: 4.w),
                    Text(
                      '2.5 km',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          const LinearProgressIndicator(
            value: 0.7,
            backgroundColor: Colors.white30,
            color: Colors.white,
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Đã lấy hàng',
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              ),
              Text(
                'Đang giao',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Đã giao hàng',
                style: TextStyle(color: Colors.white70, fontSize: 12.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mã đơn: #DH001', style: AppTextStyles.titleLarge),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.inProgress.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    'Đang giao',
                    style: TextStyle(
                      color: AppColors.inProgress,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: AppColors.textSecondary,
                  size: 16.r,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Thời gian lấy hàng: 09:15 - 15/09/2025',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(
                  Icons.local_shipping,
                  color: AppColors.textSecondary,
                  size: 16.r,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Dự kiến giao: 10:30 - 15/09/2025',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Thông tin địa điểm', style: AppTextStyles.headlineSmall),
        SizedBox(height: 16.h),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                _buildLocationItem(
                  icon: Icons.location_on,
                  iconColor: AppColors.error,
                  title: 'Điểm lấy hàng',
                  address: '123 Nguyễn Văn Linh, Quận 7, TP.HCM',
                  time: '09:00 - 15/09/2025',
                  isCompleted: true,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: const Divider(),
                ),
                _buildLocationItem(
                  icon: Icons.flag,
                  iconColor: AppColors.success,
                  title: 'Điểm giao hàng',
                  address: '456 Lê Văn Lương, Quận 7, TP.HCM',
                  time: '10:30 - 15/09/2025',
                  isCompleted: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String address,
    required String time,
    required bool isCompleted,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 24.r),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(title, style: AppTextStyles.titleSmall),
                  const Spacer(),
                  if (isCompleted)
                    Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 16.r,
                    ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(address, style: AppTextStyles.bodyMedium),
              SizedBox(height: 4.h),
              Text(time, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Thông tin khách hàng', style: AppTextStyles.headlineSmall),
        SizedBox(height: 16.h),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                _buildInfoRow(
                  icon: Icons.person,
                  label: 'Tên khách hàng',
                  value: 'Nguyễn Thị B',
                ),
                SizedBox(height: 12.h),
                _buildInfoRow(
                  icon: Icons.phone,
                  label: 'Số điện thoại',
                  value: '0987654321',
                  isPhone: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isPhone = false,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20.r),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.bodySmall),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (isPhone)
          IconButton(
            onPressed: () {
              // TODO: Gọi điện cho khách hàng
            },
            icon: Icon(Icons.call, color: AppColors.primary, size: 24.r),
          ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, '/delivery-map', arguments: 'DH001');
          },
          icon: Icon(Icons.map, size: 20.r),
          label: const Text('Xem bản đồ'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 48.h),
            padding: EdgeInsets.symmetric(vertical: 12.h),
          ),
        ),
        SizedBox(height: 12.h),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Cập nhật trạng thái đơn hàng
            _showCompleteDeliveryDialog(context);
          },
          icon: Icon(Icons.check_circle, size: 20.r),
          label: const Text('Hoàn thành giao hàng'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 48.h),
            padding: EdgeInsets.symmetric(vertical: 12.h),
          ),
        ),
        SizedBox(height: 12.h),
        OutlinedButton.icon(
          onPressed: () {
            // TODO: Báo cáo vấn đề
            _showReportIssueDialog(context);
          },
          icon: Icon(Icons.report_problem, size: 20.r),
          label: const Text('Báo cáo vấn đề'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.error,
            side: BorderSide(color: AppColors.error, width: 1.5.w),
            minimumSize: Size(double.infinity, 48.h),
            padding: EdgeInsets.symmetric(vertical: 12.h),
          ),
        ),
      ],
    );
  }

  void _showCompleteDeliveryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận hoàn thành'),
        content: const Text('Bạn có chắc chắn muốn hoàn thành giao hàng này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã hoàn thành giao hàng'),
                  backgroundColor: AppColors.success,
                ),
              );
              Navigator.pushReplacementNamed(context, '/');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  void _showReportIssueDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Báo cáo vấn đề'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIssueOption(context, 'Không liên hệ được khách hàng'),
            _buildIssueOption(context, 'Địa chỉ không chính xác'),
            _buildIssueOption(context, 'Khách hàng không nhận hàng'),
            _buildIssueOption(context, 'Vấn đề khác'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueOption(BuildContext context, String issue) {
    return ListTile(
      title: Text(issue),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã báo cáo: $issue'),
            backgroundColor: AppColors.info,
          ),
        );
      },
    );
  }
}
