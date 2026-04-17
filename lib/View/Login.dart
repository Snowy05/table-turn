import 'package:flutter/material.dart';
import 'package:tableturn_project0/Controller/AuthService.dart';
import 'package:tableturn_project0/GlobalWidgets/LoginButton.dart';
import 'package:tableturn_project0/GlobalWidgets/WoodBackground.dart';
import 'package:tableturn_project0/GlobalWidgets/GlassCard.dart';
import 'package:tableturn_project0/GlobalWidgets/GlobalTextField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //logic
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WoodBackground(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: GlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GlobalTextField(
                            controller: _emailController,
                            labelText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 16.0),
                          GlobalTextField(
                            controller: _passwordController,
                            labelText: 'Password',
                            obscureText: true,
                          ),
                          SizedBox(height: 32.0),
                          Row(
                            children: [
                              LoginButton(
                                text: 'Back to Sign Up',
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/signup',
                                  );
                                },
                              ),
                              SizedBox(width: 16.0),
                              LoginButton(
                                text: 'Login',
                                onPressed: () async {
                                  try {
                                    await AuthService().signIn(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/dashboard',
                                    );
                                  } catch (e) {
                                    // Show error message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Login failed: $e'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
