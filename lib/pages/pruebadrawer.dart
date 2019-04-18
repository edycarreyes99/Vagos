import 'package:flutter/material.dart';
import 'navside.dart';
import 'package:vagos/servicios/servicio.dart';

class PruebaDrawer extends StatefulWidget {
  PruebaDrawer({this.drawerPosition, this.auth, this.onCerrarSesion});

  final BaseAuth auth;

  final VoidCallback onCerrarSesion;

  final int drawerPosition;
  @override
  _PruebaDrawerState createState() => _PruebaDrawerState();
}

class _PruebaDrawerState extends State<PruebaDrawer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(
        "el valor del drawer en la prueba drawer es: ${this.widget.drawerPosition}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
      ),
      drawer: NavSide(
        drawerPosition: this.widget.drawerPosition,
        auth: this.widget.auth,
        onCerrarSesion: this.widget.onCerrarSesion,
      ),
      body: Center(
        child: Text('Hola Mundo'),
      ),
    );
  }
}
