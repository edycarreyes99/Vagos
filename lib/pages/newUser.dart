import 'package:flutter/material.dart';
import 'package:vagos/servicios/servicio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vagos/router.dart';

class NewUserPage extends StatefulWidget {
  NewUserPage({this.auth});
  final BaseAuth auth;

  @override
  _NewUserPageState createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {

  final Firestore _fs = Firestore.instance;

  List<dynamic> idUsuarios = new List<dynamic>();
  List<String> idUsuariosAux = new List<String>();

  FirebaseUser currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Prueba de Init State");
  }

  void extraerCurrentUser() async {
    try {
      FirebaseUser currentUser = await widget.auth.currentUser();
      this.currentUser = currentUser;
      if (this.currentUser == null) {
        print("No hay usuarios activos");
        extraerCurrentUser();
      } else {
        print("El usuario activo actual es ${this.currentUser.email}");
      }
    } catch (e) {
      print(e);
    }
  }

  final formKeyy = new GlobalKey<FormState>();

  File _profilePicture;

  String _nombre;
  String _password;
  String _apellido;
  int _telefono;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Text(
              'Nuevo Usuario',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
              ),
            ),
          ),
          Form(
            key: formKeyy,
            child: Column(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 2),
                    child: Text(
                      "Debes crear una contraseña nueva",
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autofocus: false,
                    obscureText: true,
                    validator: (value) => value.isEmpty
                        ? 'La Contraseña no puede estar vacía'
                        : null,
                    onSaved: (value) => _password = value,
                    decoration: InputDecoration(
                        labelText: 'Nueva Contraseña',
                        contentPadding:
                            EdgeInsets.fromLTRB(15.0, 20.0, 20.0, 15.0),
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0)),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.grey[200],
                        hasFloatingPlaceholder: true),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autofocus: false,
                    obscureText: true,
                    validator: (value) => value.isEmpty
                        ? 'Este Campo no puede estar vacio'
                        : null,
                    onSaved: (value) => _password = value,
                    decoration: InputDecoration(
                        labelText: 'Repetir Contraseña',
                        contentPadding:
                            EdgeInsets.fromLTRB(15.0, 20.0, 20.0, 15.0),
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0)),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.grey[200],
                        hasFloatingPlaceholder: true),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                      autofocus: false,
                      validator: (value) => value.isEmpty
                          ? 'El número telefónico no pued estar vacio'
                          : null,
                      onSaved: (value) => _telefono = int.parse(value),
                      decoration: InputDecoration(
                          labelText: 'Teléfono',
                          contentPadding:
                              EdgeInsets.fromLTRB(15.0, 20.0, 20.0, 15.0),
                          border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0)),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Colors.grey[200],
                          hasFloatingPlaceholder: true)),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8, 10, 8, 25),
            child: RaisedButton(
                onPressed: () {
                  if(this.currentUser==null){
                    this.extraerCurrentUser();
                  }else{
                    _fs.document('/Vagos/Control').get().then((DocumentSnapshot control) {


                      this.idUsuarios = control['UsuariosRegistrados'];
                      this.extraerCurrentUser();
                      print("Imprimiendo la lista actual de usuarios: ");
                      print(this.idUsuarios.toString());
                      this.idUsuarios.forEach((usuario){
                        this.idUsuariosAux.add(usuario.toString());
                      });

                      this.idUsuariosAux.add(this.currentUser.email.toString());


                      _fs.document('/Vagos/Control').updateData({
                        'UsuariosRegistrados': this.idUsuariosAux
                      }).then((control){
                        print("El usuario ${this.currentUser.email} se ha agregado correctamente a la lista de ids de usuarios");
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => RouterPage(auth: new Servicio())),
                                (Route<dynamic> route) =>
                            false);
                      }).catchError((e)=>{
                      print(e.toString())
                      });


                    }).catchError((e) => {print(e)});
                  }
                },
                color: Colors.orange,
                child: Text(
                  'Continuar',
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
      )),
    );
  }
}
