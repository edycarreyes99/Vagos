import 'package:flutter/material.dart';
import 'package:vagos/servicios/servicio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onIniciado});
  final BaseAuth auth;

  final VoidCallback onIniciado;

  static String tag = 'login-page';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;

  bool validar() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void iniciarSesion() async {
    if (validar()) {
      try {
        String userEmail = await widget.auth.iniciarSesion(_email, _password);
        print('Ha Iniciado sesion como: $userEmail');
        Fluttertoast.showToast(
            msg: 'Bienvenido $userEmail',
            backgroundColor: Colors.orange,
            textColor: Colors.white);
        widget.onIniciado();
      } catch (e) {
        Fluttertoast.showToast(
            msg: e, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red);
        print('Error $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 100.0,
        child: Image.asset('assets/Logotipo.png'),
      ),
    );

    final loginForm = Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    validator: (value) => value.isEmpty
                        ? 'El email no puede estar en blanco.'
                        : null,
                    onSaved: (value) => _email = value,
                    decoration: InputDecoration(
                        hintText: 'Email',
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0))),
              ),
              Container(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                      autofocus: false,
                      obscureText: true,
                      validator: (value) => value.isEmpty
                          ? 'La contraseña no puede estar en blanco.'
                          : null,
                      onSaved: (value) => _password = value,
                      decoration: InputDecoration(
                          hintText: 'Contraseña',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0)))),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: MaterialButton(
                    minWidth: 200.0,
                    height: 42.0,
                    elevation: 5.0,
                    onPressed: iniciarSesion,
                    color: Colors.orange,
                    child: Text(
                      'Iniciar Sesion',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              FlatButton(
                child: Text('¿Has olvidado la contraseña?',
                    style: TextStyle(color: Colors.black)),
                onPressed: () {},
              )
            ],
          ),
        ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            loginForm,
            SizedBox(
              height: 48.0,
            )
          ],
        ),
      ),
    );
  }
}
