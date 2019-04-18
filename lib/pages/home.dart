import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vagos/servicios/servicio.dart';
import 'dart:math';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'login.dart';
import 'navside.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onCerrarSesion, this.drawerPosition});
  final BaseAuth auth;
  final int drawerPosition;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    print("el valor del drawer en en el es: ${this.widget.drawerPosition}");
  }

  @override
  Widget build(BuildContext context) {
    Random random;
    int min = 1;
    int max = 9;
    random = new Random();
    int r = min + random.nextInt(max - min);

    return MaterialApp(
      theme: ThemeData(fontFamily: 'Arial'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: CircleAvatar(
            child: Image.asset('assets/AddGoogleLogo.png'),
            radius: 11.5,
            backgroundColor: Colors.white,
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: FloatingSearchBar(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 30.0),
                child: new Container(
                  child: Center(
                    child: Text('Hola Mundo'),
                  ),
                ),
              ),
              new Container(
                margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Center(
                  child: MaterialButton(
                    onPressed: () => {widget.cerrarSesion()},
                    color: Colors.orange,
                    elevation: 5.0,
                    child: new Text('Cerrar Sesion'),
                  ),
                ),
              ),
            ],
            trailing: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://lh4.googleusercontent.com/-2mUp9AT6uyQ/AAAAAAAAAAI/AAAAAAAAOR4/RKxeuCEf37I/photo.jpg'),
              backgroundColor: Colors.orange,
            ),
            drawer: new NavSide(
              drawerPosition: this.widget.drawerPosition,
              onCerrarSesion: this.widget.onCerrarSesion,
              auth: this.widget.auth,
            ),
            onChanged: (String value) {},
            onTap: () {
              /*Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage(auth: this.widget.auth,onIniciado: this.widget.onCerrarSesion)));*/
            },
            decoration: InputDecoration.collapsed(
                hintText: 'Buscar', hintStyle: TextStyle(color: Colors.black)),
          ),
        ),
      ),
    );
  }
}
