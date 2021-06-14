import 'package:firebase_auth/firebase_auth.dart';
import 'package:authentification/models/admin.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  // Créer un utilisateur personnalisé basé sur l'utilisateur Firebase
  Admin _adminBDD(User user) {
    return (user != null) ? Admin(uid: user.uid) : null;
  }

  Stream<Admin> get user {
    return _auth.authStateChanges().map(_adminBDD);
  }

  Future<dynamic> enregistrement(String email, String password) async {
    try {
      UserCredential resultat = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = resultat.user;

      return _adminBDD(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<dynamic> connexion(String email, String password) async {
    try {
      UserCredential connecter = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = connecter.user;

      return _adminBDD(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // deconnexion
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
