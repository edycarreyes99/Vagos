import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vagos/servicios/servicio.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navside.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'informacion.dart';
import 'agregarActividad.dart';

class HomeApp extends StatefulWidget {
  HomeApp(
      {this.auth,
      this.onCerrarSesion,
      this.drawerPosition,
      this.cantidadParticipacionesUsuario,
      this.correoUsuario,
      this.displayName});
  final BaseAuth auth;
  final int drawerPosition;
  final VoidCallback onCerrarSesion;
  static String tag = 'home-page';
  final int cantidadParticipacionesUsuario;
  final String correoUsuario;
  final String displayName;

  void cerrarSesion() async {
    try {
      await auth.cerrarSesion();
      onCerrarSesion();
    } catch (e) {
      print(e);
    }
  }

  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  final Firestore _fs = Firestore.instance;

  final CollectionReference actividadesRef =
      Firestore.instance.collection('Vagos/Control/Actividades');

  String profilePhoto;
  String displayName;
  String correo;
  int cantActividades = null;
  List<DocumentSnapshot> actividades = new List<DocumentSnapshot>();
  List<DocumentSnapshot> actividadesAux = new List<DocumentSnapshot>();
  List<bool> isSelected = new List<bool>();
  bool modoEdicion = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._extraerDatosUsuario();
    this.cantActividades = this.widget.cantidadParticipacionesUsuario;
    this.correo = this.widget.correoUsuario;
    this.displayName = this.widget.displayName;
    print('el corrreo almacenado es: ' + this.widget.correoUsuario.toString());
    this._extraerActividades();
    //this._extraerCantActividades();
  }

  _extraerCantActividades() async {
    await _fs
        .document("Vagos/Control/Usuarios/${this.correo}")
        .snapshots()
        .listen((DocumentSnapshot usuario) {
      setState(() {
        this.cantActividades = usuario["CantidadParticipaciones"];
      });
    });
  }

  Color _colorAleatorio() {
    List<Color> colores = new List<Color>();
    var aleatorio = new Random();
    colores.add(Colors.teal[300]);
    colores.add(Colors.blue[400]);
    colores.add(Colors.deepPurple[200]);
    colores.add(Colors.orange[300]);
    return colores[aleatorio.nextInt(colores.length)];
  }

  _extraerActividades() async {
    await this
        ._fs
        .collection('Vagos/Control/Actividades')
        .where('Participantes', arrayContains: this.correo.toString())
        .snapshots()
        .listen((QuerySnapshot documentos) {
      setState(() {
        this.actividades = documentos.documents;
        this.actividadesAux = documentos.documents;
        print("la cantidad de actividades almacenadas son: " +
            this.actividades.length.toString());
      });
    });
  }

  _extraerDatosUsuario() async {
    print("extrayendo usuarios");
    await this.widget.auth.currentUser().then((FirebaseUser user) async {
      await _fs
          .document('Vagos/Control/Usuarios/${user.email.toString()}')
          .snapshots()
          .listen((DocumentSnapshot usuario) {
        setState(() {
          this.profilePhoto = usuario['photoProfile'].toString();
          this.displayName = usuario['displayName'].toString();
          this.correo = usuario['Email'].toString();
          this.cantActividades = usuario['CantidadParticipaciones'];
          this._extraerActividades();
        });
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  _buscarPorFiltrodeDato(String valorBusqueda) {
    print("el valor de busqueda es: " + valorBusqueda);
    if (valorBusqueda == null) {
      print("vacio!");
      this.actividades = this.actividadesAux;
      this.cantActividades = this.actividades.length;
    } else {
      print('La cantidad de documentos que hay es: ' +
          this.actividades.length.toString());
      this.actividades.forEach((DocumentSnapshot documento) {
        if (valorBusqueda.toLowerCase() ==
            documento.data['Nombre'].toString().toLowerCase()) {
          print('Doucmento encontrado! ' + documento.data['Nombre'].toString());
        } else if (documento.data['Nombre']
            .toString()
            .toLowerCase()
            .contains(valorBusqueda.toLowerCase())) {
          print('Hay semejanzas');
          setState(() {
            this.actividades = this
                .actividadesAux
                .where((DocumentSnapshot documento) => documento.data['Nombre']
                    .toString()
                    .toLowerCase()
                    .contains(valorBusqueda.toLowerCase()))
                .toList();
            this.cantActividades = this.actividades.length;
            print(this.actividades.toString());
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (this.modoEdicion) {
              print("se van a eliminar las actividades seleccionadas");
            } else {
              print("Se va a agregar una nueva actividad");
              navegarAgregarActividad(context);
              /*showDialog(
                    context: context,
                    //barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Agregar una Nueva Actividad',
                          style: TextStyle(fontFamily: 'GoogleSans'),
                        ),
                        content: Text(
                          'Se va agregar una nueva actividad',
                          style: TextStyle(fontFamily: 'GoogleSans'),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              'Cancelar',
                              style: TextStyle(fontFamily: 'GoogleSans'),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text(
                              'Aceptar',
                              style: TextStyle(fontFamily: 'GoogleSans'),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });*/
            }
          },
          child: this.modoEdicion
              ? Icon(
                  Icons.delete,
                  color: Colors.white,
                )
              : CircleAvatar(
                  child: Image.asset('assets/AddGoogleLogo.png'),
                  radius: 11.5,
                  backgroundColor: Colors.white,
                ),
          backgroundColor: this.modoEdicion ? Colors.red : Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: FloatingSearchBar.builder(
            itemCount: this.cantActividades == 0 ? 1 : this.cantActividades,
            itemBuilder: (BuildContext context, int index) {
              return this.cantActividades == 0
                  ? Container(
                      transform: Matrix4.translationValues(
                          0.0, -(MediaQuery.of(context).size.height / 9), 0.0),
                      child: new ConstrainedBox(
                        constraints: new BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height,
                          minWidth: MediaQuery.of(context).size.width,
                          maxHeight: MediaQuery.of(context).size.height,
                          maxWidth: MediaQuery.of(context).size.width,
                        ),
                        child: new DecoratedBox(
                          decoration: new BoxDecoration(color: Colors.white),
                          position: DecorationPosition.background,
                          child: Center(
                              child: Text(
                            'Aún no perteneces a ningúna actividad.',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 20.0),
                            textAlign: TextAlign.center,
                          )),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        index == 0
                            ? Padding(
                                padding: EdgeInsets.only(top: 15.0, left: 14.0),
                                child: Text(
                                  'TUS ACTIVIDADES',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 11.0,
                                      letterSpacing: 2.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            : null,
                        StreamBuilder(
                            stream: this
                                .actividadesRef
                                .where('Participantes',
                                    arrayContains: this.correo)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Text('');
                                  break;
                                default:
                                  isSelected.add(false);
                                  Color colorActividad = this._colorAleatorio();
                                  void mostrarSeleccion() {
                                    setState(() {
                                      int coincidencias = 0;
                                      isSelected[index] = !isSelected[index];
                                      this.isSelected.forEach((valor) {
                                        if (!valor) {
                                          coincidencias++;
                                        }
                                      });
                                      if (coincidencias ==
                                          this.isSelected.length) {
                                        this.modoEdicion = false;
                                      }
                                    });
                                  }
                                  //this.realizarSetState(snapshot.data.documents.length);
                                  return ListTile(
                                    selected: isSelected[index],
                                    onTap: () {
                                      if (this.modoEdicion) {
                                        mostrarSeleccion();
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    InformacionPage(
                                                      auth: this.widget.auth,
                                                      onCerrarSesion: this
                                                          .widget
                                                          .onCerrarSesion,
                                                      documento: this
                                                          .actividades[index],
                                                      idDocumento: this
                                                          .actividades[index]
                                                          .data['Id']
                                                          .toString(),
                                                      colorAppBar:
                                                          colorActividad,
                                                    )));
                                      }
                                    },
                                    onLongPress: () {
                                      this.modoEdicion = true;
                                      print("Seleccionado para eliminar");
                                      mostrarSeleccion();
                                    },
                                    dense: false,
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          this.actividades[index].data['Fecha'],
                                          style: TextStyle(
                                              fontFamily: 'GoogleSans',
                                              fontSize: 11.0),
                                        ),
                                        Text(
                                          'NIO 400',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: colorActividad,
                                      child: Center(
                                        child: this.modoEdicion &&
                                                this.isSelected[index]
                                            ? Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              )
                                            : Text(
                                                this
                                                    .actividades[index]
                                                    .data['Nombre']
                                                    .toString()
                                                    .substring(0, 1)
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24.0,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'GoogleSans'),
                                              ),
                                      ),
                                    ),
                                    subtitle: Text(
                                      this.actividades[index].data['Lugar'],
                                      style:
                                          TextStyle(fontFamily: 'GoogleSans'),
                                    ),
                                    title: Text(
                                      this.actividades[index].data['Nombre'],
                                      style:
                                          TextStyle(fontFamily: 'GoogleSans'),
                                    ),
                                  );
                              }
                            })
                      ].where((w) => w != null).toList(),
                    );
            },
            trailing: GestureDetector(
              onTap: () async {
                await this.widget.cerrarSesion();
              },
              child: CircleAvatar(
                backgroundImage: this.profilePhoto == null
                    ? AssetImage('assets/profilePhotos/defaultMasculino.png')
                    : NetworkImage(this.profilePhoto),
                backgroundColor: Colors.orange,
              ),
            ),
            drawer: new NavSide(
              drawerPosition: this.widget.drawerPosition,
              onCerrarSesion: this.widget.onCerrarSesion,
              auth: this.widget.auth,
              displayName: this.widget.displayName,
              correoUsuario: this.widget.correoUsuario,
            ),
            onChanged: (String value) {
              this._buscarPorFiltrodeDato(value.toString());
            },
            onTap: () {
              /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(auth: this.widget.auth,onIniciado: this.widget.onCerrarSesion)));*/
            },
            decoration: InputDecoration.collapsed(
                hintText: 'Buscar', hintStyle: TextStyle(color: Colors.black)),
          ),
        ));
  }
}

