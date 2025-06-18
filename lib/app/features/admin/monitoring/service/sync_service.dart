import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'local_db_service.dart';

class SyncService {
  static const String baseUrl = 'https://tu-api.com/api'; // Cambia por tu URL
  static const Duration timeoutDuration = Duration(seconds: 30);

  final LocalDBService _dbService = LocalDBService();

  // Headers comunes para las peticiones
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // Agregar token de autenticación si es necesario
    // 'Authorization': 'Bearer $token',
  };

  Future<bool> syncMonitoreos(List<Map<String, dynamic>> monitoreos) async {
    if (monitoreos.isEmpty) {
      debugPrint('📤 No hay monitoreos para sincronizar');
      return true;
    }

    try {
      debugPrint(
        '📤 Iniciando sincronización de ${monitoreos.length} monitoreos...',
      );

      // Verificar conectividad
      if (!await _hasInternetConnection()) {
        debugPrint('❌ Sin conexión a internet');
        return false;
      }

      bool allSynced = true;

      for (final monitoreo in monitoreos) {
        try {
          final success = await _syncSingleMonitoreo(monitoreo);
          if (success) {
            // Marcar como sincronizado en la base de datos local
            await _dbService.marcarMonitoreoComoSincronizado(monitoreo['id']);
            debugPrint('✅ Monitoreo ${monitoreo['id']} sincronizado');
          } else {
            allSynced = false;
            debugPrint('❌ Error al sincronizar monitoreo ${monitoreo['id']}');
          }
        } catch (e) {
          allSynced = false;
          debugPrint(
            '❌ Excepción al sincronizar monitoreo ${monitoreo['id']}: $e',
          );
        }
      }

      if (allSynced) {
        debugPrint('✅ Todos los monitoreos sincronizados correctamente');
      } else {
        debugPrint('⚠️ Algunos monitoreos no se pudieron sincronizar');
      }

      return allSynced;
    } catch (e) {
      debugPrint('❌ Error general en sincronización: $e');
      return false;
    }
  }

  Future<bool> _syncSingleMonitoreo(Map<String, dynamic> monitoreo) async {
    try {
      // Preparar datos para envío
      final dataToSend = {
        'id_local': monitoreo['id'],
        'id_colmena': monitoreo['id_colmena'],
        'id_apiario': monitoreo['id_apiario'],
        'fecha': monitoreo['fecha'],
        'respuestas': monitoreo['respuestas'],
        'datos_adicionales':
            monitoreo['datos_json'] != null
                ? jsonDecode(monitoreo['datos_json'])
                : null,
      };

      final response = await http
          .post(
            Uri.parse('$baseUrl/monitoreos'),
            headers: _headers,
            body: jsonEncode(dataToSend),
          )
          .timeout(timeoutDuration);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = jsonDecode(response.body);
        debugPrint(
          '📤 Respuesta del servidor: ${responseData['message'] ?? 'OK'}',
        );
        return true;
      } else {
        debugPrint('❌ Error HTTP ${response.statusCode}: ${response.body}');
        return false;
      }
    } on SocketException {
      debugPrint('❌ Error de conexión de red');
      return false;
    } on http.ClientException {
      debugPrint('❌ Error del cliente HTTP');
      return false;
    } catch (e) {
      debugPrint('❌ Error inesperado: $e');
      return false;
    }
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Método para sincronización automática periódica
  Future<void> startPeriodicSync({
    Duration interval = const Duration(minutes: 15),
  }) async {
    debugPrint(
      '🔄 Iniciando sincronización periódica cada ${interval.inMinutes} minutos',
    );

    Stream.periodic(interval).listen((_) async {
      try {
        final pendientes = await _dbService.getMonitoreosPendientes();
        if (pendientes.isNotEmpty) {
          debugPrint(
            '🔄 Sincronización automática: ${pendientes.length} monitoreos pendientes',
          );
          await syncMonitoreos(pendientes);
        }
      } catch (e) {
        debugPrint('❌ Error en sincronización automática: $e');
      }
    });
  }

  // Método para obtener configuración del servidor
  Future<Map<String, dynamic>?> getServerConfig() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/config'), headers: _headers)
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint('❌ Error al obtener configuración del servidor: $e');
    }
    return null;
  }

  // Método para enviar logs de error
  Future<void> sendErrorLog(String error, Map<String, dynamic>? context) async {
    try {
      final logData = {
        'error': error,
        'context': context,
        'timestamp': DateTime.now().toIso8601String(),
        'platform': Platform.operatingSystem,
      };

      await http
          .post(
            Uri.parse('$baseUrl/logs/error'),
            headers: _headers,
            body: jsonEncode(logData),
          )
          .timeout(Duration(seconds: 10));
    } catch (e) {
      debugPrint('❌ Error al enviar log: $e');
    }
  }

  // Método para verificar el estado del servidor
  Future<bool> checkServerHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'), headers: _headers)
          .timeout(Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ Servidor no disponible: $e');
      return false;
    }
  }

  // Método para obtener estadísticas del servidor
  Future<Map<String, dynamic>?> getServerStats() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/stats'), headers: _headers)
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint('❌ Error al obtener estadísticas: $e');
    }
    return null;
  }
}
