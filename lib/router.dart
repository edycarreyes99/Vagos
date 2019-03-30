import 'package:flutter/material.dart';
import 'servicios/servicio.dart';
import 'pages/home.dart';
import 'pages/login.dart';

class RouterPage extends StatefulWidget {
  RouterPage({this.auth});
  final BaseAuth auth;

  @override
  _RouterPageState createState() => _RouterPageState();
}

enum AuthState { noIniciado, iniciado }

class _RouterPageState extends State<RouterPage> {
  AuthState _authState = AuthState.noIniciado;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.auth.currentUser().then((userId) {
      setState(() {
        _authState = userId == null ? AuthState.noIniciado : AuthState.iniciado;
      });
    });
  }

  void iniciado() {
    setState(() {
      _authState = AuthState.iniciado;
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
        return new LoginPage(
          auth: widget.auth,
          onIniciado: iniciado,
        );
      case AuthState.iniciado:
        return new HomePage(
          auth: widget.auth,
          onCerrarSesion: noIniciado,
        );
    }
    return LoginPage(
      auth: widget.auth,
    );
  }
}
