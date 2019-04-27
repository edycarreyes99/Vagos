import 'package:flutter/material.dart';
import 'package:vagos/servicios/servicio.dart';
import 'package:vagos/pages/login.dart';
import 'package:vagos/router.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({this.auth, this.onIniciado});
  final BaseAuth auth;
  final VoidCallback onIniciado;
  static String tag = 'welcome-page';
  final RouterPage router = new RouterPage();

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0,bottom: 30.0),
              child: CircleAvatar(
                child: Image.asset('assets/Logotipo.png'),
                radius: 40.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Vagos',
                style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'SanFrancisco'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 30, 5, 20),
              child: Text(
                'Crea listas de salidas entre amigos de una manera facil y rapida con \"Vagos\".',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                    fontFamily: 'SanFrancisco'),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
              child: RaisedButton(
                onPressed: () {
                  print("realizando navegacion");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(
                              auth: this.widget.auth,
                              onIniciado: this.widget.onIniciado)));
                },
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Text(
                    'EMPEZAR',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SanFrancisco'),
                  ),
                ),
                color: Colors.orange,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Powered by FireLabs',
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16.0,
                      fontFamily: 'SanFrancisco'),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0,bottom: 20.0),
                  child: Text(
                    'Edycar Reyes',
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14.0,
                        fontFamily: 'SanFrancisco',
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
