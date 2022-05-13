import 'package:flutter/material.dart';
import 'package:money_manager/ui/auth_view.dart';
import 'package:money_manager/ui/group_view.dart';
import 'package:money_manager/ui/home_view.dart';

import 'models/group.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeView.id:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case AuthView.id:
        return MaterialPageRoute(builder: (_) => const AuthView());
      case GroupView.id:
        return MaterialPageRoute(
            builder: (_) => GroupView(
                  group: settings.arguments as Group,
                ));

      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}
