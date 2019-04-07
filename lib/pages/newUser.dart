import 'package:flutter/material.dart';
import 'package:vagos/servicios/servicio.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewUserPage extends StatefulWidget {
  NewUserPage({this.auth});
  final BaseAuth auth;

  @override
  _NewUserPageState createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  final formKeyy = new GlobalKey<FormState>();

  File _profilePicture;

  String _nombre;
  String _password;
  String _apellido;
  int _telefono;

  Future fotoCamara() async {
    var imagen = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _profilePicture = imagen;
    });
  }

  Future fotoGaleria() async {
    var imagen = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _profilePicture = imagen;
    });
  }

  void mostrarModal() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.add_a_photo,
                  color: Colors.orange,
                ),
                title: Text('Tomar Foto'),
                onTap: () {
                  Navigator.pop(context);
                  fotoCamara()
                      .then((imagen) => print(_profilePicture.path))
                      .catchError((e) => print(e));
                },
              ),
              Divider(
                color: Colors.grey,
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: Colors.orange,
                ),
                title: Text("Escoger de la Galería"),
                onTap: () {
                  Navigator.pop(context);
                  fotoGaleria()
                      .then((imagen) => print(_profilePicture.path))
                      .catchError((e) => print(e));
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Center(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Text(
                  'Nuevo Usuario',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ),
              ))
            ],
          ),
          Container(
            child: Form(
              key: formKeyy,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Center(
                          child: Material(
                        borderRadius: BorderRadius.circular(50),
                        elevation: 8.0,
                        child: GestureDetector(
                          onTap: mostrarModal,
                          child: CircleAvatar(
                            backgroundColor: _profilePicture == null
                                ? Colors.grey[200]
                                : null,
                            radius: 50,
                            backgroundImage: _profilePicture == null
                                ? null
                                : FileImage(_profilePicture),
                            child: _profilePicture == null
                                ? Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                  )
                                : null,
                          ),
                        ),
                      )),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          _profilePicture == null
                              ? 'Agregar Imagen de Perfil'
                              : "Cambiar Imagen de Perfil",
                          style: TextStyle(color: Colors.black, fontSize: 15.0),
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(8, 15, 8, 15),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  autofocus: false,
                                  validator: (value) => value.isEmpty
                                      ? 'El Nombre no puede estar Vacío'
                                      : null,
                                  onSaved: (value) => _nombre = value,
                                  decoration: InputDecoration(
                                      labelText: 'Nombre',
                                      contentPadding: EdgeInsets.fromLTRB(
                                          15.0, 20.0, 20.0, 15.0),
                                      border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              const Radius.circular(30.0)),
                                          borderSide: BorderSide.none),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      hasFloatingPlaceholder: true),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  autofocus: false,
                                  validator: (value) => value.isEmpty
                                      ? 'El Apellido no puede estar Vacío'
                                      : null,
                                  onSaved: (value) => _apellido = value,
                                  decoration: InputDecoration(
                                      labelText: 'Apellido',
                                      contentPadding: EdgeInsets.fromLTRB(
                                          15.0, 20.0, 20.0, 15.0),
                                      border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              const Radius.circular(30.0)),
                                          borderSide: BorderSide.none),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      hasFloatingPlaceholder: true),
                                ),
                              ),
                            ),
                          ],
                        )),
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
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(8, 10, 8, 25),
              child: SizedBox(
                height: 50.0,
                child: RaisedButton(
                    onPressed: () => {},
                    color: Colors.orange,
                    child: Text(
                      'Continuar',
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0))),
              ))
        ],
      ),
    );
  }
}
