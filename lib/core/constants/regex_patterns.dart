/// Regular expression patterns for validation
class RegexPatterns {
  // Private constructor to prevent instantiation
  RegexPatterns._();

  // ============================================================================
  // AUTHENTICATION PATTERNS
  // ============================================================================
  /// Email pattern
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Username pattern (alphanumeric and underscore, 3-50 chars)
  static final RegExp usernameRegex = RegExp(
    r'^[a-zA-Z0-9_]{3,50}$',
  );

  /// Password pattern (at least 1 uppercase, 1 lowercase, 1 number, min 6 chars)
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$',
  );

  // ============================================================================
  // CONTACT PATTERNS
  // ============================================================================
  /// Phone number pattern (10-15 digits, optional +)
  static final RegExp phoneRegex = RegExp(
    r'^[+]?[0-9]{10,15}$',
  );

  /// Full name pattern (letters, spaces, hyphens, apostrophes)
  static final RegExp nameRegex = RegExp(
    r"^[a-zA-Z\s\-']{2,100}$",
  );

  // ============================================================================
  // URL PATTERNS
  // ============================================================================
  /// URL pattern (http or https)
  static final RegExp urlRegex = RegExp(
    r'^https?:\/\/.+$',
  );

  /// Image URL pattern
  static final RegExp imageUrlRegex = RegExp(
    r'^https?:\/\/.+\.(jpg|jpeg|png|gif|webp)$',
    caseSensitive: false,
  );

  // ============================================================================
  // NUMERIC PATTERNS
  // ============================================================================
  /// Integer pattern
  static final RegExp integerRegex = RegExp(
    r'^-?\d+$',
  );

  /// Positive integer pattern
  static final RegExp positiveIntegerRegex = RegExp(
    r'^\d+$',
  );

  /// Decimal pattern (with up to 2 decimal places)
  static final RegExp decimalRegex = RegExp(
    r'^\d+(\.\d{1,2})?$',
  );

  /// Positive decimal pattern
  static final RegExp positiveDecimalRegex = RegExp(
    r'^[0-9]+(\.[0-9]{1,2})?$',
  );

  /// Currency pattern (with comma separator)
  static final RegExp currencyRegex = RegExp(
    r'^\d{1,3}(,\d{3})*(\.\d{2})?$',
  );

  // ============================================================================
  // LOCATION PATTERNS
  // ============================================================================
  /// Latitude pattern (-90 to 90)
  static final RegExp latitudeRegex = RegExp(
    r'^-?([0-8]?[0-9]|90)(\.\d+)?$',
  );

  /// Longitude pattern (-180 to 180)
  static final RegExp longitudeRegex = RegExp(
    r'^-?(1[0-7][0-9]|[0-9]?[0-9])(\.\d+)?$',
  );

  // ============================================================================
  // CODE PATTERNS
  // ============================================================================
  /// Seal code pattern (alphanumeric, 3-50 chars)
  static final RegExp sealCodeRegex = RegExp(
    r'^[a-zA-Z0-9]{3,50}$',
  );

  /// Order ID pattern (alphanumeric and hyphens)
  static final RegExp orderIdRegex = RegExp(
    r'^[a-zA-Z0-9\-]{1,50}$',
  );

  /// Tracking code pattern
  static final RegExp trackingCodeRegex = RegExp(
    r'^[a-zA-Z0-9]{6,20}$',
  );

  // ============================================================================
  // DATE & TIME PATTERNS
  // ============================================================================
  /// Date pattern (YYYY-MM-DD)
  static final RegExp dateRegex = RegExp(
    r'^\d{4}-\d{2}-\d{2}$',
  );

  /// Time pattern (HH:MM:SS)
  static final RegExp timeRegex = RegExp(
    r'^([0-1][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$',
  );

  /// DateTime pattern (YYYY-MM-DD HH:MM:SS)
  static final RegExp dateTimeRegex = RegExp(
    r'^\d{4}-\d{2}-\d{2} ([0-1][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$',
  );

  // ============================================================================
  // SPECIAL PATTERNS
  // ============================================================================
  /// Alphanumeric pattern
  static final RegExp alphanumericRegex = RegExp(
    r'^[a-zA-Z0-9]+$',
  );

  /// Alphanumeric with spaces pattern
  static final RegExp alphanumericWithSpacesRegex = RegExp(
    r'^[a-zA-Z0-9\s]+$',
  );

  /// No special characters pattern
  static final RegExp noSpecialCharactersRegex = RegExp(
    r'^[a-zA-Z0-9\s\-\.]+$',
  );

  /// Whitespace pattern
  static final RegExp whitespaceRegex = RegExp(
    r'\s+',
  );

  /// Leading/trailing whitespace pattern
  static final RegExp leadingTrailingWhitespaceRegex = RegExp(
    r'^\s+|\s+$',
  );

  // ============================================================================
  // VALIDATION HELPER METHODS
  // ============================================================================
  /// Validate email
  static bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }

  /// Validate phone number
  static bool isValidPhone(String phone) {
    return phoneRegex.hasMatch(phone);
  }

  /// Validate password
  static bool isValidPassword(String password) {
    return passwordRegex.hasMatch(password);
  }

  /// Validate username
  static bool isValidUsername(String username) {
    return usernameRegex.hasMatch(username);
  }

  /// Validate URL
  static bool isValidUrl(String url) {
    return urlRegex.hasMatch(url);
  }

  /// Validate latitude
  static bool isValidLatitude(String latitude) {
    return latitudeRegex.hasMatch(latitude);
  }

  /// Validate longitude
  static bool isValidLongitude(String longitude) {
    return longitudeRegex.hasMatch(longitude);
  }

  /// Validate decimal number
  static bool isValidDecimal(String value) {
    return decimalRegex.hasMatch(value);
  }

  /// Validate integer
  static bool isValidInteger(String value) {
    return integerRegex.hasMatch(value);
  }
}
