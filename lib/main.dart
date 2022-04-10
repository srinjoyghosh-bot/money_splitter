import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/core/locator.dart';
import 'package:money_manager/core/router.dart';
import 'package:money_manager/core/view_models/authentication_viewmodel.dart';
import 'package:money_manager/ui/auth_view.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthenticationViewModel()),
      ],
      child: MaterialApp(
        title: 'Money-Manager',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AuthView.id,
      ),
    );
  }
}
