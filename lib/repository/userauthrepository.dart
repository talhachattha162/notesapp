import 'package:firebase_auth/firebase_auth.dart';

class UserAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up with email and password
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;

  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;

  }

  // Sign out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error while signing out: $e');
    }
  }

  // Get the currently signed-in user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
