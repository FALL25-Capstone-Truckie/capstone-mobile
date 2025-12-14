import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../viewmodels/forgot_password_viewmodel.dart';
import '../widgets/forgot_password_email_step.dart';
import '../widgets/forgot_password_otp_step.dart';
import '../widgets/forgot_password_reset_step.dart';
import '../widgets/forgot_password_success_step.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(
          'Quên mật khẩu',
          style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
        ),
        leading: Consumer<ForgotPasswordViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.currentStep == ForgotPasswordStep.success) {
              return const SizedBox.shrink();
            }
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (viewModel.currentStep == ForgotPasswordStep.enterEmail) {
                  Navigator.of(context).pop();
                } else {
                  viewModel.goBack();
                }
              },
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.r),
          child: Consumer<ForgotPasswordViewModel>(
            builder: (context, viewModel, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStepIndicator(viewModel),
                  SizedBox(height: 32.h),
                  _buildCurrentStep(viewModel),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(ForgotPasswordViewModel viewModel) {
    if (viewModel.currentStep == ForgotPasswordStep.success) {
      return const SizedBox.shrink();
    }

    final currentStepIndex = viewModel.currentStep.index;
    
    return Row(
      children: [
        _buildStepCircle(0, currentStepIndex, 'Email'),
        _buildStepLine(currentStepIndex >= 1),
        _buildStepCircle(1, currentStepIndex, 'OTP'),
        _buildStepLine(currentStepIndex >= 2),
        _buildStepCircle(2, currentStepIndex, 'Mật khẩu'),
      ],
    );
  }

  Widget _buildStepCircle(int stepIndex, int currentIndex, String label) {
    final isCompleted = stepIndex < currentIndex;
    final isCurrent = stepIndex == currentIndex;
    final isActive = isCompleted || isCurrent;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.grey300,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? Icon(Icons.check, color: Colors.white, size: 18.r)
                  : Text(
                      '${stepIndex + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.white : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              fontSize: 12.sp,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Container(
      height: 2.h,
      width: 24.w,
      color: isActive ? AppColors.primary : AppColors.grey300,
    );
  }

  Widget _buildCurrentStep(ForgotPasswordViewModel viewModel) {
    switch (viewModel.currentStep) {
      case ForgotPasswordStep.enterEmail:
        return ForgotPasswordEmailStep(viewModel: viewModel);
      case ForgotPasswordStep.verifyOtp:
        return ForgotPasswordOtpStep(viewModel: viewModel);
      case ForgotPasswordStep.resetPassword:
        return ForgotPasswordResetStep(viewModel: viewModel);
      case ForgotPasswordStep.success:
        return ForgotPasswordSuccessStep(
          onBackToLogin: () {
            viewModel.reset();
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.login,
              (route) => false,
            );
          },
        );
    }
  }
}
