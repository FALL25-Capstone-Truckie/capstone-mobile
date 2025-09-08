import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/utils/responsive_size_utils.dart';
import '../presentation/theme/app_theme.dart';
import 'app_router.dart';

class TruckieApp extends StatelessWidget {
  const TruckieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Truckie Driver',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme.copyWith(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppTheme.lightTheme.appBarTheme.copyWith(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.transparent,
          ),
        ),
        // Cấu hình để xử lý bottom padding cho navigation bar
        bottomNavigationBarTheme: AppTheme.lightTheme.bottomNavigationBarTheme
            .copyWith(elevation: 8),
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        appBarTheme: AppTheme.darkTheme.appBarTheme.copyWith(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.transparent,
          ),
        ),
      ),
      themeMode: ThemeMode.light,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi', 'VN'), // Vietnamese
      ],
      locale: const Locale('vi', 'VN'),
      initialRoute: '/login',
      onGenerateRoute: AppRouter.onGenerateRoute,
      builder: (context, child) {
        // Initialize responsive size utils
        ResponsiveSizeUtils().init(context);

        // Đảm bảo toàn bộ ứng dụng được padding đúng với system insets
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Apply text scaling factor limit to ensure text doesn't get too large
            textScaleFactor: MediaQuery.of(
              context,
            ).textScaleFactor.clamp(0.8, 1.2),
            padding: MediaQuery.of(
              context,
            ).padding.copyWith(bottom: MediaQuery.of(context).padding.bottom),
          ),
          child: child!,
        );
      },
    );
  }
}
