import 'package:flutter/material.dart';
import 'pruebadrawer.dart';
import 'home.dart';
import 'dart:math';
import 'package:vagos/servicios/servicio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysql1/mysql1.dart';

class DatosUsuario {
  String displayName;
  String Correo;
  String photoURL;
}

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class NavSide extends StatefulWidget {
  NavSide(
      {this.auth,
      this.onCerrarSesion,
      this.drawerPosition,
      this.displayName,
      this.correoUsuario,
      this.conector});

  final int drawerPosition;

  final BaseAuth auth;

  final VoidCallback onCerrarSesion;

  final String displayName;

  final String correoUsuario;

  final MySqlConnection conector;

  final drawerItems = [
    new DrawerItem("Actividades", Icons.explore),
    new DrawerItem("Prueba", Icons.local_pizza),
  ];

  @override
  _NavSideState createState() => _NavSideState();
}

class _NavSideState extends State<NavSide> {
  int _selectedDrawerIndex = 0;

  final Firestore _fs = Firestore.instance;
  DatosUsuario datosUsuario = new DatosUsuario();

  String profilePhoto;
  String displayName;
  String correo;

  /*Future<void> extraerDatosUsuarioSQL() async {
    await this.widget.auth.currentUser().then((FirebaseUser usuario) async {
      await this.widget.conector.query(
          'select displayName, Correo, photoURL from Usuarios where Correo = ?',
          [usuario.email.toString()]).then((Results resultados) {
        DatosUsuario retorno = new DatosUsuario();
        for (var row in resultados) {
          retorno.displayName = row[0];
          retorno.Correo = row[1];
          retorno.photoURL = row[2];
        }
        setState(() {
          this.datosUsuario = retorno;
        });
      }).catchError((e) {
        print(e.toString());
      });
    }).catchError((e) {
      print(e.toString());
    });
  }*/

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      drawerPosition: _selectedDrawerIndex,
                      onCerrarSesion: this.widget.onCerrarSesion,
                      auth: this.widget.auth,
                    )),
            (Route<dynamic> route) => false);
        print("la posicion de este drawer es: $_selectedDrawerIndex");
        break;
      case 1:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => PruebaDrawer(
                      drawerPosition: _selectedDrawerIndex,
                      auth: this.widget.auth,
                      onCerrarSesion: this.widget.onCerrarSesion,
                    )),
            (Route<dynamic> route) => false);
        print("la posicion de este drawer es: $_selectedDrawerIndex");
        break;
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDrawerIndex = this.widget.drawerPosition;
    print("Se ha navegado a la posicion: $_selectedDrawerIndex");
    //this.extraerDatosUsuarioSQL();
    var datosUsuarioAux = this.widget.auth.retornarDatosUsuarioSQL();
    this.datosUsuario.Correo = datosUsuarioAux.Correo;
    this.datosUsuario.displayName = datosUsuarioAux.displayName;
    this.datosUsuario.photoURL = datosUsuarioAux.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    Random random;
    int min = 1;
    int max = 9;
    random = new Random();
    int r = min + random.nextInt(max - min);
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      /*drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () {
          _onSelectItem(i);
          _getDrawerItemWidget(_selectedDrawerIndex);
        },
      ));*/
      drawerOptions.add(
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            decoration: i == _selectedDrawerIndex
                ? BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50)))
                : null,
            child: new ListTile(
              selected: i == _selectedDrawerIndex,
              onTap: () {
                _onSelectItem(i);
                _getDrawerItemWidget(_selectedDrawerIndex);
              },
              leading: Icon(
                d.icon,
                color: Colors.orange,
              ),
              title: Text(
                d.title,
                style: TextStyle(color: Colors.orange, fontSize: 15.0),
              ),
            ),
          ),
        ),
      );
    }

    return Drawer(
      child: new Column(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text(
              this.datosUsuario.displayName == null
                  ? 'Usuario'
                  : this.datosUsuario.displayName,
              //this.displayName == null ? 'Usuario' : this.displayName,
              style: TextStyle(color: Colors.white, fontFamily: 'GoogleSans'),
            ),
            accountEmail: new Text(
              this.datosUsuario.Correo == null
                  ? 'example@username.com'
                  : this.datosUsuario.Correo,
              //this.correo == null ? 'example@username.com' : this.correo,
              style: TextStyle(color: Colors.white, fontFamily: 'GoogleSans'),
            ),
            currentAccountPicture: new GestureDetector(
              /*onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage(
                        auth: this.widget.auth,
                        onCerrarSesion: this.widget.onCerrarSesion))),*/
              child: new CircleAvatar(
                backgroundImage: this.datosUsuario.photoURL == null
                    ? AssetImage('assets/profilePhotos/defaultMasculino.png')
                    : NetworkImage(this.datosUsuario.photoURL),
              ),
            ),
            decoration: new BoxDecoration(
                color: Colors.orange,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                        'assets/backgroundProfiles/background (4).jpg'))),
          ),
          new Column(
            children: drawerOptions,
          )
        ],
      ),
    );
  }
}
