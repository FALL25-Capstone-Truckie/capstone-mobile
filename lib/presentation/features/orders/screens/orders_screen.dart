import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/services/system_ui_service.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../presentation/common_widgets/responsive_grid.dart';
import '../../../../presentation/common_widgets/responsive_layout_builder.dart';
import '../../../../presentation/common_widgets/skeleton_loader.dart';
import '../../../../presentation/theme/app_colors.dart';
import '../../../../presentation/theme/app_text_styles.dart';
import '../../../features/auth/viewmodels/auth_viewmodel.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AuthViewModel>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Danh sách đơn hàng'),
          centerTitle: true,
          automaticallyImplyLeading: false, // Loại bỏ nút back
        ),
        body: Consumer<AuthViewModel>(
          builder: (context, authViewModel, _) {
            final user = authViewModel.user;
            final driver = authViewModel.driver;

            return ResponsiveLayoutBuilder(
              builder: (context, sizingInformation) {
                return Padding(
                  padding: SystemUiService.getContentPadding(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFilterSection(context),
                      SizedBox(height: 16.h),
                      Expanded(
                        child: user == null || driver == null
                            ? const OrdersSkeletonList(itemCount: 5)
                            : _buildOrdersList(context, sizingInformation),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lọc theo trạng thái', style: AppTextStyles.titleMedium),
        SizedBox(height: 8.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('Tất cả', true),
              SizedBox(width: 8.w),
              _buildFilterChip('Chờ lấy hàng', false),
              SizedBox(width: 8.w),
              _buildFilterChip('Đang giao', false),
              SizedBox(width: 8.w),
              _buildFilterChip('Hoàn thành', false),
              SizedBox(width: 8.w),
              _buildFilterChip('Đã hủy', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
      onSelected: (bool selected) {
        // TODO: Xử lý lọc theo trạng thái
      },
    );
  }

  Widget _buildOrdersList(
    BuildContext context,
    SizingInformation sizingInformation,
  ) {
    // Sử dụng grid layout cho tablet và phone layout cho điện thoại
    if (sizingInformation.isTablet) {
      return ResponsiveGrid(
        smallScreenColumns: 1,
        mediumScreenColumns: 2,
        largeScreenColumns: 2,
        horizontalSpacing: 16.w,
        verticalSpacing: 16.h,
        children: List.generate(10, (index) {
          return _buildOrderItem(
            orderId: 'DH00${index + 1}',
            status: _getRandomStatus(index),
            address: '${index + 100} Nguyễn Văn Linh, Quận 7, TP.HCM',
            time: '${(index + 8) % 12 + 1}:${index * 10 % 60}',
          );
        }),
      );
    } else {
      return ListView.separated(
        itemCount: 10,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          return _buildOrderItem(
            orderId: 'DH00${index + 1}',
            status: _getRandomStatus(index),
            address: '${index + 100} Nguyễn Văn Linh, Quận 7, TP.HCM',
            time: '${(index + 8) % 12 + 1}:${index * 10 % 60}',
          );
        },
      );
    }
  }

  String _getRandomStatus(int index) {
    final statuses = ['Chờ lấy hàng', 'Đang giao', 'Hoàn thành', 'Đã hủy'];
    return statuses[index % statuses.length];
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Chờ lấy hàng':
        return AppColors.warning;
      case 'Đang giao':
        return AppColors.inProgress;
      case 'Hoàn thành':
        return AppColors.success;
      case 'Đã hủy':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  Widget _buildOrderItem({
    required String orderId,
    required String status,
    required String address,
    required String time,
  }) {
    final statusColor = _getStatusColor(status);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: () {
          // TODO: Chuyển đến trang chi tiết đơn hàng
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mã đơn: #$orderId', style: AppTextStyles.titleMedium),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.textSecondary,
                    size: 16.r,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(address, style: AppTextStyles.bodyMedium),
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
                  Text(time, style: AppTextStyles.bodyMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
