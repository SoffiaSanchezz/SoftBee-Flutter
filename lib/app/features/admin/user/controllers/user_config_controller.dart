import 'package:flutter/material.dart';
import 'package:soft_bee/core/entities/user.dart';
import '../services/user_config_service.dart';

class UserConfigController with ChangeNotifier {
  final _service = ApiService();

  String? userName;
  List<Apiario> apiarios = [];

  bool isLoading = false;

  Future<void> loadUserData(int userId) async {
    isLoading = true;
    notifyListeners();

    try {
      final user = await _service.getUserSettings(userId.toString());
      userName = user.nombre;
      // apiarios = user.apiarios;
    } catch (e) {
      debugPrint('Error: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}
