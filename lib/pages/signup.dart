import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vagos/servicios/servicio.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vagos/router.dart';
import 'dart:async';
import 'newUser.dart';
import 'package:flutter/services.dart';

class SignupPage extends StatefulWidget {
  SignupPage({this.auth, this.onIniciado});
  final BaseAuth auth;

  final VoidCallback onIniciado;

  static String tag = 'signup-page';

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKeyy = new GlobalKey<FormState>();

  final authh = FirebaseAuth.instance;

  final fs = Firestore.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void toastError(String error) {
    Fluttertoast.showToast(
        msg: error,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        timeInSecForIos: 5);
  }

  String _email;
  String _password;
  String _nombre;
  String _apellido;
  int _telefono;
  File _profilePicture = null;
  String usuariosRef = "/Vagos/Control/Usuarios/";
  bool _registrado = true;

  bool validar() {
    final form = formKeyy.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future<String> registrarNuevoUsuario(String emaill, String passwordd) async {
    FirebaseUser userr = await authh.createUserWithEmailAndPassword(
        email: emaill, password: passwordd);
    return userr.email;
  }

  void actualizarDatosUsuarioFirestore(String email, String password,
      int telefono, String displayName, String photoUrl) {
    fs
        .document(usuariosRef + email)
        .updateData({
          'photoProfile': photoUrl,
          'displayName': displayName,
          'Email': email,
          'Contrasena': password,
          'Telefono': telefono
        })
        .then((usuario) => {
              print(
                  "Los datos del usuario $email se han actualizado correctamente")
            })
        .catchError((e) => {print(e)});
  }

  void registrarse() async {
    //FirebaseUser user;
    if (validar()) {
      if (_profilePicture == null) {
        toastError(
            'Debe de Seleccionar una foto de perfil para poder continuar');
      } else {
        setState(() {
          _registrado = false;
        });
        try {
          FirebaseUser user = await widget.auth
              .registrarUsuario(_email, _password)
              .then((FirebaseUser user) {
            fs.document(usuariosRef + _email).setData(
                {'Email': _email, 'Contrasena': _password}).then((documento) {
              fs.document(usuariosRef + _email).updateData({
                'photoProfile': _profilePicture.path,
                'displayName': _nombre + " " + _apellido,
                'Email': _email,
                'Contrasena': _password,
                'Telefono': _telefono
              }).then((update) async {
                widget.onIniciado;
                List<String> idUsuarios = await this
                    .widget
                    .auth
                    .agregarNuevoUsuarioRegistradoAlControl(
                        user.email.toString())
                    .then((List<String> idUsuarios) {
                  print("se ha registrado como: ${user.email}");
                  Fluttertoast.showToast(
                      msg: 'Bienvenido ${user.email}',
                      backgroundColor: Colors.orange,
                      textColor: Colors.white);
                  setState(() {
                    _registrado = true;
                  });
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RouterPage(auth: this.widget.auth)),
                      (Route<dynamic> route) => false);
                }).catchError((e) {
                  print(e.toString());
                });
              }).catchError((e) {
                toastError(e.toString());
              });
            }).catchError((e) {
              print(e.toString());
            });
          }).catchError((e) {
            bool android = false;
            bool ios = false;
            bool fuchsiaa = false;
            if (Theme.of(context).platform == TargetPlatform.android) {
              android = true;
              ios = false;
              fuchsiaa = false;
              print('Plataforma corriendo en Android');
            } else if (Theme.of(context).platform == TargetPlatform.iOS) {
              ios = true;
              android = false;
              fuchsiaa = false;
              print('Plataforma corriendo en iOS');
            } else if (Theme.of(context).platform == TargetPlatform.fuchsia) {
              fuchsiaa = true;
              android = false;
              ios = false;
              print('Plataforma corriendo en Fuchsia');
            }
            String errorType = '';
            if (android) {
              switch (e.message) {
                case 'The email address is already in use by another account.':
                  errorType = 'Error: El Usuario ya esta en uso!';
                  toastError(errorType);
                  setState(() {
                    _registrado = true;
                  });
                  break;
                case 'The given password is invalid. [ Password should be at least 6 characters ]':
                  errorType =
                      'Error: La contraseña debe tener como minimo 6 caracteres';
                  toastError(errorType);
                  setState(() {
                    _registrado = true;
                  });
                  break;
                /*case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
              errorType =
              'Error: Error de Conexion, por favor verifique su conexión a internet';
              toastError(errorType);
              break;*/
                default:
                  toastError(e.toString());
                  print('${e.message}');
                  toastError(e.message);
                  setState(() {
                    _registrado = true;
                  });
                  break;
              }
            } else if (ios) {
              switch (e.code) {
                case 'Error 17011':
                  errorType = 'Error: El Usuario no Existe!';
                  toastError(errorType);
                  setState(() {
                    _registrado = true;
                  });
                  break;
                case 'Error 17009':
                  errorType = 'Error: La contraseña no es correcta';
                  toastError(errorType);
                  setState(() {
                    _registrado = true;
                  });
                  break;
                /*case 'Error 17020':
              errorType =
              'Error: Error de Conexion, por favor verifique su conexión a internet';
              toastError(errorType);
              break;*/
                default:
                  print('${e.toString()}');
                  toastError(e.toString());
                  setState(() {
                    _registrado = true;
                  });
                  break;
              }
            }
            print('El Error Fue $errorType');
            setState(() {
              _registrado = true;
            });
          });
        } catch (e) {
          toastError(e.toString());
          print(e.toString());
        }
      }
    }
  }

  void registrarseGoogle() async {
    try {
      setState(() {
        _registrado = false;
      });
      await this
          .widget
          .auth
          .comprobarExistenciaRegistroUsuarioGoogle()
          .then((GoogleSignInAccount userr) async {
        await this
            .widget
            .auth
            .extraerUsuariosControl()
            .then((List<dynamic> idUsuarios) async {
          int coinsidencias = 0;
          idUsuarios.forEach((usuario) {
            if (usuario.toString() == userr.email.toString()) {
              coinsidencias = coinsidencias + 1;
            }
          });
          GoogleSignInAccount usuario = userr;
          if (coinsidencias > 0) {
            toastError(
                "Este Usuario ya esta registrado. Por favor inicie sesion con el.");
            Navigator.pop(context);
          } else {
            await this
                .widget
                .auth
                .registrarUsuarioGoogle(usuario)
                .then((FirebaseUser usuarioo) async {
              fs.document(usuariosRef + usuarioo.email.toString()).setData(
                  {'Email': usuarioo.email.toString()}).then((documento) {
                setState(() {
                  _registrado = true;
                });
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewUserPage(
                              auth: this.widget.auth,
                            )),
                    (Route<dynamic> route) => false);
              }).catchError((e) {
                setState(() {
                  _registrado = true;
                });
                print(e.toString());
              });
            }).catchError((e) {
              print(e.toString());
              setState(() {
                _registrado = true;
              });
            });
          }
        }).catchError((e) {
          print(e.toString());
          setState(() {
            _registrado = true;
          });
        });
      }).catchError((e) {
        print(e.toString());
        setState(() {
          _registrado = true;
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

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
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Registrarse',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: _registrado == false
            ? Stack(
                children: <Widget>[
                  Opacity(
                    opacity: 0.5,
                    child: ModalBarrier(
                      dismissible: false,
                      color: Colors.grey,
                    ),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              )
            : ListView(
                children: <Widget>[
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
                                        ? Center(
                                            child: Icon(
                                            CupertinoIcons.add_circled,
                                            size: 50,
                                          ))
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
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.0),
                                ),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(8, 15, 8, 15),
                                child: Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 3, 0),
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          autofocus: false,
                                          validator: (value) => value.isEmpty
                                              ? 'El Nombre no puede estar Vacío'
                                              : null,
                                          onSaved: (value) => _nombre = value,
                                          decoration: InputDecoration(
                                              labelText: 'Nombre',
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      15.0, 20.0, 20.0, 15.0),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          const Radius.circular(
                                                              30.0)),
                                                  borderSide: BorderSide.none),
                                              filled: true,
                                              fillColor: Colors.grey[200],
                                              hasFloatingPlaceholder: true),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 3, 0),
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          autofocus: false,
                                          validator: (value) => value.isEmpty
                                              ? 'El Apellido no puede estar Vacío'
                                              : null,
                                          onSaved: (value) => _apellido = value,
                                          decoration: InputDecoration(
                                              labelText: 'Apellido',
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      15.0, 20.0, 20.0, 15.0),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          const Radius.circular(
                                                              30.0)),
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
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  autofocus: false,
                                  validator: (value) => value.isEmpty
                                      ? 'El email no puede estar en blanco.'
                                      : null,
                                  onSaved: (value) => _email = value,
                                  decoration: InputDecoration(
                                      labelText: 'Email',
                                      contentPadding: EdgeInsets.fromLTRB(
                                          15.0, 20.0, 20.0, 15.0),
                                      border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              const Radius.circular(30.0)),
                                          borderSide: BorderSide.none),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      hasFloatingPlaceholder: true)),
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
                                    labelText: 'Contraseña',
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
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  autofocus: false,
                                  validator: (value) => value.isEmpty
                                      ? 'El número telefónico no pued estar vacio'
                                      : null,
                                  onSaved: (value) =>
                                      _telefono = int.parse(value),
                                  decoration: InputDecoration(
                                      labelText: 'Teléfono',
                                      contentPadding: EdgeInsets.fromLTRB(
                                          15.0, 20.0, 20.0, 15.0),
                                      border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              const Radius.circular(30.0)),
                                          borderSide: BorderSide.none),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      hasFloatingPlaceholder: true)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(8, 10, 8, 16),
                      child: SizedBox(
                        height: 50.0,
                        child: RaisedButton(
                            onPressed: registrarse,
                            color: Colors.orange,
                            child: Text(
                              'Registrarse',
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50.0))),
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 5, 8, 30),
                    child: SizedBox(
                      height: 50.0,
                      child: RaisedButton(
                          onPressed: registrarseGoogle,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 15,
                                  child: Image.asset('assets/GoogleLogo.jpg'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '|',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text('Registrarse con Google'),
                              )
                            ],
                          ),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(50.0))),
                    ),
                  ),
                ],
              ));
  }
}
