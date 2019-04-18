import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vagos/servicios/servicio.dart';
import 'dart:math';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onCerrarSesion});
  final BaseAuth auth;
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
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
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
              backgroundColor: Colors.blue,
            ),
            drawer: new Drawer(
              child: new ListView(
                children: <Widget>[
                  new UserAccountsDrawerHeader(
                    accountName: new Text(
                      'Edycar Reyes',
                      style: TextStyle(color: Colors.white),
                    ),
                    accountEmail: new Text(
                      'edycarreyes@gmail.com',
                      style: TextStyle(color: Colors.white),
                    ),
                    currentAccountPicture: new GestureDetector(
                      /*onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage(
                        auth: this.widget.auth,
                        onCerrarSesion: this.widget.onCerrarSesion))),*/
                      child: new CircleAvatar(
                        backgroundImage: new NetworkImage(
                            'https://lh4.googleusercontent.com/-2mUp9AT6uyQ/AAAAAAAAAAI/AAAAAAAAOR4/RKxeuCEf37I/photo.jpg'),
                      ),
                    ),
                    decoration: new BoxDecoration(
                        color: Colors.orange,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                                'assets/backgroundProfiles/background ($r).jpg'))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50))),
                      child: new ListTile(
                        selected: true,
                        onTap: () {
                          //Navigator.of(context).pop();
                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        auth: this.widget.auth,
                                        onCerrarSesion:
                                            this.widget.onCerrarSesion,
                                      )));*/
                        },
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Icon(
                              Icons.home,
                              color: Colors.orange,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30.0, 2, 0, 0),
                              child: new Text(
                                'Inicio',
                                style: TextStyle(
                                    color: Colors.orange, fontSize: 15.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  new ListTile(
                    //onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>RealTimePage(auth: this.widget.auth,onCerrarSesion: this.widget.onCerrarSesion,))),
                    title: new Text('Tiempo Real'),
                    trailing: new Icon(Icons.whatshot),
                  ),
                  new ListTile(
                    /*onTap: () => Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => HistorialPage(
    auth: this.widget.auth,
    onCerrarSesion: this.widget.onCerrarSesion,
    ))),*/
                    title: new Text('Historial'),
                    trailing: new Icon(Icons.timeline),
                  ),
                  new ListTile(
                    onTap: () => {},
                    title: new Text('Streaming'),
                    trailing: new Icon(Icons.visibility),
                  ),
                  Divider(),
                  /*new ListTile(
    title: new DropdownButtonHideUnderline(
    child: new DropdownButton<String>(
    hint: new Text('Cuenta'),
    //value: _value,
    items: <DropdownMenuItem<String>>[
    new DropdownMenuItem(child: new Text('Perfil'), value: 'one'),
    new DropdownMenuItem(
    child: new Text('Agregar Usuario'), value: 'two')
    ],
    onChanged: (String value) {
    print(value);
    switch (value) {
    case 'one':
    return Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => ProfilePage(
    auth: this.widget.auth,
    onCerrarSesion: this.widget.onCerrarSesion,
    )));
    case 'two':
    return Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => AddUser(
    auth: this.widget.auth,
    onCerrarSesion: this.widget.onCerrarSesion,
    )));
    }
    },
    ),
    ),
    trailing: new Icon(Icons.account_circle),
    ),*/
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: MaterialButton(
                      minWidth: 200.0,
                      elevation: 8.0,
                      height: 42.0,
                      onPressed: this.widget.cerrarSesion,
                      color: Colors.orange,
                      child: Text(
                        'Cerrar Sesion',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
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

  /*
  Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: CircleAvatar(
          child: Image.asset('assets/AddGoogleLogo.png'),
          radius: 11.5,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
      ),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Actividades',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(
                'Edycar Reyes',
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: new Text(
                'edycarreyes@gmail.com',
                style: TextStyle(color: Colors.white),
              ),
              currentAccountPicture: new GestureDetector(
                /*onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(
                    auth: this.widget.auth,
                    onCerrarSesion: this.widget.onCerrarSesion))),*/
                child: new CircleAvatar(
                  backgroundImage: new NetworkImage(
                      'https://lh4.googleusercontent.com/-2mUp9AT6uyQ/AAAAAAAAAAI/AAAAAAAAOR4/RKxeuCEf37I/photo.jpg'),
                ),
              ),
              decoration: new BoxDecoration(
                color: Colors.orange,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/backgroundProfiles/background ($r).jpg'))),
            ),
            new ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            auth: this.widget.auth,
                            onCerrarSesion: this.widget.onCerrarSesion,
                          ))),
              title: new Text('Inicio'),
              trailing: new Icon(Icons.home),
            ),
            new ListTile(
              //onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>RealTimePage(auth: this.widget.auth,onCerrarSesion: this.widget.onCerrarSesion,))),
              title: new Text('Tiempo Real'),
              trailing: new Icon(Icons.whatshot),
            ),
            new ListTile(
              /*onTap: () => Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => HistorialPage(
    auth: this.widget.auth,
    onCerrarSesion: this.widget.onCerrarSesion,
    ))),*/
              title: new Text('Historial'),
              trailing: new Icon(Icons.timeline),
            ),
            new ListTile(
              onTap: () => {},
              title: new Text('Streaming'),
              trailing: new Icon(Icons.visibility),
            ),
            Divider(),
            /*new ListTile(
    title: new DropdownButtonHideUnderline(
    child: new DropdownButton<String>(
    hint: new Text('Cuenta'),
    //value: _value,
    items: <DropdownMenuItem<String>>[
    new DropdownMenuItem(child: new Text('Perfil'), value: 'one'),
    new DropdownMenuItem(
    child: new Text('Agregar Usuario'), value: 'two')
    ],
    onChanged: (String value) {
    print(value);
    switch (value) {
    case 'one':
    return Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => ProfilePage(
    auth: this.widget.auth,
    onCerrarSesion: this.widget.onCerrarSesion,
    )));
    case 'two':
    return Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => AddUser(
    auth: this.widget.auth,
    onCerrarSesion: this.widget.onCerrarSesion,
    )));
    }
    },
    ),
    ),
    trailing: new Icon(Icons.account_circle),
    ),*/
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: MaterialButton(
                minWidth: 200.0,
                elevation: 8.0,
                height: 42.0,
                onPressed: this.widget.cerrarSesion,
                color: Colors.orange,
                child: Text(
                  'Cerrar Sesion',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: new ListView(
        children: <Widget>[
          new Container(
            child: Center(
              child: Text('Hola Mundo'),
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
          )
        ],
      ),
    );
  */
}
