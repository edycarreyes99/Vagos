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
      debugShowCheckedModeBanner: false,
      title: 'Agregar Actividad',
      theme: ThemeData(
          /*platform: TargetPlatform.iOS,*/
          primaryColor: Colors.orange,
          scaffoldBackgroundColor: Colors.white,
          cursorColor: Colors.orange,
          appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              actionsIconTheme: IconThemeData(color: Colors.white))),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
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
