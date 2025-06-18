import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://tu-direccion-api:5000'; // Cambia esto

  // Método para iniciar monitoreo por voz
  static Future<Map<String, dynamic>> iniciarMonitoreoVoz() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/monitoreo/iniciar'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al iniciar monitoreo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para hablar texto
  static Future<void> hablarTexto(String texto) async {
    try {
      await http.post(
        Uri.parse('$_baseUrl/api/voz/hablar'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'texto': texto}),
      );
    } catch (e) {
      print('Error al hablar texto: $e');
    }
  }

  // Método para escuchar audio
  static Future<Map<String, dynamic>> escucharAudio(int duracion) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/voz/escuchar'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'duracion': duracion}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al escuchar audio: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para obtener preguntas
  static Future<List<dynamic>> obtenerPreguntas() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/preguntas'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al obtener preguntas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
