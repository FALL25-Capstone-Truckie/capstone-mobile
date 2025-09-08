import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/services/system_ui_service.dart';
import '../../account/screens/account_screen.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../home/screens/home_screen.dart';
import '../../orders/screens/orders_screen.dart';
import '../../../theme/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Danh sách các màn hình tương ứng với từng tab
  final List<Widget> _screens = [
    const HomeScreen(),
    const OrdersScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AuthViewModel>(),
      child: Consumer<AuthViewModel>(
        builder: (context, authViewModel, _) {
          // Redirect to login if unauthenticated
          if (authViewModel.status == AuthStatus.unauthenticated) {
            // Use a post-frame callback to avoid build-time navigation
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/login');
            });
            // Return an empty container while redirecting
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Show a full-screen loading indicator if we're still in initial loading state
          if (authViewModel.status == AuthStatus.loading &&
              authViewModel.user == null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: AppColors.primary),
                    const SizedBox(height: 24),
                    Text(
                      'Đang tải thông tin...',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Show the main screen with bottom navigation
          return Scaffold(
            // Sử dụng SafeArea để đảm bảo nội dung không bị che bởi system insets
            body: SafeArea(
              // Đặt bottom: false để không tạo padding dưới cùng (vì đã xử lý trong bottomNavigationBar)
              bottom: false,
              child: IndexedStack(index: _selectedIndex, children: _screens),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              // Thêm padding dưới cùng để tránh nội dung bị che bởi navigation bar
              // trên các thiết bị Android cũ
              child: Padding(
                padding: SystemUiService.getBottomPadding(context),
                child: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  selectedItemColor: AppColors.primary,
                  unselectedItemColor: AppColors.textSecondary,
                  onTap: _onItemTapped,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Trang chủ',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.list_alt),
                      label: 'Đơn hàng',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Tài khoản',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
