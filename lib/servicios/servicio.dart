import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth{
  Future<String> iniciarSesion(String email, String password);
  Future<String> currentUser();
  Future<void> cerrarSesion();
}

class Servicio implements BaseAuth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> iniciarSesion(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user.email;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<void> cerrarSesion() async {
    return _firebaseAuth.signOut();
  }
}