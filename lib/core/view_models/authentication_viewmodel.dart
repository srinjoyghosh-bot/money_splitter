import 'package:money_manager/core/constants/enum/view_state.dart';
import 'package:money_manager/core/services/authentication_service.dart';
import 'package:money_manager/core/view_models/base_viewmodel.dart';

import '../locator.dart';

class AuthenticationViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  bool _showLoginForm = false;

  bool get isLogin => _showLoginForm;

  void switchAuthForm() {
    _showLoginForm = !_showLoginForm;
    notifyListeners();
  }

  Future<bool> signUp(String email, String password) async {
    setState(ViewState.busy);
    final status = await _authService.createUser(email, password);
    if (status == 'Success') {
      setState(ViewState.idle);
      return true;
    } else {
      setErrorMessage(status);
      setState(ViewState.idle);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    setState(ViewState.busy);
    final status = await _authService.loginUser(email, password);
    if (status == 'Success') {
      setState(ViewState.idle);
      return true;
    } else {
      setState(ViewState.idle);
      setErrorMessage(status);
      return false;
    }
  }

  Future<bool> logout() async {
    final status = await _authService.logout();
    if (status == 'Success') {
      return true;
    } else {
      setErrorMessage(status);
      return false;
    }
  }
}
