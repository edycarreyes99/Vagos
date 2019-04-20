import 'package:flutter/material.dart';
import 'servicios/servicio.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'router.dart';
import 'pages/welcome.dart';
import 'pages/signup.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    WelcomePage.tag: (context) => WelcomePage(),
    SignupPage.tag: (context) => SignupPage()
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
      //home: new WelcomePage(),
      //RootPage(auth: new Auth()),
      routes: routes,
    );
  }
}
