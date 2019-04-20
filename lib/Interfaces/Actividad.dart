import 'package:vagos/Interfaces/Subgrupo.dart';
class Actividad {
  String Id;
  List<String> Participantes = new List<String>();
  double Presupuesto;
  String Nombre;
  String Fecha;
  String Hora;
  String Lugar;
  List<Subgrupo> Subgrupos = new List<Subgrupo>();
  double Meta;
}