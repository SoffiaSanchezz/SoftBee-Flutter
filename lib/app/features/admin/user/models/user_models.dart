// lib/models/user_models.dart
class UserProfile {
  final int id;
  final String name;
  final String email;
  final String phone;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['nombre'],
      email: json['correo'],
      phone: json['telefono'],
      createdAt: DateTime.parse(json['fecha_creacion']),
      updatedAt:
          json['fecha_actualizacion'] != null
              ? DateTime.parse(json['fecha_actualizacion'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'nombre': name, 'correo': email, 'telefono': phone};
  }
}

class Apiary {
  final int id;
  final String name;
  final String address;
  final int hiveCount;
  final String? latitude;
  final String? longitude;
  final bool appliesTreatments;
  final DateTime createdAt;

  Apiary({
    required this.id,
    required this.name,
    required this.address,
    required this.hiveCount,
    this.latitude,
    this.longitude,
    required this.appliesTreatments,
    required this.createdAt,
  });

  factory Apiary.fromJson(Map<String, dynamic> json) {
    return Apiary(
      id: json['id'],
      name: json['nombre'],
      address: json['direccion'],
      hiveCount: json['cantidad_colmenas'],
      latitude: json['latitud'],
      longitude: json['longitud'],
      appliesTreatments: json['aplica_tratamientos'],
      createdAt: DateTime.parse(json['fecha_creacion']),
    );
  }
}
