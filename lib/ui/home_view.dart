import 'package:flutter/material.dart';
import 'package:money_manager/core/view_models/authentication_viewmodel.dart';
import 'package:money_manager/ui/auth_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  static const String id = 'home';

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      Text('Log out'),
                    ],
                  ),
                  value: 0,
                )
              ];
            },
            onSelected: (value) async {
              switch (value) {
                case 0:
                  bool logoutStatus =
                      await Provider.of<AuthenticationViewModel>(context,
                              listen: false)
                          .logout();
                  if (logoutStatus) {
                    Navigator.pushReplacementNamed(context, AuthView.id);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Logged out!'),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.green,
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          Provider.of<AuthenticationViewModel>(context)
                              .errorMessage),
                      duration: const Duration(seconds: 3),
                      backgroundColor: Colors.red,
                    ));
                  }
              }
            },
          )
        ],
      ),
      body: const Center(
        child: Text('Home'),
      ),
    );
  }
}
