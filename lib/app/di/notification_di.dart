import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

// Core dependencies
import '../../data/datasources/api_client.dart';

// Domain Layer
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/notification/get_notifications_usecase.dart';
import '../../domain/usecases/notification/mark_notification_read_usecase.dart';
import '../../domain/usecases/notification/get_notification_stats_usecase.dart';

// Data Layer
import '../../data/datasources/notification_remote_data_source.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../data/models/notification_model.dart';

// Presentation Layer
import '../../presentation/features/notification/viewmodels/notification_viewmodel.dart';

// Services
import '../../core/services/api_service.dart';
import '../../core/services/token_storage_service.dart';

/// Dependency Injection for Notification System
class NotificationDI {
  static Future<void> init() async {
    final getIt = GetIt.instance;

    print('🔧 [NotificationDI] Starting initialization...');
    print('🔧 [NotificationDI] Dio registered: ${getIt.isRegistered<Dio>()}');
    print(
      '🔧 [NotificationDI] ApiService registered: ${getIt.isRegistered<ApiService>()}',
    );
    print(
      '🔧 [NotificationDI] TokenStorageService registered: ${getIt.isRegistered<TokenStorageService>()}',
    );

    // RESET all notification-related services to avoid conflicts
    _resetNotificationServices(getIt);

    print('🔧 [NotificationDI] Reset complete, registering services...');

    // Core dependencies - check if already registered
    if (!getIt.isRegistered<Dio>()) {
      print('🔧 [NotificationDI] Registering Dio...');
      getIt.registerLazySingleton<Dio>(() => Dio());
    }
    // TokenStorageService and ApiService already registered in service_locator.dart - DO NOT register again!

    // Data Sources
    print('🔧 [NotificationDI] Registering NotificationRemoteDataSource...');
    getIt.registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
    );

    // Repositories
    if (!getIt.isRegistered<NotificationRepository>()) {
      getIt.registerLazySingleton<NotificationRepository>(
        () => NotificationRepositoryImpl(
          remoteDataSource: getIt<NotificationRemoteDataSource>(),
        ),
      );
    }

    // Use Cases
    if (!getIt.isRegistered<GetNotificationsUseCase>()) {
      getIt.registerLazySingleton<GetNotificationsUseCase>(
        () => GetNotificationsUseCase(getIt<NotificationRepository>()),
      );
    }

    if (!getIt.isRegistered<MarkNotificationReadUseCase>()) {
      getIt.registerLazySingleton<MarkNotificationReadUseCase>(
        () => MarkNotificationReadUseCase(getIt<NotificationRepository>()),
      );
    }

    if (!getIt.isRegistered<GetNotificationStatsUseCase>()) {
      getIt.registerLazySingleton<GetNotificationStatsUseCase>(
        () => GetNotificationStatsUseCase(getIt<NotificationRepository>()),
      );
    }

    // ViewModels - Factory can be registered multiple times, but let's check anyway
    if (!getIt.isRegistered<NotificationViewModel>()) {
      getIt.registerFactory<NotificationViewModel>(
        () => NotificationViewModel(
          getNotificationsUseCase: getIt<GetNotificationsUseCase>(),
          markNotificationReadUseCase: getIt<MarkNotificationReadUseCase>(),
          getNotificationStatsUseCase: getIt<GetNotificationStatsUseCase>(),
        ),
      );
    }

    print('✅ [NotificationDI] Initialized successfully');
  }

  /// Reset all notification-related services to avoid conflicts during hot reload
  static void _resetNotificationServices(GetIt getIt) {
    print('🔄 [NotificationDI] Resetting notification services...');

    // Unregister in reverse order of dependencies
    if (getIt.isRegistered<NotificationViewModel>()) {
      getIt.unregister<NotificationViewModel>();
      print('   ✓ Unregistered NotificationViewModel');
    }

    if (getIt.isRegistered<GetNotificationStatsUseCase>()) {
      getIt.unregister<GetNotificationStatsUseCase>();
      print('   ✓ Unregistered GetNotificationStatsUseCase');
    }

    if (getIt.isRegistered<MarkNotificationReadUseCase>()) {
      getIt.unregister<MarkNotificationReadUseCase>();
      print('   ✓ Unregistered MarkNotificationReadUseCase');
    }

    if (getIt.isRegistered<GetNotificationsUseCase>()) {
      getIt.unregister<GetNotificationsUseCase>();
      print('   ✓ Unregistered GetNotificationsUseCase');
    }

    if (getIt.isRegistered<NotificationRepository>()) {
      getIt.unregister<NotificationRepository>();
      print('   ✓ Unregistered NotificationRepository');
    }

    if (getIt.isRegistered<NotificationRemoteDataSource>()) {
      getIt.unregister<NotificationRemoteDataSource>();
      print('   ✓ Unregistered NotificationRemoteDataSource');
    }

    print('🔄 [NotificationDI] Reset complete');
  }
}
