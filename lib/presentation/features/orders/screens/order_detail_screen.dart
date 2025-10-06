import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/services/system_ui_service.dart';
import '../../../../presentation/theme/app_colors.dart';
import '../../../features/auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/order_detail_viewmodel.dart';
import '../widgets/order_detail/index.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late final OrderDetailViewModel _viewModel;
  late final AuthViewModel _authViewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<OrderDetailViewModel>();
    _authViewModel = getIt<AuthViewModel>();
    _loadOrderDetails();
  }

  Future<void> _loadOrderDetails() async {
    await _viewModel.getOrderDetails(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _viewModel),
        ChangeNotifierProvider.value(value: _authViewModel),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chi tiết đơn hàng'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: Consumer2<OrderDetailViewModel, AuthViewModel>(
          builder: (context, viewModel, authViewModel, _) {
            switch (viewModel.state) {
              case OrderDetailState.loading:
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              case OrderDetailState.error:
                return ErrorView(
                  message: viewModel.errorMessage,
                  onRetry: _loadOrderDetails,
                );
              case OrderDetailState.loaded:
                if (viewModel.orderWithDetails == null) {
                  return ErrorView(
                    message: 'Không tìm thấy thông tin đơn hàng',
                    onRetry: _loadOrderDetails,
                  );
                }
                return _buildOrderDetailContent(viewModel);
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildOrderDetailContent(OrderDetailViewModel viewModel) {
    final orderWithDetails = viewModel.orderWithDetails!;

    return SingleChildScrollView(
      padding: SystemUiService.getContentPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderInfoSection(order: orderWithDetails),
          SizedBox(height: 16),
          TrackingCodeSection(order: orderWithDetails),
          SizedBox(height: 16),
          AddressSection(order: orderWithDetails),
          SizedBox(height: 16),
          JourneyTimeSection(order: orderWithDetails),
          SizedBox(height: 16),
          SenderSection(order: orderWithDetails),
          SizedBox(height: 16),
          ReceiverSection(order: orderWithDetails),
          SizedBox(height: 16),
          PackageSection(order: orderWithDetails),
          SizedBox(height: 24),
          RouteMapSection(viewModel: viewModel),
          SizedBox(height: 24),
          VehicleSection(order: orderWithDetails),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
