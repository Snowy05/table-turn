import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:tableturn_project0/GlobalWidgets/BottomNav.dart';
import 'package:tableturn_project0/Model/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

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
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
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
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage: _newProfilePicPath != null
                              ? FileImage(File(_newProfilePicPath!))
                              : (_profilePicUrl != null &&
                                    _profilePicUrl!.isNotEmpty)
                              ? NetworkImage(_profilePicUrl!) as ImageProvider
                              : null,
                          child:
                              (_newProfilePicPath == null &&
                                  (_profilePicUrl == null ||
                                      _profilePicUrl!.isEmpty))
                              ? Icon(Icons.person, size: 48)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _editingName
                                ? TextField(
                                    controller: _nameController,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      labelText: 'Name',
                                    ),
                                    textAlign: TextAlign.left,
                                  )
                                : Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Name: ${_nameController.text}',
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 28,
                            width: 28,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 18,
                              icon: Icon(
                                _editingName ? Icons.check : Icons.edit,
                              ),
                              onPressed: () {
                                if (_editingName) {
                                  setState(() {
                                    _editingName = false;
                                  });
                                } else {
                                  setState(() {
                                    _editingName = true;
                                  });
                                }
                              },
                            ),
                          ),
                          if (_editingName)
                            SizedBox(
                              height: 28,
                              width: 28,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                iconSize: 18,
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _nameController.text = appUser.name;
                                    _editingName = false;
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _editingPhone
                                ? TextField(
                                    controller: _phoneController,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                    ),
                                    keyboardType: TextInputType.phone,
                                    textAlign: TextAlign.left,
                                  )
                                : Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Phone: ${_phoneController.text}',
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 28,
                            width: 28,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 18,
                              icon: Icon(
                                _editingPhone ? Icons.check : Icons.edit,
                              ),
                              onPressed: () {
                                if (_editingPhone) {
                                  setState(() {
                                    _editingPhone = false;
                                  });
                                } else {
                                  setState(() {
                                    _editingPhone = true;
                                  });
                                }
                              },
                            ),
                          ),
                          if (_editingPhone)
                            SizedBox(
                              height: 28,
                              width: 28,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                iconSize: 18,
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _phoneController.text = appUser.phoneNumber;
                                    _editingPhone = false;
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email: ${appUser.email}',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Favorite Games: ${appUser.favouriteGames.join(', ')}',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Loyalty Points: ${appUser.loyaltyPoints}',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isSaving
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
                                    await storageRef.putFile(
                                      File(_newProfilePicPath!),
                                    );
                                    uploadedPicUrl = await storageRef
                                        .getDownloadURL();
                                  } catch (e) {}
                                }
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .update({
                                      'name': _nameController.text.trim(),
                                      'phoneNumber': _phoneController.text
                                          .trim(),
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
                        child: _isSaving
                            ? CircularProgressIndicator()
                            : Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
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
