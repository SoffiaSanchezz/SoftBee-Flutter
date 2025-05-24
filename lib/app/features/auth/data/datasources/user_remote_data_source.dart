// lib/data/datasources/user_remote_data_source.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class UserRemoteDataSource {
  final baseUrl = "http://10.0.2.2:8000/";

  Future<void> registrarUsuario(Map<String, dynamic> usuario) async {
    final response = await http.post(
      Uri.parse('${baseUrl}usuarios/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(usuario),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al registrar usuario");
    }
  }
}
