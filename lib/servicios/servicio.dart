import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Future<String> iniciarSesion(String email, String password);
  Future<String> currentUser();
  Future<void> cerrarSesion();
  Future<String> iniciarSesionGoogle();
}

class Servicio implements BaseAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> iniciarSesion(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.email;
  }

  Future<String> iniciarSesionGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    final FirebaseUser user = await _firebaseAuth.signInWithCredential(credential);
    print('Se ha Iniciado sesion con Google como : ${user.displayName}');
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
