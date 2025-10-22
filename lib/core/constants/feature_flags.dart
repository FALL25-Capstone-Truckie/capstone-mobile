/// Feature flags for enabling/disabling features
class FeatureFlags {
  // Private constructor to prevent instantiation
  FeatureFlags._();

  // ============================================================================
  // AUTHENTICATION FEATURES
  // ============================================================================
  /// Enable biometric authentication
  static const bool enableBiometricAuth = false;

  /// Enable social login (Google, Facebook)
  static const bool enableSocialLogin = false;

  /// Enable remember me functionality
  static const bool enableRememberMe = true;

  // ============================================================================
  // LOCATION FEATURES
  // ============================================================================
  /// Enable real-time location tracking
  static const bool enableRealtimeLocationTracking = true;

  /// Enable background location tracking
  static const bool enableBackgroundLocationTracking = true;

  /// Enable location history
  static const bool enableLocationHistory = true;

  /// Enable geofencing
  static const bool enableGeofencing = false;

  // ============================================================================
  // ORDER FEATURES
  // ============================================================================
  /// Enable order notifications
  static const bool enableOrderNotifications = true;

  /// Enable order tracking
  static const bool enableOrderTracking = true;

  /// Enable order cancellation
  static const bool enableOrderCancellation = false;

  /// Enable order modification
  static const bool enableOrderModification = false;

  // ============================================================================
  // DELIVERY FEATURES
  // ============================================================================
  /// Enable photo capture for delivery
  static const bool enablePhotoCapture = true;

  /// Enable signature capture
  static const bool enableSignatureCapture = false;

  /// Enable delivery notes
  static const bool enableDeliveryNotes = true;

  /// Enable delivery proof
  static const bool enableDeliveryProof = true;

  // ============================================================================
  // PAYMENT FEATURES
  // ============================================================================
  /// Enable online payment
  static const bool enableOnlinePayment = false;

  /// Enable cash on delivery
  static const bool enableCashOnDelivery = true;

  /// Enable payment history
  static const bool enablePaymentHistory = false;

  // ============================================================================
  // COMMUNICATION FEATURES
  // ============================================================================
  /// Enable in-app messaging
  static const bool enableInAppMessaging = false;

  /// Enable customer support chat
  static const bool enableCustomerSupportChat = false;

  /// Enable push notifications
  static const bool enablePushNotifications = true;

  /// Enable SMS notifications
  static const bool enableSmsNotifications = false;

  // ============================================================================
  // ANALYTICS FEATURES
  // ============================================================================
  /// Enable analytics tracking
  static const bool enableAnalyticsTracking = true;

  /// Enable crash reporting
  static const bool enableCrashReporting = true;

  /// Enable performance monitoring
  static const bool enablePerformanceMonitoring = false;

  // ============================================================================
  // OFFLINE FEATURES
  // ============================================================================
  /// Enable offline mode
  static const bool enableOfflineMode = true;

  /// Enable offline data sync
  static const bool enableOfflineDataSync = true;

  /// Enable offline order caching
  static const bool enableOfflineOrderCaching = true;

  // ============================================================================
  // TESTING FEATURES
  // ============================================================================
  /// Enable mock WebSocket service
  static const bool enableMockWebSocket = false;

  /// Enable debug logging
  static const bool enableDebugLogging = true;

  /// Enable performance logging
  static const bool enablePerformanceLogging = false;

  /// Enable network logging
  static const bool enableNetworkLogging = false;

  // ============================================================================
  // EXPERIMENTAL FEATURES
  // ============================================================================
  /// Enable dark mode
  static const bool enableDarkMode = true;

  /// Enable multi-language support
  static const bool enableMultiLanguage = false;

  /// Enable accessibility features
  static const bool enableAccessibility = true;

  /// Enable voice commands
  static const bool enableVoiceCommands = false;

  /// Enable AR features
  static const bool enableARFeatures = false;

  // ============================================================================
  // MAINTENANCE FEATURES
  // ============================================================================
  /// Enable maintenance mode
  static const bool enableMaintenanceMode = false;

  /// Enable version check
  static const bool enableVersionCheck = true;

  /// Enable forced update
  static const bool enableForcedUpdate = false;
}
