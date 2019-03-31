import 'package:flutter/material.dart';
import 'servicios/servicio.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'router.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage()
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vagos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Arciform'
      ),
      home: new RouterPage(auth: new Servicio()),
      //RootPage(auth: new Auth()),
      routes: routes,
    );
  }
}
