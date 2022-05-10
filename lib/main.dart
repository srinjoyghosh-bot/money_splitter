import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/core/locator.dart';
import 'package:money_manager/core/router.dart';
import 'package:money_manager/core/view_models/authentication_viewmodel.dart';
import 'package:money_manager/core/view_models/group_viewmodel.dart';
import 'package:money_manager/ui/auth_view.dart';
import 'package:money_manager/ui/home_view.dart';
import 'package:provider/provider.dart';

import 'core/services/local_storage_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final LocalStorageService _service = locator<LocalStorageService>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthenticationViewModel()),
        ChangeNotifierProvider(create: (ctx) => GroupViewModel()),
      ],
      child: MaterialApp(
        title: 'Money-Manager',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: _service.isLoggedIn ? HomeView.id : AuthView.id,
      ),
    );
  }
}
