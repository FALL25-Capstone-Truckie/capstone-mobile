/// Storage keys for SharedPreferences and secure storage
class StorageKeys {
  // Private constructor to prevent instantiation
  StorageKeys._();

  /// Authentication keys
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String isLoggedIn = 'is_logged_in';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';

  /// User preferences
  static const String languageCode = 'language_code';
  static const String themeMode = 'theme_mode';
  static const String notificationsEnabled = 'notifications_enabled';

  /// Navigation state
  static const String lastNavigationState = 'last_navigation_state';
  static const String activeOrderId = 'active_order_id';
  static const String isNavigating = 'is_navigating';

  /// Location tracking
  static const String locationTrackingEnabled = 'location_tracking_enabled';
  static const String lastKnownLatitude = 'last_known_latitude';
  static const String lastKnownLongitude = 'last_known_longitude';

  /// Cache keys
  static const String cachedDriverInfo = 'cached_driver_info';
  static const String cachedOrders = 'cached_orders';
  static const String lastSyncTimestamp = 'last_sync_timestamp';
}
