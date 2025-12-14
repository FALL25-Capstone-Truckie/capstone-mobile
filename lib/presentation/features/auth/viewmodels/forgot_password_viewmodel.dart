import '../../../../core/errors/exceptions.dart';
import '../../../../data/datasources/auth_data_source.dart';
import '../../../common_widgets/base_viewmodel.dart';

enum ForgotPasswordStep { enterEmail, verifyOtp, resetPassword, success }

enum ForgotPasswordStatus { initial, loading, success, error }

class ForgotPasswordViewModel extends BaseViewModel {
  final AuthDataSource _authDataSource;

  ForgotPasswordViewModel({required AuthDataSource authDataSource})
      : _authDataSource = authDataSource;

  ForgotPasswordStep _currentStep = ForgotPasswordStep.enterEmail;
  ForgotPasswordStatus _status = ForgotPasswordStatus.initial;
  String _errorMessage = '';
  String _email = '';
  String _resetToken = '';

  ForgotPasswordStep get currentStep => _currentStep;
  ForgotPasswordStatus get status => _status;
  String get errorMessage => _errorMessage;
  String get email => _email;

  void setEmail(String email) {
    _email = email;
  }

  void reset() {
    _currentStep = ForgotPasswordStep.enterEmail;
    _status = ForgotPasswordStatus.initial;
    _errorMessage = '';
    _email = '';
    _resetToken = '';
    notifyListeners();
  }

  Future<bool> sendOtp(String email) async {
    _status = ForgotPasswordStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _email = email;
      await _authDataSource.sendForgotPasswordOtp(email);
      _status = ForgotPasswordStatus.success;
      _currentStep = ForgotPasswordStep.verifyOtp;
      notifyListeners();
      return true;
    } on ServerException catch (e) {
      _status = ForgotPasswordStatus.error;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _status = ForgotPasswordStatus.error;
      _errorMessage = 'Đã xảy ra lỗi. Vui lòng thử lại.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtp(String otp) async {
    _status = ForgotPasswordStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final resetToken = await _authDataSource.verifyForgotPasswordOtp(_email, otp);
      if (resetToken != null && resetToken.isNotEmpty) {
        _resetToken = resetToken;
        _status = ForgotPasswordStatus.success;
        _currentStep = ForgotPasswordStep.resetPassword;
        notifyListeners();
        return true;
      } else {
        _status = ForgotPasswordStatus.error;
        _errorMessage = 'Mã OTP không hợp lệ hoặc đã hết hạn';
        notifyListeners();
        return false;
      }
    } on ServerException catch (e) {
      _status = ForgotPasswordStatus.error;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _status = ForgotPasswordStatus.error;
      _errorMessage = 'Xác thực OTP thất bại. Vui lòng thử lại.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword(String newPassword, String confirmPassword) async {
    _status = ForgotPasswordStatus.loading;
    _errorMessage = '';
    notifyListeners();

    if (newPassword != confirmPassword) {
      _status = ForgotPasswordStatus.error;
      _errorMessage = 'Mật khẩu xác nhận không khớp';
      notifyListeners();
      return false;
    }

    if (newPassword.length < 6) {
      _status = ForgotPasswordStatus.error;
      _errorMessage = 'Mật khẩu phải có ít nhất 6 ký tự';
      notifyListeners();
      return false;
    }

    try {
      await _authDataSource.resetPassword(
        _email,
        _resetToken,
        newPassword,
        confirmPassword,
      );
      _status = ForgotPasswordStatus.success;
      _currentStep = ForgotPasswordStep.success;
      notifyListeners();
      return true;
    } on ServerException catch (e) {
      _status = ForgotPasswordStatus.error;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _status = ForgotPasswordStatus.error;
      _errorMessage = 'Đổi mật khẩu thất bại. Vui lòng thử lại.';
      notifyListeners();
      return false;
    }
  }

  void goBack() {
    switch (_currentStep) {
      case ForgotPasswordStep.verifyOtp:
        _currentStep = ForgotPasswordStep.enterEmail;
        break;
      case ForgotPasswordStep.resetPassword:
        _currentStep = ForgotPasswordStep.verifyOtp;
        break;
      default:
        break;
    }
    _status = ForgotPasswordStatus.initial;
    _errorMessage = '';
    notifyListeners();
  }
}
