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

  final CollectionReference actividadesRef =
      Firestore.instance.collection('Vagos/Control/Actividades');

  String profilePhoto;
  String displayName;
  String correo;
  int cantActividades = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("el valor del drawer en en el es: ${this.widget.drawerPosition}");
    //this._extraerDatosUsuario();
    this._extraerCantActividades();
    print("hola mundo");
  }

  _extraerCantActividades() async {
    print(
        "ejecutando la orden para extraer la cantidad de actividades actual: ${this.cantActividades}");
    await _fs
        .collection('Vagos/Control/Actividades')
        .snapshots()
        .length
        .then((valor) {
      setState(() {
        this.cantActividades = valor - 1;
        print("la cantidad total de documentos es: " +
            this.cantActividades.toString());
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  /*_extraerDatosUsuario() async {
    print("extrayendo usuarios");
    await this.widget.auth.currentUser().then((FirebaseUser user) async {
      await _fs
          .document('Vagos/Control/Usuarios/${user.email.toString()}')
          .get()
          .then((DocumentSnapshot usuario) async {
        setState(() {
          this.profilePhoto = usuario['photoProfile'].toString();
          this.displayName = usuario['displayName'].toString();
          this.correo = usuario['Email'].toString();
          print(
              "se han extraido y se han guardado los valores en las variables en el set state para los datos");
        });
      }).catchError((e) {
        print(e.toString());
      });
    }).catchError((e) {
      print(e.toString());
    });
  }*/

  /*realizarSetState(int cantActividades) {
    setState(() {
      this.cantActividades = cantActividades;
      print(
          "se actualizaron las cantidades: " + this.cantActividades.toString());
    });
  }*/

  int extraercant() {
    return this.cantActividades;
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
          body: FloatingSearchBar.builder(
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return StreamBuilder(
                  stream: this.actividadesRef.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.orange,
                          ),
                        );
                        break;
                      default:
                        //this.realizarSetState(snapshot.data.documents.length);
                        return ListTile(
                          title: new Text(
                              snapshot.data.documents[index].data['Nombre']),
                          subtitle: new Text(
                              snapshot.data.documents[index].data['Fecha']),
                        );
                    }
                  });
            },
            /*children: <Widget>[
                StreamBuilder(
                    stream: this.actividadesRef.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.orange,
                            ),
                          );
                          break;
                        default:
                          return new Stack(
                            children: snapshot.data.documents
                                .map((DocumentSnapshot document) {
                              return Container(
                                child: new ListTile(
                                  title: new Text(document['Nombre']),
                                  subtitle: new Text(document['Fecha']),
                                ),
                              );
                            }).toList(),
                          );
                      }
                    })
              ],*/
            trailing: CircleAvatar(
              backgroundImage: this.profilePhoto == null
                  ? AssetImage('assets/profilePhotos/defaultMasculino.png')
                  : NetworkImage(this.profilePhoto),
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
          )),
    );
  }
}
