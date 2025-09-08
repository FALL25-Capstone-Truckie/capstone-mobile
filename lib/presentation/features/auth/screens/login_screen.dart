import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../presentation/common_widgets/responsive_layout_builder.dart';
import '../../../../presentation/theme/app_colors.dart';
import '../../../../presentation/theme/app_text_styles.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AuthViewModel>(),
      child: Scaffold(
        body: ResponsiveLayoutBuilder(
          builder: (context, sizingInformation) {
            // Tablet layout
            if (sizingInformation.isTablet) {
              return Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 600.w),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(32.r),
                      child: _buildLoginForm(),
                    ),
                  ),
                ),
              );
            }
            // Phone layout
            else {
              return SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.r),
                    child: _buildLoginForm(),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          SizedBox(height: 32.h),
          _buildUsernameField(),
          SizedBox(height: 16.h),
          _buildPasswordField(),
          SizedBox(height: 8.h),
          _buildForgotPassword(),
          SizedBox(height: 24.h),
          _buildLoginButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(Icons.local_shipping, size: 80.r, color: AppColors.primary),
        SizedBox(height: 16.h),
        Text(
          'Truckie Driver',
          style: AppTextStyles.displayMedium.copyWith(color: AppColors.primary),
        ),
        SizedBox(height: 8.h),
        Text(
          'Đăng nhập để tiếp tục',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      decoration: InputDecoration(
        labelText: 'Tên đăng nhập',
        prefixIcon: Icon(Icons.person, size: 24.r),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập tên đăng nhập';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Mật khẩu',
        prefixIcon: Icon(Icons.lock, size: 24.r),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            size: 24.r,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      obscureText: !_isPasswordVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập mật khẩu';
        }
        return null;
      },
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // Quên mật khẩu được xử lý bởi admin
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vui lòng liên hệ admin để được hỗ trợ'),
              backgroundColor: AppColors.info,
            ),
          );
        },
        child: Text(
          'Quên mật khẩu?',
          style: TextStyle(color: AppColors.primary, fontSize: 14.sp),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, _) {
        final isLoading = authViewModel.status == AuthStatus.loading;

        return ElevatedButton(
          onPressed: isLoading ? null : () => _handleLogin(authViewModel),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            minimumSize: Size(double.infinity, 50.h),
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
              : Text('Đăng nhập', style: TextStyle(fontSize: 16.sp)),
        );
      },
    );
  }

  void _handleLogin(AuthViewModel authViewModel) async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      // Start login process
      final loginFuture = authViewModel.login(username, password);

      // Set a timeout for better UX
      bool hasTimedOut = false;

      // Wait for a short time to see if API responds quickly
      await Future.delayed(const Duration(milliseconds: 800), () {
        // If we're still loading after timeout, navigate immediately
        if (authViewModel.status == AuthStatus.loading && !hasTimedOut) {
          hasTimedOut = true;
          Navigator.pushReplacementNamed(context, '/main');
        }
      });

      // Wait for the login to complete
      final success = await loginFuture;

      if (!mounted) return;

      // If we haven't navigated yet due to timeout
      if (success && !hasTimedOut) {
        // Navigate to main screen with data already loaded
        Navigator.pushReplacementNamed(context, '/main');
      } else if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authViewModel.errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.fixed,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
