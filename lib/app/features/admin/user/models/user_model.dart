// models/user.dart
import 'package:soft_bee/app/features/admin/user/models/apiario_model.dart';

class User {
  final int id;
  final String nombre;
  final String correo;
  final List<Apiario> apiarios;

  User({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.apiarios,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var apiariosList =
        (json['apiarios'] as List).map((a) => Apiario.fromJson(a)).toList();

    return User(
      id: json['id'],
      nombre: json['nombre'],
      correo: json['correo'],
      apiarios: apiariosList,
    );
  }
}
