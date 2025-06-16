import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:soft_bee/app/features/admin/user/services/auth_storage.dart';

class AuthService {
  static const String _baseUrl = 'http://192.168.1.10:8000';

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      print('Iniciando sesión para: $email');

      final response = await http.post(
        Uri.parse('$_baseUrl/usuarios/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'correo': email.trim(),
          'contraseña': password.trim(),
        }),
      );

      print('Login Status: ${response.statusCode}');
      print('Login Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        await AuthStorage.saveToken(token);

        // Verificar token inmediatamente
        final verification = await verifyToken(token);
        if (!verification['valid']) {
          await AuthStorage.deleteToken();
          return {
            'success': false,
            'message': 'Error de autenticación. Token inválido recibido.',
          };
        }

        return {'success': true, 'token': token, 'user': verification['user']};
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message':
              'Credenciales incorrectas. Verifique su email y contraseña.',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['detail'] ?? 'Error en el inicio de sesión',
        };
      }
    } catch (e) {
      print('Error en login: $e');
      return {
        'success': false,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> verifyToken(String token) async {
    try {
      print('Verificando token: ${token.substring(0, 15)}...');

      // Usamos el endpoint /me que ya existe
      final response = await http.get(
        Uri.parse('$_baseUrl/usuarios/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Verify Token Status: ${response.statusCode}');
      print('Verify Token Response: ${response.body}');

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        return {
          'valid': true,
          'user': {
            'id': userData['id'],
            'email': userData['correo'],
            'name': userData['nombre'],
          },
        };
      } else {
        return {'valid': false, 'error': 'Token inválido o expirado'};
      }
    } catch (e) {
      print('Error al verificar token: $e');
      return {'valid': false, 'error': 'Error de conexión'};
    }
  }

  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/usuarios/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': name,
          'correo': email,
          'telefono': phone,
          'contraseña': password,
          'apiarios': [{}], // Apiario temporal
        }),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['detail'] ?? 'Error en registro',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  static Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/usuarios/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'correo': email}),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Correo enviado exitosamente'};
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['detail'] ?? 'Error al enviar correo',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  static Future<Map<String, dynamic>> resetPassword(
    String token,
    String newPassword,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/usuarios/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'nueva_contraseña': newPassword}),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Contraseña actualizada exitosamente',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['detail'] ?? 'Error al cambiar contraseña',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }
}
