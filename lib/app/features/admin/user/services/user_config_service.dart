import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:soft_bee/app/features/admin/user/models/user_model.dart';


class ApiService {
  final String _baseUrl = 'http://127.0.0.1:8000/usuarios'; // Ajusta tu IP

  Future<User> getUserSettings(String userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/users/$userId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Error al obtener usuario: ${response.body}');
    }
  }
}
