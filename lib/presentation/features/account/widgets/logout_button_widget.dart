import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive_extensions.dart';
import '../../../../../presentation/features/auth/viewmodels/auth_viewmodel.dart';
import '../../../../../presentation/theme/app_colors.dart';

/// Widget hiển thị nút đăng xuất
class LogoutButtonWidget extends StatelessWidget {
  final AuthViewModel authViewModel;

  const LogoutButtonWidget({Key? key, required this.authViewModel})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        // Hiển thị dialog xác nhận
        final shouldLogout = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Xác nhận đăng xuất'),
            content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Đăng xuất',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
        );

        if (shouldLogout == true) {
          // Chuyển ngay đến trang login trước khi gọi API logout
          Navigator.pushReplacementNamed(context, '/login');
          // Sau đó thực hiện logout ở background
          authViewModel.logout();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        elevation: 2,
        minimumSize: Size(double.infinity, 56.h),
      ),
      icon: Icon(Icons.logout, size: 24.r),
      label: Text(
        'Đăng xuất',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
      ),
    );
  }
}
