import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app.dart';
import 'core/services/service_locator.dart';
import 'core/services/system_ui_service.dart';
import 'core/utils/responsive_size_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cấu hình SystemChrome để xử lý thanh navigation bar
  SystemUiService.configureSystemUI();

  // Đảm bảo ứng dụng hiển thị tốt trên các thiết bị khác nhau
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Khởi tạo service locator
  await setupServiceLocator();

  runApp(const TruckieApp());
}
