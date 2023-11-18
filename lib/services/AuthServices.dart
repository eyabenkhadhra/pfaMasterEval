import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  static String ipAdress = '172.20.10.6';
  static String port = '8000';
  var userCollection = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<bool> checkSignIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        return false;
      } else {
        // Gérer les autres erreurs Firebase
        return false;
      }
    }
  }

  Future<bool> signUp(
      String emailController, String passwordController, String name) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: emailController, password: passwordController);

      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> resetPassword(String emailController) async {
    try {
      await auth.sendPasswordResetEmail(email: emailController);
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  User? get user => auth.currentUser;

  logout() async {}
}
