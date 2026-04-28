import 'package:flutter/material.dart';
import 'package:tableturn_project0/Controller/AuthService.dart';
import 'package:tableturn_project0/GlobalWidgets/FriendlyMessageDialog.dart';
import 'package:tableturn_project0/GlobalWidgets/WoodBackground.dart';
import 'package:tableturn_project0/GlobalWidgets/LoginButton.dart';
import 'package:tableturn_project0/GlobalWidgets/GlassCard.dart';
import 'package:tableturn_project0/GlobalWidgets/GlobalTextField.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //logic here
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _acceptedTermsOfUse = false;

  Future<void> _showSignUpValidationDialog({
    required String title,
    required String message,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return FriendlyMessageDialog(
          title: title,
          icon: Icons.warning_amber_rounded,
          iconColor: Colors.orange,
          secondaryActionLabel: 'Close',
          onSecondaryPressed: () => Navigator.of(dialogContext).pop(),
          content: Text(message),
        );
      },
    );
  }

  Future<void> _showTermsOfUseDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return FriendlyMessageDialog(
          title: 'Terms of Use',
          icon: Icons.gavel_rounded,
          iconColor: Colors.brown,
          secondaryActionLabel: 'Close',
          onSecondaryPressed: () => Navigator.of(dialogContext).pop(),
          content: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'By creating an account, you agree that TableTurn may collect and use your name, email address, phone number, age, booking activity, and loyalty activity to run the app and manage your account.',
                ),
                SizedBox(height: 12),
                Text(
                  'We use this information to create your profile, process bookings, support loyalty rewards, and send important account or reservation updates.',
                ),
                SizedBox(height: 12),
                Text(
                  'Your details are stored securely and are only used for service operations and legal or support needs. We do not sell your personal information.',
                ),
                SizedBox(height: 12),
                Text(
                  'You agree to provide accurate information, keep your login details safe, and use the app responsibly when making bookings or managing your account.',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showTermsRequiredDialog() async {
    await _showSignUpValidationDialog(
      title: 'Terms Acceptance Required',
      message: 'Please accept the Terms of Use before creating your account.',
    );
  }

  //testing game
  //   final game = GameModel(
  //   uid: '',
  //   gameName: 'Catan',
  //   minPlayers: 3,
  //   maxPlayers: 4,
  //   description: 'A classic strategy game.',
  //   // categories removed
  //   ageGroups: ['12+'],

  //   complexity: 'Medium',
  //   playTimes: ['1-2 hours'],
  //   tags: ['Classic', 'Strategy Game'],
  //   isAvailable: true,
  //   isAvailableForBooking: true,
  //   availabilityStatus: 'Available',
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: WoodBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0, bottom: 24),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/circularboardgamec.png',
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      GlassCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                                  SizedBox(height: 16.0),
                                  GlobalTextField(
                                    controller: _confirmPasswordController,
                                    labelText: 'Re-enter Password',
                                    obscureText: true,
                                  ),
                                  SizedBox(height: 16.0),
                                  GlobalTextField(
                                    controller: _nameController,
                                    labelText: 'Name',
                                  ),
                                  SizedBox(height: 16.0),
                                  GlobalTextField(
                                    controller: _phoneNumberController,
                                    labelText: 'Phone Number',
                                    keyboardType: TextInputType.phone,
                                  ),
                                  SizedBox(height: 16.0),
                                  GlobalTextField(
                                    controller: _ageController,
                                    labelText: 'Age',
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 12.0),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        value: _acceptedTermsOfUse,
                                        onChanged: (value) {
                                          setState(() {
                                            _acceptedTermsOfUse =
                                                value ?? false;
                                          });
                                        },
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 12,
                                          ),
                                          child: Wrap(
                                            children: [
                                              const Text('I agree to the '),
                                              GestureDetector(
                                                onTap: _showTermsOfUseDialog,
                                                child: Text(
                                                  'Terms of Use',
                                                  style: TextStyle(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                              ),
                                              const Text('.'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24.0),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 32,
                                      right: 32,
                                      top: 12,
                                    ),
                                    child: LoginButton(
                                      text: 'Sign Up',
                                      onPressed: () async {
                                        if (!_acceptedTermsOfUse) {
                                          await _showTermsRequiredDialog();
                                          return;
                                        }

                                        if (_passwordController.text !=
                                            _confirmPasswordController.text) {
                                          await _showSignUpValidationDialog(
                                            title: 'Passwords Do Not Match',
                                            message:
                                                'Please make sure your password and re-entered password match.',
                                          );
                                          return;
                                        }

                                        final age = int.tryParse(
                                          _ageController.text.trim(),
                                        );
                                        if (age == null) {
                                          await _showSignUpValidationDialog(
                                            title: 'Invalid Age',
                                            message:
                                                'Please enter a valid age before creating your account.',
                                          );
                                          return;
                                        }

                                        if (age < 18) {
                                          await _showSignUpValidationDialog(
                                            title: 'Age Requirement',
                                            message:
                                                'You must be 18 or older to create an account.',
                                          );
                                          return;
                                        }

                                        try {
                                          await AuthService().signUp(
                                            _emailController.text,
                                            _passwordController.text,
                                            _nameController.text,
                                            _phoneNumberController.text,
                                            _ageController.text,
                                          );
                                          if (!mounted) return;
                                          Navigator.pushReplacementNamed(
                                            context,
                                            '/dashboard',
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Signup failed: $e',
                                              ),
                                            ),
                                          );
                                        }
                                      },
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
                                      Text("Already have an account? "),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            '/login',
                                          );
                                        },
                                        child: Text(
                                          'Sign in here',
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
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
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
