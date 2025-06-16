import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:soft_bee/app/features/auth/data/service/user_service.dart';

class AuthStorage {
  static const _storage = FlutterSecureStorage();
  static const _keyToken = 'auth_token';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
    print('Token guardado correctamente');
  }

  static Future<String?> getToken() async {
    final token = await _storage.read(key: _keyToken);
    print('Token recuperado: ${token != null ? "*****" : "null"}');
    return token;
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
    print('Token eliminado');
  }

  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<bool> hasValidToken() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return false;

    try {
      final verification = await AuthService.verifyToken(token);
      return verification['valid'] == true;
    } catch (e) {
      return false;
    }
  }
}
