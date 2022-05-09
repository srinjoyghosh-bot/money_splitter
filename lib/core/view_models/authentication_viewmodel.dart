import 'package:money_manager/core/constants/enum/view_state.dart';
import 'package:money_manager/core/services/authentication_service.dart';
import 'package:money_manager/core/view_models/base_viewmodel.dart';

import '../locator.dart';
import '../models/user.dart';
import '../services/database_service.dart';
import '../services/local_storage_service.dart';

class AuthenticationViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final LocalStorageService _storageService = locator<LocalStorageService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  bool _showLoginForm = false;

  bool get isLogin => _showLoginForm;

  void switchAuthForm() {
    _showLoginForm = !_showLoginForm;
    notifyListeners();
  }

  Future<bool> signUp(String email, String password, String name,
      String username, String phone, String upi) async {
    setState(ViewState.busy);
    final status = await _authService.createUser(
        email, password, name, username, phone, upi);
    if (status[0] == 'Success') {
      setState(ViewState.idle);
      User user = User(
          uid: status[1],
          name: name,
          username: username,
          email: email,
          password: password,
          phone: phone,
          upiId: upi);
      _databaseService.addUser(user);
      return true;
    } else {
      setErrorMessage(status[0]);
      setState(ViewState.idle);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    setState(ViewState.busy);
    final status = await _authService.loginUser(email, password);
    if (status == 'Success') {
      setState(ViewState.idle);
      _storageService.isLoggedIn = true;
      _storageService.currentUserId = _authService.getUserId()!;
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
      _storageService.isLoggedIn = false;
      _storageService.currentUserId = '';
      return true;
    } else {
      setErrorMessage(status);
      return false;
    }
  }
}
