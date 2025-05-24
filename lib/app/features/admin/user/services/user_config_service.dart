import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:soft_bee/app/features/admin/user/models/user_model.dart';


class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000'; // O tu IP pública

  Future<User> getUserSettings(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar los datos');
    }
  }
}
