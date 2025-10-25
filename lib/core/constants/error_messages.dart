/// Error messages constants
class ErrorMessages {
  // Private constructor to prevent instantiation
  ErrorMessages._();

  // ============================================================================
  // AUTHENTICATION ERROR MESSAGES
  // ============================================================================
  static const String loginFailed = 'Đăng nhập thất bại';
  static const String logoutFailed = 'Đăng xuất thất bại';
  static const String changePasswordFailed = 'Đổi mật khẩu thất bại';
  static const String tokenRefreshFailed = 'Làm mới token thất bại';
  static const String invalidCredentials = 'Tên đăng nhập hoặc mật khẩu không chính xác';
  static const String unauthorized = 'Không có quyền truy cập';
  static const String tokenExpired = 'Token đã hết hạn';
  static const String noRefreshToken = 'Không tìm thấy refresh token';

  // ============================================================================
  // DRIVER ERROR MESSAGES
  // ============================================================================
  static const String getDriverInfoFailed = 'Không thể lấy thông tin tài xế';
  static const String updateDriverInfoFailed = 'Không thể cập nhật thông tin tài xế';
  static const String driverNotFound = 'Không tìm thấy thông tin tài xế';

  // ============================================================================
  // ORDER ERROR MESSAGES
  // ============================================================================
  static const String getOrdersFailed = 'Lỗi khi lấy danh sách đơn hàng';
  static const String getOrderDetailsFailed = 'Lỗi khi lấy chi tiết đơn hàng';
  static const String updateOrderStatusFailed = 'Lỗi khi cập nhật trạng thái đơn hàng';
  static const String completeDeliveryFailed = 'Lỗi khi hoàn thành chuyến xe';
  static const String orderNotFound = 'Không tìm thấy đơn hàng';
  static const String noOrders = 'Không có đơn hàng nào';

  // ============================================================================
  // LOADING DOCUMENTATION ERROR MESSAGES
  // ============================================================================
  static const String documentLoadingFailed = 'Lỗi khi gửi tài liệu đóng gói và seal';
  static const String sealCodeRequired = 'Vui lòng nhập mã seal';
  static const String packingProofImagesRequired = 'Vui lòng chọn ảnh chứng minh đóng gói';
  static const String sealImageRequired = 'Vui lòng chụp ảnh seal';

  // ============================================================================
  // PHOTO COMPLETION ERROR MESSAGES
  // ============================================================================
  static const String photoUploadFailed = 'Lỗi khi upload ảnh xác nhận';
  static const String photoCompressionFailed = 'Lỗi khi nén ảnh';
  static const String invalidImageFormat = 'Định dạng ảnh không hợp lệ';
  static const String imageSizeTooLarge = 'Kích thước ảnh quá lớn';

  // ============================================================================
  // VEHICLE FUEL CONSUMPTION ERROR MESSAGES
  // ============================================================================
  static const String updateOdometerFailed = 'Lỗi khi cập nhật đồng hồ cuối';
  static const String getFuelConsumptionFailed = 'Lỗi khi lấy thông tin nhiên liệu';
  static const String invalidOdometerReading = 'Số km không hợp lệ';
  static const String odometerImageRequired = 'Vui lòng chụp ảnh đồng hồ';

  // ============================================================================
  // NETWORK ERROR MESSAGES
  // ============================================================================
  static const String networkError = 'Lỗi kết nối đến máy chủ';
  static const String connectionTimeout = 'Kết nối bị timeout';
  static const String serverError = 'Lỗi máy chủ';
  static const String badRequest = 'Yêu cầu không hợp lệ';
  static const String forbidden = 'Không có quyền thực hiện hành động này';
  static const String notFound = 'Không tìm thấy tài nguyên';
  static const String serviceUnavailable = 'Dịch vụ tạm thời không khả dụng';

  // ============================================================================
  // LOCATION ERROR MESSAGES
  // ============================================================================
  static const String locationPermissionDenied = 'Quyền truy cập vị trí bị từ chối';
  static const String locationServiceDisabled = 'Dịch vụ định vị bị tắt';
  static const String locationUnavailable = 'Không thể xác định vị trí';
  static const String gpsSignalWeak = 'Tín hiệu GPS yếu';

  // ============================================================================
  // CACHE ERROR MESSAGES
  // ============================================================================
  static const String cacheError = 'Lỗi bộ nhớ cache';
  static const String userInfoNotFound = 'Không tìm thấy thông tin người dùng';
  static const String saveUserInfoFailed = 'Lỗi lưu thông tin người dùng';
  static const String clearUserInfoFailed = 'Lỗi xóa thông tin người dùng';

  // ============================================================================
  // GENERIC ERROR MESSAGES
  // ============================================================================
  static const String unknownError = 'Lỗi không xác định';
  static const String tryAgain = 'Vui lòng thử lại';
  static const String somethingWentWrong = 'Có lỗi xảy ra, vui lòng thử lại';
  static const String operationCancelled = 'Hành động bị hủy';
  static const String operationTimeout = 'Hành động bị timeout';
}
