import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:tableturn_project0/GlobalWidgets/BottomNav.dart';
import 'package:tableturn_project0/Model/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:tableturn_project0/View/Profile/ProfileCard.dart'
    show ProfileCard;

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _editingName = false;
  bool _editingPhone = false;
  final ImagePicker _picker = ImagePicker();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _profilePicUrl;
  String? _newProfilePicPath;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return SizedBox.shrink();
    }
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('Failed to load user data'));
        }
        final appUser = AppUser.fromMap(
          snapshot.data!.data() as Map<String, dynamic>,
          snapshot.data!.id,
        );
        if (_nameController.text.isEmpty) _nameController.text = appUser.name;
        if (_phoneController.text.isEmpty)
          _phoneController.text = appUser.phoneNumber;
        _profilePicUrl ??= appUser.profilePicUrl;
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ProfileCard(
                profilePicUrl: _profilePicUrl,
                newProfilePicPath: _newProfilePicPath,
                onProfilePicTap: () async {
                  final picked = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (picked != null) {
                    setState(() {
                      _newProfilePicPath = picked.path;
                    });
                  }
                },
                nameController: _nameController,
                phoneController: _phoneController,
                editingName: _editingName,
                editingPhone: _editingPhone,
                onEditName: () {
                  setState(() {
                    _editingName = !_editingName;
                  });
                },
                onEditPhone: () {
                  setState(() {
                    _editingPhone = !_editingPhone;
                  });
                },
                onCancelEditName: () {
                  setState(() {
                    _nameController.text = appUser.name;
                    _editingName = false;
                  });
                },
                onCancelEditPhone: () {
                  setState(() {
                    _phoneController.text = appUser.phoneNumber;
                    _editingPhone = false;
                  });
                },
                onSave: _isSaving
                    ? null
                    : () async {
                        setState(() {
                          _isSaving = true;
                        });
                        String? uploadedPicUrl = _profilePicUrl;
                        if (_newProfilePicPath != null) {
                          try {
                            final storageRef = FirebaseStorage.instance
                                .ref()
                                .child('profile_pics/${user.uid}.jpg');
                            await storageRef.putFile(File(_newProfilePicPath!));
                            uploadedPicUrl = await storageRef.getDownloadURL();
                          } catch (e) {}
                        }
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .update({
                              'name': _nameController.text.trim(),
                              'phoneNumber': _phoneController.text.trim(),
                              if (uploadedPicUrl != null)
                                'profilePicUrl': uploadedPicUrl,
                            });
                        if (_nameController.text.trim() !=
                            (user.displayName ?? '')) {
                          await user.updateDisplayName(
                            _nameController.text.trim(),
                          );
                        }
                        setState(() {
                          _isSaving = false;
                          _profilePicUrl = uploadedPicUrl;
                          _newProfilePicPath = null;
                          _editingName = false;
                          _editingPhone = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Profile updated!')),
                        );
                      },
                isSaving: _isSaving,
                email: appUser.email,
                favouriteGames: appUser.favouriteGames,
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: 2,
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacementNamed(context, '/bookings');
                  break;
                case 1:
                  Navigator.pushReplacementNamed(context, '/dashboard');
                  break;
                case 2:
                  break;
                case 3:
                  Navigator.pushReplacementNamed(context, '/loyalty');
                  break;
              }
            },
          ),
        );
      },
    );
  }
}
