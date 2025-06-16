import 'package:flutter/material.dart';
import 'package:soft_bee/app/features/admin/user/models/user_models.dart';
import 'package:soft_bee/app/features/admin/user/services/auth_storage.dart';
import 'package:soft_bee/app/features/admin/user/services/user_service.dart';
import 'package:provider/provider.dart'; 


class UserConfigController with ChangeNotifier {
  final UserProfileService _userService = UserProfileService();

  String? userName;
  List<Apiary> apiarios = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadUserData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = await AuthStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token available');
      }

      // Obtener perfil
      final profileResponse = await _userService.getProfile(token);
      if (!profileResponse['success']) {
        throw Exception(profileResponse['message']);
      }

      // Obtener apiarios
      final apiariesResponse = await _userService.getUserApiaries(token);
      if (!apiariesResponse['success']) {
        throw Exception(apiariesResponse['message']);
      }

      setState(() {
        userName = profileResponse['data']['nombre'];
        apiarios =
            (apiariesResponse['data'] as List)
                .map((apiary) => Apiary.fromJson(apiary))
                .toList();
      });
    } catch (e) {
      errorMessage = 'Error loading user data: $e';
      debugPrint('Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Método auxiliar para actualizar el estado
  void setState(void Function() fn) {
    fn();
    notifyListeners();
  }

  Future<bool> updateProfile({
    required String name,
    required String phone,
    required String email,
  }) async {
    try {
      final token = await AuthStorage.getToken();
      if (token == null) return false;

      final response = await _userService.updateProfile(
        token: token,
        name: name,
        phone: phone,
        email: email,
      );

      if (response['success']) {
        await loadUserData(); // Recargar datos
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    }
  }
}
