import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl =
      'http://127.0.0.1:8000'; // Cambia por tu IP si usas celular

  Future<List<String>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data.map((user) => user['name']));
    } else {
      throw Exception('Error al cargar usuarios');
    }
  }
}
