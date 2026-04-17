import 'package:flutter/material.dart';
import 'package:tableturn_project0/Controller/AuthService.dart';
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

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
                          SizedBox(height: 32.0),
                          Row(
                            children: [
                              LoginButton(
                                text: 'Back to Login',
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/login',
                                  );
                                },
                              ),
                              SizedBox(width: 16.0),
                              LoginButton(
                                text: 'Signup',
                                onPressed: () async {
                                  try {
                                    await AuthService().signUp(
                                      _emailController.text,
                                      _passwordController.text,
                                      _nameController.text,
                                      _phoneNumberController.text,
                                      _ageController.text,
                                    );
                                    // ...existing code...
                                  } catch (e) {
                                    // ...existing code...
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
