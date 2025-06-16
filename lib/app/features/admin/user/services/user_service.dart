import 'dart:convert';
import 'package:http/http.dart' as http;

class UserProfileService {
  final String _baseUrl = 'http://192.168.1.10:8000/usuarios';

  Map<String, String> _getHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/usuarios/me'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Sesión expirada',
          'shouldLogout': true,
        };
      } else {
        return {'success': false, 'message': 'Error al obtener perfil'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  Future<Map<String, dynamic>> getUserApiaries(String token) async {
    try {
      print('Obteniendo apiarios con token: ${token.substring(0, 15)}...');

      final response = await http.get(
        Uri.parse('$_baseUrl/me/apiaries'),
        headers: _getHeaders(token),
      );

      print('Apiarios Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['detail'] ?? 'Error al obtener apiarios',
        };
      }
    } catch (e) {
      print('Error al obtener apiarios: $e');
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String token,
    required String name,
    required String phone,
    required String email,
  }) async {
    try {
      print('Actualizando perfil con token: ${token.substring(0, 15)}...');

      final response = await http.put(
        Uri.parse('$_baseUrl/me'),
        headers: _getHeaders(token),
        body: jsonEncode({'nombre': name, 'telefono': phone, 'correo': email}),
      );

      print('Actualizar Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
          'message': 'Perfil actualizado correctamente',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['detail'] ?? 'Error al actualizar perfil',
        };
      }
    } catch (e) {
      print('Error al actualizar perfil: $e');
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      print('Cambiando contraseña con token: ${token.substring(0, 15)}...');

      final response = await http.post(
        Uri.parse('$_baseUrl/change-password'),
        headers: _getHeaders(token),
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      print('Cambio Contraseña Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Contraseña actualizada correctamente',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['detail'] ?? 'Error al cambiar contraseña',
        };
      }
    } catch (e) {
      print('Error al cambiar contraseña: $e');
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }
}
