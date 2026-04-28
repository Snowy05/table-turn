import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:tableturn_project0/GlobalWidgets/BottomNav.dart';
import 'package:tableturn_project0/Model/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:tableturn_project0/View/Profile/ChangePasswordDialog.dart';
import 'package:tableturn_project0/View/Profile/ProfileCard.dart'
    show ProfileCard;

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  static final RegExp _hiddenCharactersPattern = RegExp(
    r'[\u0000-\u001F\u007F-\u009F\u200B-\u200F\u202A-\u202E\u2060-\u206F\uFEFF]',
  );
  static final RegExp _nameCharactersPattern = RegExp(r"[A-Za-zÀ-ÿ .'-]");

  bool _didSetControllers = false;
  bool _editingName = false;
  bool _editingPhone = false;
  final ImagePicker _picker = ImagePicker();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _profilePicUrl;
  String? _newProfilePicPath;
  bool _isSaving = false;
  Future<DocumentSnapshot<Map<String, dynamic>>>? _userFuture;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userFuture = _userDocument(user.uid);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const SizedBox.shrink();
    }
    _userFuture ??= _userDocument(user.uid);
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('Failed to load user data'));
        }
        final appUser = AppUser.fromMap(
          snapshot.data!.data() ?? <String, dynamic>{},
          snapshot.data!.id,
        );
        final sanitizedName = _sanitizeName(appUser.name);
        final sanitizedPhone = _sanitizePhone(appUser.phoneNumber);
        // Only set controllers once per user load
        if (!_didSetControllers) {
          _nameController.text = sanitizedName;
          _phoneController.text = sanitizedPhone;
          _profilePicUrl ??= appUser.profilePicUrl;
          _didSetControllers = true;
        }
        if (!_editingName && _nameController.text != sanitizedName) {
          _nameController.value = TextEditingValue(
            text: sanitizedName,
            selection: TextSelection.collapsed(offset: sanitizedName.length),
          );
        }
        if (!_editingPhone && _phoneController.text != sanitizedPhone) {
          _phoneController.value = TextEditingValue(
            text: sanitizedPhone,
            selection: TextSelection.collapsed(offset: sanitizedPhone.length),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFFFFF), Color(0xFFF9E6C1)],
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
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
                            displayName: sanitizedName,
                            displayPhone: sanitizedPhone,
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
                                _nameController.text = sanitizedName;
                                _editingName = false;
                              });
                            },
                            onCancelEditPhone: () {
                              setState(() {
                                _phoneController.text = sanitizedPhone;
                                _editingPhone = false;
                              });
                            },
                            onSave: _isSaving
                                ? null
                                : () async {
                                    final cleanedName = _sanitizeName(
                                      _nameController.text,
                                    );
                                    final cleanedPhone = _sanitizePhone(
                                      _phoneController.text,
                                    );

                                    setState(() {
                                      _isSaving = true;
                                      _nameController.text = cleanedName;
                                      _phoneController.text = cleanedPhone;
                                    });

                                    String? uploadedPicUrl = _profilePicUrl;
                                    if (_newProfilePicPath != null) {
                                      try {
                                        final storageRef = FirebaseStorage
                                            .instance
                                            .ref()
                                            .child(
                                              'profile_pics/${user.uid}.jpg',
                                            );
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
                                          'name': cleanedName,
                                          'phoneNumber': cleanedPhone,
                                          if (uploadedPicUrl != null)
                                            'profilePicUrl': uploadedPicUrl,
                                        });
                                    if (cleanedName !=
                                        (user.displayName ?? '')) {
                                      await user.updateDisplayName(cleanedName);
                                    }
                                    if (!mounted) {
                                      return;
                                    }
                                    setState(() {
                                      _isSaving = false;
                                      _profilePicUrl = uploadedPicUrl;
                                      _newProfilePicPath = null;
                                      _editingName = false;
                                      _editingPhone = false;
                                      _userFuture = _userDocument(user.uid);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Profile updated!'),
                                      ),
                                    );
                                  },
                            isSaving: _isSaving,
                            email: appUser.email,
                            favouriteGames: appUser.favouriteGames,
                            onChangePassword: () =>
                                _showChangePasswordDialog(context),
                          ),
                        ),
                      ),
                    ),
                  );
                },
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

  Future<DocumentSnapshot<Map<String, dynamic>>> _userDocument(String uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  String _sanitizeName(String value) {
    final withoutHiddenCharacters = value.replaceAll(
      _hiddenCharactersPattern,
      '',
    );
    final cleanedCharacters = withoutHiddenCharacters
        .split('')
        .where((character) => _nameCharactersPattern.hasMatch(character))
        .join();

    return cleanedCharacters.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String _sanitizePhone(String value) {
    final withoutHiddenCharacters = value.replaceAll(
      _hiddenCharactersPattern,
      '',
    );
    final digitsOnly = withoutHiddenCharacters.replaceAll(
      RegExp(r'[^0-9+]'),
      '',
    );

    if (digitsOnly.startsWith('+')) {
      return '+${digitsOnly.substring(1).replaceAll('+', '')}';
    }

    return digitsOnly;
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ChangePasswordDialog(),
    );
  }
}
