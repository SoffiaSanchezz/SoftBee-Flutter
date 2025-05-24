class Apiario {
  final int id;
  final String direccion;
  final int cantidadColmenas;
  final double latitud;
  final double longitud;

  Apiario({
    required this.id,
    required this.direccion,
    required this.cantidadColmenas,
    required this.latitud,
    required this.longitud,
  });

  factory Apiario.fromJson(Map<String, dynamic> json) {
    return Apiario(
      id: json['id'],
      direccion: json['direccion'],
      cantidadColmenas: json['cantidad_colmenas'],
      latitud: json['latitud'] ?? 0.0, // Podrías obtenerlo de la validación
      longitud: json['longitud'] ?? 0.0,
    );
  }
}

class Usuario {
  final int id;
  final String nombre;
  final String correo;
  final List<Apiario> apiarios;

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.apiarios,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    var apiariosList =
        (json['apiarios'] as List).map((a) => Apiario.fromJson(a)).toList();

    return Usuario(
      id: json['id'],
      nombre: json['nombre'],
      correo: json['correo'],
      apiarios: apiariosList,
    );
  }
}
