/// Duration constants for animations and transitions
class DurationConstants {
  // Private constructor to prevent instantiation
  DurationConstants._();

  // ============================================================================
  // ANIMATION DURATIONS
  // ============================================================================
  /// Extra short animation (100ms)
  static const Duration animationExtraShort = Duration(milliseconds: 100);

  /// Short animation (200ms)
  static const Duration animationShort = Duration(milliseconds: 200);

  /// Medium animation (300ms)
  static const Duration animationMedium = Duration(milliseconds: 300);

  /// Long animation (500ms)
  static const Duration animationLong = Duration(milliseconds: 500);

  /// Extra long animation (800ms)
  static const Duration animationExtraLong = Duration(milliseconds: 800);

  // ============================================================================
  // TRANSITION DURATIONS
  // ============================================================================
  /// Page transition (300ms)
  static const Duration pageTransition = Duration(milliseconds: 300);

  /// Modal transition (250ms)
  static const Duration modalTransition = Duration(milliseconds: 250);

  /// Fade transition (200ms)
  static const Duration fadeTransition = Duration(milliseconds: 200);

  /// Slide transition (300ms)
  static const Duration slideTransition = Duration(milliseconds: 300);

  /// Scale transition (200ms)
  static const Duration scaleTransition = Duration(milliseconds: 200);

  // ============================================================================
  // DEBOUNCE & THROTTLE DURATIONS
  // ============================================================================
  /// Debounce duration for search (500ms)
  static const Duration debounceSearch = Duration(milliseconds: 500);

  /// Debounce duration for text input (300ms)
  static const Duration debounceTextInput = Duration(milliseconds: 300);

  /// Throttle duration for scroll (100ms)
  static const Duration throttleScroll = Duration(milliseconds: 100);

  /// Throttle duration for button tap (300ms)
  static const Duration throttleButtonTap = Duration(milliseconds: 300);

  // ============================================================================
  // DELAY DURATIONS
  // ============================================================================
  /// Splash screen delay (2 seconds)
  static const Duration splashScreenDelay = Duration(seconds: 2);

  /// Toast duration (3 seconds)
  static const Duration toastDuration = Duration(seconds: 3);

  /// Snackbar duration (4 seconds)
  static const Duration snackbarDuration = Duration(seconds: 4);

  /// Loading indicator delay (500ms)
  static const Duration loadingIndicatorDelay = Duration(milliseconds: 500);

  /// Retry delay (1 second)
  static const Duration retryDelay = Duration(seconds: 1);

  // ============================================================================
  // POLLING DURATIONS
  // ============================================================================
  /// Location update interval (5 seconds)
  static const Duration locationUpdateInterval = Duration(seconds: 5);

  /// Order status check interval (10 seconds)
  static const Duration orderStatusCheckInterval = Duration(seconds: 10);

  /// WebSocket reconnect delay (5 seconds)
  static const Duration wsReconnectDelay = Duration(seconds: 5);

  /// Data sync interval (30 seconds)
  static const Duration dataSyncInterval = Duration(seconds: 30);

  // ============================================================================
  // TIMEOUT DURATIONS
  // ============================================================================
  /// API request timeout (30 seconds)
  static const Duration apiRequestTimeout = Duration(seconds: 30);

  /// Location service timeout (10 seconds)
  static const Duration locationServiceTimeout = Duration(seconds: 10);

  /// Image upload timeout (60 seconds)
  static const Duration imageUploadTimeout = Duration(seconds: 60);

  /// WebSocket connection timeout (15 seconds)
  static const Duration wsConnectionTimeout = Duration(seconds: 15);

  // ============================================================================
  // HOLD DURATIONS
  // ============================================================================
  /// Long press duration (500ms)
  static const Duration longPressDuration = Duration(milliseconds: 500);

  /// Double tap duration (300ms)
  static const Duration doubleTapDuration = Duration(milliseconds: 300);

  // ============================================================================
  // CACHE DURATIONS
  // ============================================================================
  /// Cache duration (1 hour)
  static const Duration cacheDuration = Duration(hours: 1);

  /// Cache duration (24 hours)
  static const Duration cacheDuration24Hours = Duration(hours: 24);

  /// Cache duration (7 days)
  static const Duration cacheDuration7Days = Duration(days: 7);

  /// Session timeout (30 minutes)
  static const Duration sessionTimeout = Duration(minutes: 30);

  // ============================================================================
  // REFRESH DURATIONS
  // ============================================================================
  /// Token refresh interval (before expiry)
  static const Duration tokenRefreshInterval = Duration(minutes: 5);

  /// Auto-refresh interval (5 minutes)
  static const Duration autoRefreshInterval = Duration(minutes: 5);

  // ============================================================================
  // HAPTIC FEEDBACK DURATIONS
  // ============================================================================
  /// Light haptic duration (10ms)
  static const Duration hapticLight = Duration(milliseconds: 10);

  /// Medium haptic duration (20ms)
  static const Duration hapticMedium = Duration(milliseconds: 20);

  /// Heavy haptic duration (30ms)
  static const Duration hapticHeavy = Duration(milliseconds: 30);
}
