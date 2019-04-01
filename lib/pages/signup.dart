import 'package:flutter/material.dart';
import 'package:vagos/servicios/servicio.dart';

class SignupPage extends StatefulWidget {
  SignupPage({this.auth, this.onIniciado});
  final BaseAuth auth;
  final VoidCallback onIniciado;

  static String tag = 'signup-page';

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                        child: GestureDetector(
                      onTap: () =>
                          print('Se ha tocado el boton para cambiar la imagen'),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 50,
                        child: Center(
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.blue,
                            size: 35.0,
                          ),
                        ),
                      ),
                    )),
                  ),
                  Center(
                    child: Text(
                      'Agregar Imagen de Perfil',
                      style: TextStyle(color: Colors.orange),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
