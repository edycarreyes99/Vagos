import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth {
  Future<String> iniciarSesion(String email, String password);
  Future<FirebaseUser> currentUser();
  Future<void> cerrarSesion();
  Future<String> iniciarSesionGoogle();
  Future<FirebaseUser> registrarUsuario(String email, String password);
  Future<FirebaseUser> registrarUsuarioGoogle(GoogleSignInAccount googleUser);
  Future<GoogleSignInAccount> comprobarExistenciaRegistroUsuarioGoogle();
  Future<List<String>> agregarNuevoUsuarioRegistradoAlControl(String email);
  Future<List<dynamic>> extraerUsuariosControl();
  Future<String> verificarSiEsUsuarioNuevo();
}

class Servicio implements BaseAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _fs = Firestore.instance;

  Future<String> iniciarSesion(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.email;
  }

  Future<String> verificarSiEsUsuarioNuevo() async {
    FirebaseUser currentUser = await this.currentUser();
    List<dynamic> idUsuarios = await this.extraerUsuariosControl();
    String respuesta;
    try {
      if (currentUser == null) {
        print("No hay usuarios activos");
        await this.verificarSiEsUsuarioNuevo();
      } else {
        print("Bienvenido ${currentUser.displayName}");
        print("Tu direccion de foto de perfil es: ${currentUser.photoUrl}");
        int coincidencias = 0;
        idUsuarios.forEach((usuario) {
          if (currentUser.email.toString() == usuario.toString()) {
            coincidencias++;
          }
        });
        if (coincidencias > 0) {
          print("No es usuario nuevo");
          respuesta = "no";
        } else {
          print("Es usuario Nuevo");
          respuesta = "si";
        }
      }
    } catch (e) {
      print(e);
    }
    return respuesta;
  }

  Future<List<String>> agregarNuevoUsuarioRegistradoAlControl(
      String email) async {
    List<dynamic> idUsuarios = new List<dynamic>();
    List<String> idUsuariosAux = new List<String>();
    await _fs.document('Vagos/Control').get().then((DocumentSnapshot control) {
      idUsuarios = control['UsuariosRegistrados'];
      print(idUsuarios.toString());
      idUsuarios.forEach((usuario) {
        idUsuariosAux.add(usuario.toString());
      });
      idUsuariosAux.add(email.toString());

      _fs
          .document('Vagos/Control')
          .updateData({'UsuariosRegistrados': idUsuariosAux}).then((control) {
        print(
            "El usuario $email se ha agregado correctamente a la lista de ids de usuarios");
      }).catchError((e) {
        print(e.toString());
      });
    }).catchError((e) {
      print(e.toString());
    });
    return idUsuariosAux;
  }

  Future<List<dynamic>> extraerUsuariosControl() async {
    FirebaseUser user = await this.currentUser();
    List<dynamic> idUsuarios = new List<dynamic>();
    await _fs.document('Vagos/Control').get().then((DocumentSnapshot control) {
      idUsuarios = control['UsuariosRegistrados'];
      print(idUsuarios.toString());
    }).catchError((e) {
      print(e.toString());
    });
    return idUsuarios;
  }

  Future<FirebaseUser> registrarUsuario(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user;
  }

  Future<FirebaseUser> registrarUsuarioGoogle(
      GoogleSignInAccount googleUser) async {
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    final FirebaseUser user = await _firebaseAuth.signInWithCredential(credential);

    return user;
  }

  Future<GoogleSignInAccount> comprobarExistenciaRegistroUsuarioGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    return googleUser;
  }

  Future<String> iniciarSesionGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    final FirebaseUser user =
        await _firebaseAuth.signInWithCredential(credential);
    print('Se ha Iniciado sesion con Google como : ${user.displayName}');
    return user.email;
  }

  Future<FirebaseUser> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> cerrarSesion() async {
    return _firebaseAuth.signOut();
  }
}
