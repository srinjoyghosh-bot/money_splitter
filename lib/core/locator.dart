import 'package:get_it/get_it.dart';
import 'package:money_manager/core/services/authentication_service.dart';
import 'package:money_manager/core/services/database_service.dart';
import 'package:money_manager/core/services/group_service.dart';
import 'package:money_manager/core/services/local_storage_service.dart';
import 'package:money_manager/core/view_models/authentication_viewmodel.dart';
import 'package:money_manager/core/view_models/group_viewmodel.dart';
import 'package:money_manager/core/view_models/home_viewmodel.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  final localStorageService = await LocalStorageService.getInstance();
  locator.registerSingleton<LocalStorageService>(localStorageService);

  locator.registerSingleton<AuthService>(AuthService());
  locator.registerSingleton<DatabaseService>(DatabaseService());
  locator.registerSingleton<GroupService>(GroupService());

  locator.registerFactory(() => AuthenticationViewModel());
  locator.registerFactory(() => HomeViewModel());
  locator.registerFactory(() => GroupViewModel());
}
