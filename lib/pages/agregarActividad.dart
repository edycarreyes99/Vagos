import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vagos/servicios/servicio.dart';

class AgregarActividad extends StatefulWidget {
  AgregarActividad({this.auth, this.onCerrarSesion});
  final BaseAuth auth;
  final VoidCallback onCerrarSesion;
  @override
  _AgregarActividadState createState() => _AgregarActividadState();
}

class _AgregarActividadState extends State<AgregarActividad> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agregar Actividad',
      theme: ThemeData(platform: TargetPlatform.iOS),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(
            'Agregar Actividad',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[Text('Hola mundo')],
        ),
      ),
    );
  }
}
