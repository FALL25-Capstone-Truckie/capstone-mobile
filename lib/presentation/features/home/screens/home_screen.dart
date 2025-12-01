import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../core/services/system_ui_service.dart';
import '../../../../core/services/chat_notification_service.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../presentation/common_widgets/responsive_grid.dart';
import '../../../../presentation/common_widgets/responsive_layout_builder.dart';
import '../../../../presentation/common_widgets/skeleton_loader.dart';
import '../../../../presentation/features/auth/viewmodels/auth_viewmodel.dart';
import '../../chat/chat_screen.dart';
import '../widgets/index.dart';

/// Màn hình trang chủ của ứng dụng
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AuthViewModel _authViewModel;

  @override
  void initState() {
    super.initState();
    _authViewModel = getIt<AuthViewModel>();

    // Đảm bảo token được refresh khi vào màn hình
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_authViewModel.status == AuthStatus.authenticated) {
        _authViewModel.forceRefreshToken();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Tải lại thông tin tài xế khi màn hình được hiển thị lại
    if (_authViewModel.status == AuthStatus.authenticated) {
      _authViewModel.refreshDriverInfo();
    }
  }

  // Public method để refresh data từ bên ngoài
  void refreshHomeData() {
    if (_authViewModel.status == AuthStatus.authenticated) {
      // Force refresh token trước, sau đó refresh driver info
      _authViewModel.forceRefreshToken().then((success) {
        if (success) {
          _authViewModel.refreshDriverInfo();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _authViewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Truckie Driver'),
          centerTitle: true,
          automaticallyImplyLeading: false, // Loại bỏ nút back
          actions: [
            // Chat icon with badge
            Consumer<ChatNotificationService>(
              builder: (context, chatService, child) {
                final unreadCount = chatService.unreadCount;
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline),
                      onPressed: () {
                        chatService.markAsRead();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatScreen(
                              trackingCode: null,
                              vehicleAssignmentId: null,
                              fromTabNavigation: false,
                            ),
                          ),
                        );
                      },
                      tooltip: 'Hỗ trợ trực tuyến',
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Center(
                            child: Text(
                              unreadCount > 99 ? '99+' : unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
        body: Consumer<AuthViewModel>(
          builder: (context, authViewModel, _) {
            final user = authViewModel.user;
            final driver = authViewModel.driver;

            // Always show content, use skeleton loaders when data is not available
            return SafeArea(
              // Đặt bottom: false vì đã xử lý trong MainScreen
              bottom: false,
              child: SingleChildScrollView(
                // Thêm padding bottom để đảm bảo nội dung không bị che bởi navigation bar
                padding: SystemUiService.getContentPadding(context),
                child: ResponsiveLayoutBuilder(
                  builder: (context, sizingInformation) {
                    // Use different layouts based on screen size
                    if (sizingInformation.isTablet) {
                      // Tablet layout with 2 columns
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Driver info with skeleton loading
                          if (user == null || driver == null)
                            const DriverInfoSkeletonCard()
                          else
                            DriverInfoCard(user: user, driver: driver),
                          SizedBox(height: 24.h),

                          SizedBox(height: 16.h),

                          // Use ResponsiveGrid for tablet layout
                          ResponsiveGrid(
                            smallScreenColumns: 1,
                            mediumScreenColumns: 2,
                            largeScreenColumns: 2,
                            horizontalSpacing: 16.w,
                            verticalSpacing: 16.h,
                            children: [
                              // Statistics with skeleton loading
                              if (user == null || driver == null)
                                const StatisticsSkeletonCard()
                              else
                                const StatisticsCard(),

                              // Current delivery with skeleton loading
                              if (user == null || driver == null)
                                const DeliverySkeletonCard()
                              else
                                const CurrentDeliveryCard(),
                            ],
                          ),
                          SizedBox(height: 24.h),

                          // Recent orders with skeleton loading
                          if (user == null || driver == null)
                            const OrdersSkeletonList(itemCount: 2)
                          else
                            const RecentOrdersCard(),
                        ],
                      );
                    } else {
                      // Phone layout with single column
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Driver info with skeleton loading
                          if (user == null || driver == null)
                            const DriverInfoSkeletonCard()
                          else
                            DriverInfoCard(user: user, driver: driver),
                          SizedBox(height: 24.h),

                          // Statistics with skeleton loading
                          if (user == null || driver == null)
                            const StatisticsSkeletonCard()
                          else
                            const StatisticsCard(),
                          SizedBox(height: 24.h),

                          // Current delivery with skeleton loading
                          if (user == null || driver == null)
                            const DeliverySkeletonCard()
                          else
                            const CurrentDeliveryCard(),
                          SizedBox(height: 24.h),

                          // Recent orders with skeleton loading
                          if (user == null || driver == null)
                            const OrdersSkeletonList(itemCount: 2)
                          else
                            const RecentOrdersCard(),
                        ],
                      );
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
