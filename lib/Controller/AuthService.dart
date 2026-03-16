import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //signup method, (Future) promises return object or an error
  Future<UserCredential> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //signin method, nothing to see here
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //signout method, also nothing to see here
  Future<void> signOut() async {
    await _auth.signOut();
  }
//current user getter
  User? get currentUser => _auth.currentUser;
//change listener, listens to auth state changes and returns a stream of User objects, which can be used to update the UI accordingly
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
