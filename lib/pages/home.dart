import 'package:flutter/material.dart';
import 'package:vagos/servicios/servicio.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onCerrarSesion});
  final BaseAuth auth;
  final VoidCallback onCerrarSesion;
  static String tag = 'home-page';

  void cerrarSesion() async {
    try {
      await auth.cerrarSesion();
      onCerrarSesion();
    } catch (e) {
      print(e);
    }
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inicio',
      home: new Scaffold(
        appBar: null,
        body: new ListView(
          children: <Widget>[
            new Container(
              child: Center(
                child: Text(
                    'Hola Mundo'
                ),
              ),
            ),
            new Container(
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Center(
                child: MaterialButton(
                  onPressed: ()=>{
                    widget.cerrarSesion()
                  },
                  color: Colors.orange,
                  elevation: 5.0,
                  child: new Text(
                    'Cerrar Sesion'
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}
