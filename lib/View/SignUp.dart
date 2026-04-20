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
      resizeToAvoidBottomInset: true,
      body: WoodBackground(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                // Logo image above the GlassCard
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/circularboardgamec.png',
                        width: 140,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
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
                                    try {
                                      await AuthService().signUp(
                                        _emailController.text,
                                        _passwordController.text,
                                        _nameController.text,
                                        _phoneNumberController.text,
                                        _ageController.text,
                                      );
                                      // You can add navigation or success logic here
                                    } catch (e) {
                                      // Show error message
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Signup failed: $e'),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
