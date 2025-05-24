// models/apiario.dart
class Apiario {
  final int id;
  final String direccion;
  final int cantidadColmenas;

  Apiario({
    required this.id,
    required this.direccion,
    required this.cantidadColmenas,
  });

  factory Apiario.fromJson(Map<String, dynamic> json) {
    return Apiario(
      id: json['id'],
      direccion: json['direccion'],
      cantidadColmenas: json['cantidad_colmenas'],
    );
  }
}
