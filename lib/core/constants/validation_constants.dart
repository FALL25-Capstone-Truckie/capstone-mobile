/// Validation constants for input validation
class ValidationConstants {
  // Private constructor to prevent instantiation
  ValidationConstants._();

  // ============================================================================
  // USERNAME VALIDATION
  // ============================================================================
  /// Minimum username length
  static const int minUsernameLength = 3;

  /// Maximum username length
  static const int maxUsernameLength = 50;

  /// Username regex pattern (alphanumeric and underscore)
  static const String usernamePattern = r'^[a-zA-Z0-9_]{3,50}$';

  // ============================================================================
  // PASSWORD VALIDATION
  // ============================================================================
  /// Minimum password length
  static const int minPasswordLength = 6;

  /// Maximum password length
  static const int maxPasswordLength = 128;

  /// Password regex pattern (at least 1 uppercase, 1 lowercase, 1 number)
  static const String passwordPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$';

  // ============================================================================
  // EMAIL VALIDATION
  // ============================================================================
  /// Email regex pattern
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  // ============================================================================
  // PHONE NUMBER VALIDATION
  // ============================================================================
  /// Minimum phone number length
  static const int minPhoneLength = 10;

  /// Maximum phone number length
  static const int maxPhoneLength = 15;

  /// Phone number regex pattern (digits and optional +)
  static const String phonePattern = r'^[+]?[0-9]{10,15}$';

  // ============================================================================
  // NAME VALIDATION
  // ============================================================================
  /// Minimum name length
  static const int minNameLength = 2;

  /// Maximum name length
  static const int maxNameLength = 100;

  /// Name regex pattern (letters, spaces, hyphens)
  static const String namePattern = r"^[a-zA-Z\s\-']{2,100}$";

  // ============================================================================
  // URL VALIDATION
  // ============================================================================
  /// URL regex pattern
  static const String urlPattern = r'^https?:\/\/.+$';

  // ============================================================================
  // NUMERIC VALIDATION
  // ============================================================================
  /// Minimum odometer reading
  static const double minOdometerReading = 0.0;

  /// Maximum odometer reading
  static const double maxOdometerReading = 999999.9;

  /// Minimum fuel consumption
  static const double minFuelConsumption = 0.0;

  /// Maximum fuel consumption
  static const double maxFuelConsumption = 100.0;

  // ============================================================================
  // LOCATION VALIDATION
  // ============================================================================
  /// Minimum latitude
  static const double minLatitude = -90.0;

  /// Maximum latitude
  static const double maxLatitude = 90.0;

  /// Minimum longitude
  static const double minLongitude = -180.0;

  /// Maximum longitude
  static const double maxLongitude = 180.0;

  /// Minimum accuracy (meters)
  static const double minLocationAccuracy = 0.0;

  /// Maximum accuracy (meters)
  static const double maxLocationAccuracy = 100.0;

  // ============================================================================
  // FILE VALIDATION
  // ============================================================================
  /// Maximum image file size (10MB)
  static const int maxImageFileSize = 10 * 1024 * 1024;

  /// Maximum document file size (50MB)
  static const int maxDocumentFileSize = 50 * 1024 * 1024;

  /// Allowed image extensions
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'gif'];

  /// Allowed document extensions
  static const List<String> allowedDocumentExtensions = ['pdf', 'doc', 'docx', 'xls', 'xlsx'];

  // ============================================================================
  // SEAL CODE VALIDATION
  // ============================================================================
  /// Minimum seal code length
  static const int minSealCodeLength = 3;

  /// Maximum seal code length
  static const int maxSealCodeLength = 50;

  /// Seal code regex pattern (alphanumeric)
  static const String sealCodePattern = r'^[a-zA-Z0-9]{3,50}$';

  // ============================================================================
  // ORDER ID VALIDATION
  // ============================================================================
  /// Minimum order ID length
  static const int minOrderIdLength = 1;

  /// Maximum order ID length
  static const int maxOrderIdLength = 50;

  // ============================================================================
  // DELIVERY DISTANCE VALIDATION
  // ============================================================================
  /// Nearby delivery distance (3km)
  static const double nearbyDeliveryDistance = 3000.0; // meters

  /// Arrival threshold distance (100m)
  static const double arrivalThresholdDistance = 100.0; // meters

  // ============================================================================
  // ERROR MESSAGE LENGTHS
  // ============================================================================
  /// Minimum error message length
  static const int minErrorMessageLength = 1;

  /// Maximum error message length
  static const int maxErrorMessageLength = 500;

  // ============================================================================
  // VALIDATION MESSAGES
  // ============================================================================
  /// Required field message
  static const String messageRequired = 'Trường này là bắt buộc';

  /// Invalid email message
  static const String messageInvalidEmail = 'Email không hợp lệ';

  /// Invalid phone message
  static const String messageInvalidPhone = 'Số điện thoại không hợp lệ';

  /// Password too short message
  static const String messagePasswordTooShort = 'Mật khẩu phải có ít nhất 6 ký tự';

  /// Password mismatch message
  static const String messagePasswordMismatch = 'Mật khẩu không trùng khớp';

  /// Username taken message
  static const String messageUsernameTaken = 'Tên đăng nhập đã được sử dụng';

  /// File too large message
  static const String messageFileTooLarge = 'Tệp quá lớn';

  /// Invalid file type message
  static const String messageInvalidFileType = 'Loại tệp không được phép';
}
