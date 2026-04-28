import 'package:flutter/material.dart';
import 'package:tableturn_project0/Controller/AuthService.dart';
import 'package:tableturn_project0/GlobalWidgets/FriendlyMessageDialog.dart';
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

  Future<void> _showResetPasswordSentDialog(String email) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return FriendlyMessageDialog(
          title: 'Reset Email Sent',
          icon: Icons.mark_email_read_rounded,
          iconColor: Colors.green,
          secondaryActionLabel: 'Close',
          onSecondaryPressed: () => Navigator.of(dialogContext).pop(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('We have sent a password reset email to:'),
              const SizedBox(height: 10),
              Text(email, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              const Text(
                'Please check your inbox and follow the link to reset your password.',
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showForgotPasswordDialog() async {
    final resetEmailController = TextEditingController(
      text: _emailController.text.trim(),
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: TextField(
            controller: resetEmailController,
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await AuthService().resetPassword(resetEmailController.text);
                  if (!mounted) return;
                  Navigator.of(dialogContext).pop();
                  await _showResetPasswordSentDialog(
                    resetEmailController.text.trim(),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Password reset failed: $e')),
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WoodBackground(
        child: Stack(
          children: [
            // Logo image above the GlassCard
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/circularboardgamec.png',
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GlassCard(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            SizedBox(height: 24.0),
                            Center(
                              child: LoginButton(
                                text: 'Sign In',
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Login failed: $e'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 12.0),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 32,
                                right: 32,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    _showForgotPasswordDialog();
                                  },
                                  child: Text(
                                    'Forgot password?',
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 28.0),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: Text(
                                    'OR',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 28.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have an account? "),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/signup',
                                    );
                                  },
                                  child: Text(
                                    'Sign up here',
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}
