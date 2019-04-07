import 'package:flutter/material.dart';
import 'servicios/servicio.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/newUser.dart';
import 'package:vagos/pages/signup.dart';

class RouterPage extends StatefulWidget {
  RouterPage({this.auth});
  final BaseAuth auth;

  @override
  _RouterPageState createState() => _RouterPageState();
}

enum AuthState { noIniciado, iniciado }

class _RouterPageState extends State<RouterPage> {
  AuthState _authState = AuthState.noIniciado;

  final _fs = Firestore.instance;

  FirebaseUser currentUser;

  List idUsuarios = [];

  bool usuarioNuevo = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fs.document('/Vagos/Control').get().then((DocumentSnapshot control) {
      this.idUsuarios = control['UsuariosRegistrados'];
      print('Imprimiendo usuarios.');
      print(this.idUsuarios.toString());
      /*Timer(Duration(seconds: 2), () {
        verificarSiEsUsuarioNuevo(this.idUsuarios, this.currentUser.uid);
      });*/
    }).catchError((e) => {print(e)});

    widget.auth.currentUser().then((userId) {
      setState(() {
        _authState = userId == null ? AuthState.noIniciado : AuthState.iniciado;
      });
    });
  }

  void extraerCurrentUser() async {
    try {
      FirebaseUser currentUser = await widget.auth.currentUser();
      this.currentUser = currentUser;
      if (this.currentUser == null) {
        print("No hay usuarios activos");
        extraerCurrentUser();
      } else {
        print("Bienvenido ${this.currentUser.displayName}");
        print("Tu direccion de foto de perfil es: ${this.currentUser.photoUrl}");
        int coincidencias = 0;
        this.idUsuarios.forEach((usuario) {
          if (this.currentUser.email == usuario.toString()) {
            coincidencias++;
          }
        });
        if (coincidencias > 0) {
          this.usuarioNuevo = false;
        } else {
          this.usuarioNuevo = true;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void verificarSiEsUsuarioNuevo(List usuarios, String uid) {
    int coincidencias = 0;
    usuarios.forEach((usuario) {
      if (usuario == uid) {
        coincidencias++;
      }
    });
    if (coincidencias > 0) {
      this.usuarioNuevo = false;
      print("no es usuario nuevo");
    } else {
      this.usuarioNuevo = true;
      print("es usuario nuevo");
    }
  }

  void iniciado() {
    setState(() {
      _authState = AuthState.iniciado;
      extraerCurrentUser();
    });
  }

  void noIniciado() {
    setState(() {
      _authState = AuthState.noIniciado;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authState) {
      case AuthState.noIniciado:
        new SignupPage(auth: widget.auth,onCerrarSesion: noIniciado,);
        return new LoginPage(
          auth: widget.auth,
          onIniciado: iniciado,
        );
      case AuthState.iniciado:
        switch (this.usuarioNuevo) {
          case true:
            return new NewUserPage(
              auth: widget.auth,
            );
            break;
          case false:
            return new HomePage(
              auth: widget.auth,
              onCerrarSesion: noIniciado,
            );
            break;
        }
    }
    return LoginPage(
      auth: widget.auth,
    );
  }
}
