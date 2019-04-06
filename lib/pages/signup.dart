import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vagos/servicios/servicio.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  SignupPage({this.auth, this.onIniciado});
  final BaseAuth auth;
  final VoidCallback onIniciado;

  static String tag = 'signup-page';

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  void toastError(String error) {
    Fluttertoast.showToast(
        msg: error,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        timeInSecForIos: 5);
  }

  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _nombre;
  String _apellido;
  int _telefono;
  File _profilePicture = null;

  bool validar() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    void registrarse() async {
      if (validar()) {
        try {
          FirebaseUser user = await widget.auth.registrarse(_email, _password);
          UserUpdateInfo userInfo = new UserUpdateInfo();
          userInfo.displayName = _nombre + " " + _apellido;
          userInfo.photoUrl = _profilePicture == null ? 'https://firebasestorage.googleapis.com/v0/b/grupo-ac.appspot.com/o/defaultMasculino.png?alt=media&token=32df9bdc-edf0-4ab4-a896-8d80959aa642' : null;
          user.updateProfile(userInfo);
          print("Se ha registrado como: ${user.email}");
          Fluttertoast.showToast(
            msg: 'Bienvenido ${user.email}',
            backgroundColor: Colors.orange,
            textColor: Colors.white
          );
        } catch (e) {
          print(e);
        }
      }
    }

    void iniciarSesionGoogle() async {
      try {
        String userEmail = await widget.auth.iniciarSesionGoogle();
        print('Ha Iniciado Sesión con Google como: ${userEmail}');
        Fluttertoast.showToast(
            msg: 'Bienvenido ${userEmail}',
            backgroundColor: Colors.orange,
            textColor: Colors.white);
        widget.onIniciado();
      } catch (e) {
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
            case 'There is no user record corresponding to this identifier. The user may have been deleted.':
              errorType = 'Error: El Usuario no Existe!';
              toastError(errorType);
              break;
            case 'The password is invalid or the user does not have a password.':
              errorType = 'Error: La contraseña no es correcta';
              toastError(errorType);
              break;
            case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
              errorType =
                  'Error: Error de Conexion, por favor verifique su conexión a internet';
              toastError(errorType);
              break;
            default:
              toastError(e.toString());
              print('${e.message}');
              toastError(e.message);
          }
        } else if (ios) {
          switch (e.code) {
            case 'Error 17011':
              errorType = 'Error: El Usuario no Existe!';
              toastError(errorType);
              break;
            case 'Error 17009':
              errorType = 'Error: La contraseña no es correcta';
              toastError(errorType);
              break;
            case 'Error 17020':
              errorType =
                  'Error: Error de Conexion, por favor verifique su conexión a internet';
              toastError(errorType);
              break;
            default:
              print('${e.message}');
              toastError(e.message);
          }
        }
        print('El Error Fue $errorType');
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
        body: ListView(
          children: <Widget>[
            Form(
              key: formKey,
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
                              contentPadding:
                                  EdgeInsets.fromLTRB(15.0, 20.0, 20.0, 15.0),
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
            Padding(
                padding: EdgeInsets.fromLTRB(8, 10, 8, 16),
                child: SizedBox(
                  height: 50.0,
                  child: RaisedButton(
                      onPressed: () => registrarse(),
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
                    onPressed: () => iniciarSesionGoogle(),
                    color: Colors.white,
                    child: Row(
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
