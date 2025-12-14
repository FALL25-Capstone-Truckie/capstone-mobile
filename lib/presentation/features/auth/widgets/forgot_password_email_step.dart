import 'package:flutter/material.dart';

import '../../../../core/utils/responsive_extensions.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../viewmodels/forgot_password_viewmodel.dart';

class ForgotPasswordEmailStep extends StatefulWidget {
  final ForgotPasswordViewModel viewModel;

  const ForgotPasswordEmailStep({super.key, required this.viewModel});

  @override
  State<ForgotPasswordEmailStep> createState() => _ForgotPasswordEmailStepState();
}

class _ForgotPasswordEmailStepState extends State<ForgotPasswordEmailStep> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.viewModel.email.isNotEmpty) {
      _emailController.text = widget.viewModel.email;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.viewModel.status == ForgotPasswordStatus.loading;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.email_outlined,
            size: 80.r,
            color: AppColors.primary,
          ),
          SizedBox(height: 24.h),
          Text(
            'Nhập địa chỉ email',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'Chúng tôi sẽ gửi mã OTP đến email của bạn để xác nhận yêu cầu đặt lại mật khẩu.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            enabled: !isLoading,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Nhập địa chỉ email của bạn',
              prefixIcon: Icon(Icons.email, size: 24.r),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập địa chỉ email';
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return 'Email không hợp lệ';
              }
              return null;
            },
            onFieldSubmitted: (_) => _handleSubmit(),
          ),
          if (widget.viewModel.errorMessage.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: AppColors.error, size: 20.r),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      widget.viewModel.errorMessage,
                      style: TextStyle(color: AppColors.error, fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: isLoading ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: isLoading
                ? SizedBox(
                    height: 20.r,
                    width: 20.r,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text('Gửi mã OTP', style: TextStyle(fontSize: 16.sp)),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.viewModel.sendOtp(_emailController.text.trim());
    }
  }
}
