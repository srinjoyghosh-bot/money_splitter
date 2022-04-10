import 'package:flutter/material.dart';
import 'package:money_manager/core/constants/enum/view_state.dart';
import 'package:money_manager/core/view_models/authentication_viewmodel.dart';
import 'package:provider/provider.dart';

import 'home_view.dart';

class AuthView extends StatefulWidget {
  const AuthView({Key? key}) : super(key: key);
  static const String id = 'auth';

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _signUpFormKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();
  String name = '', email = '', phone = '', password = '';
  late AuthenticationViewModel _auth;

  void _onSaveSignup() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final isValid = _signUpFormKey.currentState?.validate();
    if (isValid == null || !isValid) {
      return;
    }
    _signUpFormKey.currentState?.save();
    final status = await _auth.signUp(email, password);
    if (status) {
      showSuccessSnackbar('Account created!');
    } else {
      showErrorSnackbar(_auth.errorMessage);
    }
  }

  void _onSaveLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final isValid = _loginFormKey.currentState?.validate();
    if (isValid == null || !isValid) {
      return;
    }
    _loginFormKey.currentState?.save();
    final status = await _auth.login(email, password);
    if (status) {
      showSuccessSnackbar('Successfully logged in');
      Navigator.pushReplacementNamed(context, HomeView.id);
    } else {
      showErrorSnackbar(_auth.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: _auth.isLogin ? const Text('Log in') : const Text('Sign up'),
        centerTitle: true,
      ),
      body: Center(
        child: _auth.state == ViewState.idle
            ? _auth.isLogin
                ? _buildLoginPage()
                : _buildSignUpPage()
            : const CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildSignUpPage() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value!.trim();
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value!.trim();
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'UPI ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'UPI VPA is required.';
                      } else if (value.split('@').length != 2) {
                        return 'Invalid UPI VPA';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value!.trim();
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value.trim()) != null ||
                          value.trim().length != 10) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phone = value!.trim();
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!.trim();
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      } else if (value.trim().length < 8) {
                        return 'Password must be of atleast 8 characters';
                      } else if (value.trim().contains(' ')) {
                        return 'Password must not contain spaces';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      password = value!.trim();
                    },
                  ),
                ],
              ),
              key: _signUpFormKey,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _onSaveSignup,
              child: const Text('Sign up'),
            ),
            // const SizedBox(height: 10),
            TextButton(
                onPressed: () {
                  _auth.switchAuthForm();
                },
                child: const Text(
                  'Already have an account? Log in!',
                  overflow: TextOverflow.ellipsis,
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildLoginPage() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value!.trim();
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.trim().length < 8) {
                      return 'Password must be of atleast 8 characters';
                    } else if (value.trim().contains(' ')) {
                      return 'Password must not contain spaces';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value!.trim();
                  },
                ),
              ],
            ),
            key: _loginFormKey,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _onSaveLogin,
            child: const Text('Log in'),
          ),
          TextButton(
              onPressed: () {
                _auth.switchAuthForm();
              },
              child: const Text(
                "Don't have an account? Sign up!",
                overflow: TextOverflow.ellipsis,
              ))
        ],
      ),
    );
  }

  void showErrorSnackbar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
    ));
  }

  void showSuccessSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green,
    ));
  }
}
