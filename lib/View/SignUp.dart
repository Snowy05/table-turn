import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tableturn_project0/Controller/AuthService.dart';
import 'package:tableturn_project0/Controller/GameService.dart';
import 'package:tableturn_project0/GlobalWidgets/WoodBackground.dart';
import 'package:tableturn_project0/Model/gameModel.dart';
import 'package:tableturn_project0/GlobalWidgets/LoginButton.dart';
import 'package:tableturn_project0/GlobalWidgets/GlassCard.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
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
  //   imageAsset: 'assets/images/catan.jpg',
  //   imageUrl: '',
  //   complexity: 'Medium',
  //   playTimes: ['1-2 hours'],
  //   tags: ['Classic', 'Strategy Game'],
  //   isAvailable: true,
  //   isAvailableForBooking: true,
  //   availabilityStatus: 'Available',
  //   quantityInStock: 5,
  // );

  Widget build(BuildContext context) {
    return Scaffold(
      body: WoodBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
              SizedBox(height: 16.0),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 32.0),
              Row(
                children: [
                  //Testing purposes, adding games
                  // LoginButton(text: 'Add game', onPressed: () async{
                  //   try{
                  //     await Gameservice().addGame(game);
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(content: Text('Game added successfully')),
                  //     );
                  //   }catch(e){
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(content: Text('Failed to add game: $e')),
                  //     );
                  //   }
                  // }),
                  LoginButton(
                    text: 'Back to Login',
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                  SizedBox(width: 16.0),
                  LoginButton(
                    text: 'Signup',
                    onPressed: () async {
                      try {
                        UserCredential userCredential = await AuthService()
                            .signUp(
                              _emailController.text,
                              _passwordController.text,
                              _nameController.text,
                              _phoneNumberController.text,
                              _ageController.text,
                            );
                        //if signup success go to login page else show error message
                        Navigator.pushReplacementNamed(context, '/dashboard');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sign up failed: $e')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
            ]
          )
        )
      )
    );
  }
}
