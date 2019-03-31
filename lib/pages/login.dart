import 'package:flutter/material.dart';
import 'package:vagos/servicios/servicio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    final registrarBtn = Padding(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: FlatButton(
          child: Text('Registrarse',
              style: TextStyle(color: Colors.orange, fontSize: 18.0)),
          onPressed: () {},
        )
    );

    final logo = Container(
        padding: EdgeInsets.all(0.0),
        margin: EdgeInsets.all(0.0),
        child: CircleAvatar(
          radius: 25,
          child: Image.asset('assets/Logotipo.png'),
        ));

    final loginForm = Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    validator: (value) => value.isEmpty
                        ? 'El email no puede estar en blanco.'
                        : null,
                    onSaved: (value) => _email = value,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        )),
                        filled: true,
                        fillColor: Colors.grey[200],
                        hasFloatingPlaceholder: true)),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  validator: (value) => value.isEmpty
                      ? 'La contraseña no puede estar en blanco.'
                      : null,
                  onSaved: (value) => _password = value,
                  decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0))),
                      filled: true,
                      fillColor: Colors.grey[200]),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 48, 0, 16),
                  child: SizedBox(
                    height: 50.0,
                    child: RaisedButton(
                        onPressed: iniciarSesion,
                        color: Colors.orange,
                        child: Text(
                          'Iniciar Sesion',
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(50.0))),
                  )),
              SizedBox(
                height: 50.0,
                child: RaisedButton(
                    onPressed: () => {print('Registrar se ha Precionado')},
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.google,
                          color: Colors.orange,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('|',style: TextStyle(color: Colors.grey),),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text('Inicia Sesion con Google'),
                        )
                      ],
                    ),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0))),
              ),
              registrarBtn
            ],
          ),
        ));

    return Scaffold(
        body: ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(left: 24.0, right: 24.0),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Wrap(
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: <Widget>[logo],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
          child: Text(
            'Bienvenido',
            style: TextStyle(
                color: Colors.orange[700],
                fontSize: 50.0,
                fontFamily: 'GoogleSans',
                fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          'Inicia sesión para continuar',
          style: TextStyle(color: Colors.grey, fontSize: 15.0),
        ),
        Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 28.0),
              loginForm,
            ],
          ),
        )
      ],
    ));
  }
}