class HomePage extends StatefulWidget {
  HomePage(
      {this.auth,
      this.onCerrarSesion,
      this.drawerPosition,
      this.cantidadParticipacionesUsuario,
      this.correoUsuario,
      this.displayName});
  final BaseAuth auth;
  final int drawerPosition;
  final VoidCallback onCerrarSesion;
  static String tag = 'home-page';
  final int cantidadParticipacionesUsuario;
  final String correoUsuario;
  final String displayName;

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
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomeApp(
                auth: this.widget.auth,
                displayName: this.widget.displayName,
                correoUsuario: this.widget.correoUsuario,
                onCerrarSesion: this.widget.onCerrarSesion,
                cantidadParticipacionesUsuario:
                    this.widget.cantidadParticipacionesUsuario,
              ),
          '/agregarActividad': (BuildContext context) => AgregarActividad(
                auth: this.widget.auth,
                onCerrarSesion: this.widget.onCerrarSesion,
              )
        },
        theme:
            ThemeData(fontFamily: 'SanFrancisco'),
        debugShowCheckedModeBanner: false,
        home: HomeApp(
          auth: this.widget.auth,
          displayName: this.widget.displayName,
          correoUsuario: this.widget.correoUsuario,
          onCerrarSesion: this.widget.onCerrarSesion,
          cantidadParticipacionesUsuario:
              this.widget.cantidadParticipacionesUsuario,
        ));
  }
}

void navegarAgregarActividad(BuildContext context){
  print('Navegando para agregar una actividad');
  Navigator.of(context).pushNamed('/agregarActividad');
}
