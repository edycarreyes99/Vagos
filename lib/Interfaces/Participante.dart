import 'package:vagos/Interfaces/Actividad.dart';
import 'package:vagos/Interfaces/Subgrupo.dart';
class Participante{
  String Id;
  String NombreApellido;
  String Email;
  String PhotoURL;
  int Telefono;
  List<Actividad> Participaciones = new List<Actividad>();
  List<Subgrupo> PertenenciasSubgrupos = new List<Subgrupo>();
  int CantidadParticipaciones;
  double PresupuestoGeneral;
  double MetaPorActividad;
}