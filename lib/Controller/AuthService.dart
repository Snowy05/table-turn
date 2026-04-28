import 'package:firebase_auth/firebase_auth.dart';
import '../Model/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //signup method, (Future) promises return object or an error
  Future<UserCredential> signUp(
    String email,
    String password,
    String name,
    String phoneNumber,
    String age,
  ) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? firebaseUser = result.user;

    if (firebaseUser != null) {
      AppUser appUser = AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: name,
        phoneNumber: phoneNumber,
        age: age,
        favouriteGames: [],
        loyaltyPoints: 0,
        createdAt: DateTime.now(),
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(appUser.uid)
          .set(appUser.toMap());
      // Here you would typically save the appUser to Firestore or another database
    }
    return result;
  }

  //signin method, nothing to see here
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> resetPassword(String email) async {
    final normalizedEmail = email.trim();
    if (normalizedEmail.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'Please enter your email address.',
      );
    }

    await _auth.sendPasswordResetEmail(email: normalizedEmail);
  }

  //signout method, also nothing to see here
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Change password method
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No user is currently signed in.',
      );
    }
    // Re-authenticate user
    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(cred);
    // Update password
    await user.updatePassword(newPassword);
  }

  //current user getter
  User? get currentUser => _auth.currentUser;
  //change listener, listens to auth state changes and returns a stream of User objects, which can be used to update the UI accordingly
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
