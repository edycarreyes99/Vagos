import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vagos/servicios/servicio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InformacionPage extends StatefulWidget {
  InformacionPage(
      {this.auth, this.onCerrarSesion, this.documento, this.idDocumento,this.colorAppBar});

  final BaseAuth auth;
  final VoidCallback onCerrarSesion;
  final DocumentSnapshot documento;
  final String idDocumento;
  final Color colorAppBar;

  @override
  _InformacionPageState createState() => _InformacionPageState();
}

class _InformacionPageState extends State<InformacionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(this.widget.documento.data['Fecha']),
          backgroundColor: this.widget.colorAppBar,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.delete,color: Colors.white,),onPressed: (){},),
            IconButton(icon: Icon(CupertinoIcons.pencil),color: Colors.white,onPressed: (){}),
            //IconButton(icon: Icon(Icons.more_vert,color: Colors.white,), onPressed: (){}),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Center(
              child: Text(this.widget.documento.data['Nombre']),
            )
          ],
        ));
  }
}
