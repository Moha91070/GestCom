import 'package:firebase_auth/firebase_auth.dart';
import 'package:authentification/models/admin.dart';

class Verif {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create custom user based on Firebase User
  Admin _adminFromFireBaseUser(User user) {
    return user != null ? Admin(uid: user.uid) : null;
  }

  Stream<Admin> get user {
    return _auth.authStateChanges().map(_adminFromFireBaseUser);
  }

  // Sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _adminFromFireBaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Sign in email password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _adminFromFireBaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register email password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _adminFromFireBaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
