import 'package:get_it/get_it.dart';
import 'package:money_manager/core/services/authentication_service.dart';
import 'package:money_manager/core/view_models/authentication_viewmodel.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<AuthService>(AuthService());
  locator.registerFactory(() => AuthenticationViewModel());
}
