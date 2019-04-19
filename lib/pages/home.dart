import 'package:flutter/material.dart';
import 'package:vagos/servicios/servicio.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navside.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final Firestore _fs = Firestore.instance;

  String profilePhoto;
  String displayName;
  String correo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("el valor del drawer en en el es: ${this.widget.drawerPosition}");
    this._extraerDatosUsuario();
  }

  _extraerDatosUsuario() async {
    await this.widget.auth.currentUser().then((FirebaseUser user) async {
      await _fs
          .document('Vagos/Control/Usuarios/${user.email.toString()}')
          .get()
          .then((DocumentSnapshot usuario) async {
        setState(() {
          this.profilePhoto = usuario['photoProfile'].toString();
          this.displayName = usuario['displayName'].toString();
          this.correo = usuario['Email'].toString();
        });
      }).catchError((e) {
        print(e.toString());
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
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
              backgroundImage: NetworkImage(this.profilePhoto),
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
