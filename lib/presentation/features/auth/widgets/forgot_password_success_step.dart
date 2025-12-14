import 'package:flutter/material.dart';

import '../../../../core/utils/responsive_extensions.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class ForgotPasswordSuccessStep extends StatelessWidget {
  final VoidCallback onBackToLogin;

  const ForgotPasswordSuccessStep({
    super.key,
    required this.onBackToLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 32.h),
        Container(
          width: 100.r,
          height: 100.r,
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle,
            size: 80.r,
            color: AppColors.success,
          ),
        ),
        SizedBox(height: 32.h),
        Text(
          'Đổi mật khẩu thành công!',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Text(
          'Mật khẩu của bạn đã được thay đổi thành công. Vui lòng đăng nhập với mật khẩu mới.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 48.h),
        ElevatedButton(
          onPressed: onBackToLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text('Về trang đăng nhập', style: TextStyle(fontSize: 16.sp)),
        ),
      ],
    );
  }
}
