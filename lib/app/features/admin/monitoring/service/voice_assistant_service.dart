import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:soft_bee/app/features/admin/monitoring/models/model.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:fuzzywuzzy/fuzzywuzzy.dart';


class VoiceAssistantService {
  final FlutterTts tts = FlutterTts();
  final stt.SpeechToText speech = stt.SpeechToText();
  bool isListening = false;
  String lastRecognized = '';
  StreamController<String> speechResultsController =
      StreamController<String>.broadcast();

  // Estados del flujo de monitoreo
  bool isActive = false;
  String currentMessage = '';
  List<MonitoreoRespuesta> respuestas = [];

  Future<void> initialize() async {
    await tts.setLanguage("es-ES");
    await tts.setSpeechRate(0.6);
    await tts.setVolume(1.0);
    await tts.setPitch(1.0);

    // Configurar TTS para Android
    if (Platform.isAndroid) {
      await tts.setEngine("com.google.android.tts");
    }
  }

  Future<void> speak(String text) async {
    try {
      await tts.awaitSpeakCompletion(true);
      await tts.speak(text);
      debugPrint("🤖 MAYA: $text");
    } catch (e) {
      debugPrint("Error en TTS: $e");
    }
  }

  Future<String> listen({int duration = 5}) async {
    if (isListening) return '';

    try {
      isListening = true;
      debugPrint("\n🎤 [ESCUCHANDO...]");

      bool available = await speech.initialize(
        onStatus: (status) {
          debugPrint("Estado del reconocimiento: $status");
          if (status == 'done' || status == 'notListening') {
            isListening = false;
          }
        },
        onError: (error) {
          isListening = false;
          debugPrint("❌ Error en reconocimiento: $error");
        },
      );

      if (!available) {
        isListening = false;
        debugPrint("❌ El reconocimiento de voz no está disponible");
        return '';
      }

      final Completer<String> completer = Completer<String>();
      String recognizedText = '';

      speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            recognizedText = result.recognizedWords.toLowerCase().trim();
            speechResultsController.add(recognizedText);
            debugPrint("👤 USUARIO: $recognizedText");
            if (!completer.isCompleted) {
              completer.complete(recognizedText);
            }
          }
        },
        listenFor: Duration(seconds: duration),
        pauseFor: Duration(seconds: 2),
        cancelOnError: true,
        partialResults: false,
        localeId: 'es_ES',
      );

      // Timeout de seguridad
      Timer(Duration(seconds: duration + 2), () {
        if (!completer.isCompleted) {
          isListening = false;
          speech.stop();
          completer.complete(recognizedText);
        }
      });

      return await completer.future;
    } catch (e) {
      isListening = false;
      debugPrint("❌ Error en listen: $e");
      return '';
    }
  }

  bool confirmacionReconocida(String respuesta, String palabraClave) {
    const umbralSimilitud = 70;

    final variaciones = {
      'confirmar': [
        'confirmar',
        'confirma',
        'confirmo',
        'confirmado',
        'conforme',
        'sí',
        'si',
        'vale',
        'ok',
        'okay',
        'correcto',
        'exacto',
      ],
      'cancelar': [
        'cancelar',
        'cancela',
        'cancelado',
        'cancelo',
        'no',
        'incorrecto',
        'mal',
        'error',
        'repetir',
      ],
    };

    respuesta = respuesta.toLowerCase().trim();

    // Búsqueda directa
    if (respuesta.contains(palabraClave.toLowerCase())) {
      return true;
    }

    // Búsqueda en variaciones
    if (variaciones[palabraClave]?.any((v) => respuesta.contains(v)) ?? false) {
      return true;
    }

    // Búsqueda difusa
    if (ratio(palabraClave.toLowerCase(), respuesta) > umbralSimilitud) {
      return true;
    }

    return variaciones[palabraClave]?.any(
          (v) => ratio(v, respuesta) > umbralSimilitud,
        ) ??
        false;
  }

  int? palabrasANumero(String texto) {
    if (texto.isEmpty) return null;

    final numeros = {
      'cero': 0,
      'sero': 0,
      'xero': 0,
      'uno': 1,
      'un': 1,
      'una': 1,
      'primero': 1,
      'primer': 1,
      'dos': 2,
      'segundo': 2,
      'tres': 3,
      'tercero': 3,
      'tercer': 3,
      'cuatro': 4,
      'cuarto': 4,
      'cinco': 5,
      'quinto': 5,
      'seis': 6,
      'sexto': 6,
      'siete': 7,
      'séptimo': 7,
      'septimo': 7,
      'ocho': 8,
      'octavo': 8,
      'nueve': 9,
      'noveno': 9,
      'diez': 10,
      'décimo': 10,
      'decimo': 10,
      'once': 11,
      'doce': 12,
      'trece': 13,
      'catorce': 14,
      'quince': 15,
      'dieciséis': 16,
      'dieciseis': 16,
      'diecisiete': 17,
      'dieciocho': 18,
      'diecinueve': 19,
      'veinte': 20,
    };

    // Limpiar texto
    String textoLimpio =
        texto
            .replaceAll(RegExp(r'[^a-zA-ZáéíóúüñÁÉÍÓÚÜÑ0-9]'), ' ')
            .toLowerCase()
            .trim();

    // Buscar número directo
    final numeroDirecto = int.tryParse(textoLimpio);
    if (numeroDirecto != null) return numeroDirecto;

    // Buscar en palabras
    for (final palabra in textoLimpio.split(' ')) {
      if (numeros.containsKey(palabra)) {
        return numeros[palabra];
      }
    }

    // Búsqueda difusa
    for (final entry in numeros.entries) {
      if (ratio(entry.key, textoLimpio) > 80) {
        return entry.value;
      }
    }

    return null;
  }

  bool procesarRespuestaPregunta(
    Pregunta pregunta,
    String respuesta,
    int intentos,
    Map<String, dynamic> respuestaMap,
  ) {
    String tipo = pregunta.tipoRespuesta ?? 'texto';
    respuesta = respuesta.trim().toLowerCase();

    debugPrint("🔍 Procesando respuesta: '$respuesta' para tipo: $tipo");

    switch (tipo) {
      case 'opciones':
        return _procesarOpciones(pregunta, respuesta, respuestaMap);
      case 'numero':
        return _procesarNumero(pregunta, respuesta, respuestaMap, intentos);
      case 'rango':
        return _procesarRango(pregunta, respuesta, respuestaMap);
      default:
        respuestaMap['respuesta'] = respuesta;
        return true;
    }
  }

  bool _procesarOpciones(
    Pregunta pregunta,
    String respuesta,
    Map<String, dynamic> respuestaMap,
  ) {
    if (pregunta.opciones == null || pregunta.opciones!.isEmpty) {
      return false;
    }

    final opciones =
        pregunta.opciones!.map((o) => o.valor.toLowerCase()).toList();

    debugPrint("📋 Opciones disponibles: $opciones");

    // Buscar por número
    int? numero = palabrasANumero(respuesta);
    if (numero == null) {
      // Intentar extraer número de la respuesta
      final match = RegExp(r'\d+').firstMatch(respuesta);
      if (match != null) {
        numero = int.tryParse(match.group(0)!);
      }
    }

    if (numero != null && numero > 0 && numero <= opciones.length) {
      respuestaMap['respuesta'] = pregunta.opciones![numero - 1].valor;
      debugPrint(
        "✅ Opción seleccionada por número: ${respuestaMap['respuesta']}",
      );
      return true;
    }

    // Búsqueda difusa por texto
    String? mejorOpcion;
    int mejorPuntaje = 0;

    for (int i = 0; i < opciones.length; i++) {
      final opcion = opciones[i];

      // Coincidencia exacta
      if (respuesta.contains(opcion) || opcion.contains(respuesta)) {
        respuestaMap['respuesta'] = pregunta.opciones![i].valor;
        debugPrint(
          "✅ Opción encontrada por coincidencia: ${respuestaMap['respuesta']}",
        );
        return true;
      }

      // Búsqueda difusa
      final puntaje = ratio(opcion, respuesta);
      if (puntaje > mejorPuntaje && puntaje > 60) {
        mejorPuntaje = puntaje;
        mejorOpcion = pregunta.opciones![i].valor;
      }
    }

    if (mejorOpcion != null) {
      respuestaMap['respuesta'] = mejorOpcion;
      debugPrint(
        "✅ Opción encontrada por similitud ($mejorPuntaje%): $mejorOpcion",
      );
      return true;
    }

    debugPrint("❌ No se encontró opción válida");
    return false;
  }

  bool _procesarNumero(
    Pregunta pregunta,
    String respuesta,
    Map<String, dynamic> respuestaMap,
    int intentos,
  ) {
    int? numero = palabrasANumero(respuesta);

    if (numero == null) {
      // Intentar extraer número de la respuesta
      final match = RegExp(r'\d+').firstMatch(respuesta);
      if (match != null) {
        numero = int.tryParse(match.group(0)!);
      }
    }

    if (numero == null && intentos < 2) {
      debugPrint("❌ No se pudo extraer número de: '$respuesta'");
      return false;
    }

    if (numero == null) {
      // Si después de varios intentos no hay número, usar 0 como default
      numero = 0;
    }

    final min = pregunta.min ?? 0;
    final max = pregunta.max ?? 100;

    if (numero < min || numero > max) {
      if (intentos < 2) {
        speak("El valor debe estar entre $min y $max. Usted dijo $numero.");
        debugPrint(
          "❌ Número fuera de rango: $numero (debe estar entre $min y $max)",
        );
      }
      return false;
    }

    respuestaMap['respuesta'] = numero;
    debugPrint("✅ Número válido: $numero");
    return true;
  }

  bool _procesarRango(
    Pregunta pregunta,
    String respuesta,
    Map<String, dynamic> respuestaMap,
  ) {
    // Para rangos, tratamos como opciones numeradas
    return _procesarOpciones(pregunta, respuesta, respuestaMap);
  }

  void stop() {
    try {
      tts.stop();
      if (isListening) {
        speech.stop();
        isListening = false;
      }
    } catch (e) {
      debugPrint("Error al detener servicios: $e");
    }
  }

  void dispose() {
    speechResultsController.close();
    stop();
  }

  // Métodos de utilidad para el estado
  void setActive(bool active) {
    isActive = active;
  }

  void setMessage(String message) {
    currentMessage = message;
  }

  void addRespuesta(MonitoreoRespuesta respuesta) {
    respuestas.add(respuesta);
  }

  void clearRespuestas() {
    respuestas.clear();
  }

  List<MonitoreoRespuesta> getRespuestas() {
    return List.from(respuestas);
  }
}
