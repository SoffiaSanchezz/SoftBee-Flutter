import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soft_bee/app/features/admin/monitoring/models/model.dart';
import 'package:soft_bee/app/features/admin/monitoring/page/sync_screen.dart';
import 'package:soft_bee/app/features/admin/monitoring/service/local_db_service.dart';
import 'package:soft_bee/app/features/admin/monitoring/service/sync_service.dart';
import 'package:soft_bee/app/features/admin/monitoring/service/voice_assistant_service.dart';
import 'dart:math' as math;

class MonitoreoApiarioScreen extends StatefulWidget {
  const MonitoreoApiarioScreen({Key? key}) : super(key: key);

  @override
  _MonitoreoApiarioScreenState createState() => _MonitoreoApiarioScreenState();
}

class _MonitoreoApiarioScreenState extends State<MonitoreoApiarioScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  // Controladores
  final TextEditingController _colmenaController = TextEditingController();
  final TextEditingController _nuevaPreguntaController =
      TextEditingController();
  final TextEditingController _editarPreguntaController =
      TextEditingController();
  final TextEditingController _nuevaOpcionController = TextEditingController();

  // Controladores de animación
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Estado
  String? editandoPreguntaId;
  String tipoRespuestaNuevaPregunta = "texto";
  List<Opcion> opcionesNuevaPregunta = [];
  bool _isCardExpanded = false;
  bool _isEditingOptions = false;

  // Lista de preguntas estándar (banco de preguntas)
  List<Pregunta> preguntasEstandar = [
    Pregunta(
      id: "1",
      texto: "Número de colmena",
      seleccionada: false,
      tipoRespuesta: "numero",
      min: 1,
      max: 100,
      obligatoria: true,
    ),
    Pregunta(
      id: "2",
      texto: "Actividad en las piqueras",
      seleccionada: false,
      tipoRespuesta: "opciones",
      opciones: [
        Opcion(valor: "Baja"),
        Opcion(valor: "Media"),
        Opcion(valor: "Alta"),
      ],
      obligatoria: true,
    ),
    Pregunta(
      id: "3",
      texto: "Población de abejas",
      seleccionada: false,
      tipoRespuesta: "opciones",
      opciones: [
        Opcion(valor: "Baja"),
        Opcion(valor: "Media"),
        Opcion(valor: "Alta"),
      ],
      obligatoria: true,
    ),
    Pregunta(
      id: "4",
      texto: "Cuadros de alimento",
      seleccionada: false,
      tipoRespuesta: "numero",
      min: 0,
      max: 10,
      obligatoria: true,
    ),
    Pregunta(
      id: "5",
      texto: "Estado de la reina",
      seleccionada: false,
      tipoRespuesta: "opciones",
      opciones: [
        Opcion(valor: "Presente"),
        Opcion(valor: "Ausente"),
        Opcion(valor: "Celdas reales"),
      ],
    ),
    Pregunta(
      id: "6",
      texto: "Presencia de plagas",
      seleccionada: false,
      tipoRespuesta: "opciones",
      opciones: [
        Opcion(valor: "Ninguna"),
        Opcion(valor: "Varroa"),
        Opcion(valor: "Polilla"),
        Opcion(valor: "Hormigas"),
      ],
    ),
  ];

  // Lista de preguntas seleccionadas para el monitoreo
  List<Pregunta> preguntasSeleccionadas = [];

  // Colores de la paleta
  final Color colorAmarillo = const Color(0xFFFBC209);
  final Color colorNaranja = const Color(0xFFFF9800);
  final Color colorAmbarClaro = const Color(0xFFFFF8E1);
  final Color colorAmbarMedio = const Color(0xFFFFE082);

  // Asistente de voz y servicios
  late VoiceAssistantService voiceAssistant;
  late LocalDBService dbService;
  late SyncService syncService;

  // Estados del asistente de voz
  bool isAssistantActive = false;
  bool isProcessingVoice = false;
  String assistantMessage = '';
  List<MonitoreoRespuesta> respuestasVoz = [];
  List<Apiario> apiarios = [];
  List<Colmena> colmenas = [];
  Apiario? selectedApiario;
  int? selectedColmena;
  int currentQuestionIndex = 0;
  List<Pregunta> preguntasActivas = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Inicializar animaciones
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();

    // Inicializar servicios
    _initServices();
  }

  Future<void> _initServices() async {
    voiceAssistant = VoiceAssistantService();
    dbService = LocalDBService();
    // syncService = SyncScreen();

    await voiceAssistant.initialize();
    await dbService.database; // Inicializar base de datos

    // Cargar datos iniciales
    await _loadInitialData();

    // Configurar listener del asistente de voz
    voiceAssistant.speechResultsController.stream.listen((text) {
      if (isAssistantActive && !isProcessingVoice) {
        _processVoiceInput(text);
      }
    });
  }

  Future<void> _loadInitialData() async {
    try {
      final apiariosList = await dbService.getApiarios();
      final customQuestions = await dbService.getCustomQuestions();

      setState(() {
        apiarios = apiariosList;
        // Agregar preguntas personalizadas al banco
        preguntasEstandar.addAll(customQuestions);
      });
    } catch (e) {
      debugPrint('Error al cargar datos iniciales: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _colmenaController.dispose();
    _nuevaPreguntaController.dispose();
    _editarPreguntaController.dispose();
    _nuevaOpcionController.dispose();
    _animationController.dispose();
    voiceAssistant.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      voiceAssistant.stop();
    }
  }

  // Métodos para manejar preguntas
  void _agregarPreguntaEstandar() async {
    if (_nuevaPreguntaController.text.trim().isEmpty) return;

    final nuevaId = DateTime.now().millisecondsSinceEpoch.toString();
    final nuevaPregunta = Pregunta(
      id: nuevaId,
      texto: _nuevaPreguntaController.text,
      seleccionada: false,
      tipoRespuesta: tipoRespuestaNuevaPregunta,
      opciones:
          tipoRespuestaNuevaPregunta != "texto"
              ? List<Opcion>.from(opcionesNuevaPregunta)
              : null,
    );

    try {
      // Guardar en base de datos
      await dbService.saveCustomQuestion(nuevaPregunta);

      setState(() {
        preguntasEstandar.add(nuevaPregunta);
        _nuevaPreguntaController.clear();
        opcionesNuevaPregunta = [];
        tipoRespuestaNuevaPregunta = "texto";
        _isCardExpanded = false;
      });

      _showSnackBar('Pregunta agregada correctamente', Colors.green);
    } catch (e) {
      _showSnackBar('Error al agregar pregunta: $e', Colors.red);
    }
  }

  void _toggleSeleccionPreguntaEstandar(String id) {
    setState(() {
      final index = preguntasEstandar.indexWhere((p) => p.id == id);
      if (index != -1) {
        preguntasEstandar[index] = preguntasEstandar[index].copyWith(
          seleccionada: !preguntasEstandar[index].seleccionada,
        );

        if (preguntasEstandar[index].seleccionada) {
          // Agregar a preguntas seleccionadas
          preguntasSeleccionadas.add(preguntasEstandar[index]);
        } else {
          // Remover de preguntas seleccionadas
          preguntasSeleccionadas.removeWhere((p) => p.id == id);
        }
      }
    });
  }

  void _eliminarPreguntaEstandar(String id) {
    setState(() {
      preguntasEstandar.removeWhere((pregunta) => pregunta.id == id);
      preguntasSeleccionadas.removeWhere((pregunta) => pregunta.id == id);
    });
  }

  void _removerPreguntaSeleccionada(String id) {
    setState(() {
      preguntasSeleccionadas.removeWhere((p) => p.id == id);
      // Actualizar el estado en el banco estándar
      final index = preguntasEstandar.indexWhere((p) => p.id == id);
      if (index != -1) {
        preguntasEstandar[index] = preguntasEstandar[index].copyWith(
          seleccionada: false,
        );
      }
    });
  }

  void _agregarOpcion() {
    if (_nuevaOpcionController.text.trim().isEmpty) return;
    setState(() {
      opcionesNuevaPregunta.add(Opcion(valor: _nuevaOpcionController.text));
      _nuevaOpcionController.clear();
    });
  }

  void _eliminarOpcion(int index) {
    setState(() {
      opcionesNuevaPregunta.removeAt(index);
    });
  }

  void _reordenarPreguntasSeleccionadas(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = preguntasSeleccionadas.removeAt(oldIndex);
      preguntasSeleccionadas.insert(newIndex, item);
    });
  }

  // Métodos del asistente de voz
  void _startVoiceAssistant() async {
    if (preguntasSeleccionadas.isEmpty) {
      _showSnackBar('Debe seleccionar al menos una pregunta', Colors.orange);
      return;
    }

    setState(() {
      isAssistantActive = true;
      assistantMessage =
          'Bienvenido al sistema de monitoreo de colmenas por voz. Yo soy Maya, te asistiré durante este monitoreo.';
      respuestasVoz = [];
      selectedApiario = null;
      selectedColmena = null;
      currentQuestionIndex = 0;
      preguntasActivas = List.from(preguntasSeleccionadas);
    });

    voiceAssistant.setActive(true);
    await voiceAssistant.speak(assistantMessage);
    _selectApiario();
  }

  void _selectApiario() async {
    final message =
        'Por favor indique el apiario a monitorear. Opciones: ${apiarios.map((a) => a.nombre).join(', ')}';
    setState(() {
      assistantMessage = message;
    });

    await voiceAssistant.speak(message);
    final response = await voiceAssistant.listen(duration: 5);
    if (response.isNotEmpty) {
      _processApiarioSelection(response);
    }
  }

  void _processApiarioSelection(String text) async {
    Apiario? matchedApiario;

    for (var apiario in apiarios) {
      if (voiceAssistant.confirmacionReconocida(
        text,
        apiario.nombre.toLowerCase(),
      )) {
        matchedApiario = apiario;
        break;
      }
    }

    if (matchedApiario != null) {
      setState(() {
        selectedApiario = matchedApiario;
        assistantMessage = 'Apiario seleccionado: ${matchedApiario}.';
      });

      await voiceAssistant.speak(assistantMessage);
      _selectColmena();
    } else {
      final message =
          'Apiario no reconocido. Por favor diga ${apiarios.map((a) => a.nombre).join(', ')}';
      setState(() {
        assistantMessage = message;
      });

      await voiceAssistant.speak(message);
      final response = await voiceAssistant.listen(duration: 5);
      if (response.isNotEmpty) {
        _processApiarioSelection(response);
      }
    }
  }

  void _selectColmena() async {
    if (selectedApiario == null) return;

    try {
      final colmenasList = await dbService.getColmenasByApiario(
        selectedApiario!.id,
      );
      setState(() {
        colmenas = colmenasList;
      });

      final message =
          'Por favor indique el número de colmena. Colmenas disponibles: ${colmenas.map((c) => c.numeroColmena).join(', ')}';
      setState(() {
        assistantMessage = message;
      });

      await voiceAssistant.speak(message);
      final response = await voiceAssistant.listen(duration: 5);
      if (response.isNotEmpty) {
        _processColmenaSelection(response);
      }
    } catch (e) {
      _showSnackBar('Error al cargar colmenas: $e', Colors.red);
    }
  }

  void _processColmenaSelection(String text) async {
    final numeroColmena =
        voiceAssistant.palabrasANumero(text) ?? int.tryParse(text);

    if (numeroColmena != null &&
        colmenas.any((c) => c.numeroColmena == numeroColmena)) {
      setState(() {
        selectedColmena = numeroColmena;
        assistantMessage =
            'Colmena $numeroColmena seleccionada. Comenzaremos con las preguntas.';
        currentQuestionIndex = 0;
      });

      await voiceAssistant.speak(assistantMessage);
      _askQuestion();
    } else {
      final message =
          'Número de colmena no reconocido. Por favor diga un número válido: ${colmenas.map((c) => c.numeroColmena).join(', ')}';
      setState(() {
        assistantMessage = message;
      });

      await voiceAssistant.speak(message);
      final response = await voiceAssistant.listen(duration: 5);
      if (response.isNotEmpty) {
        _processColmenaSelection(response);
      }
    }
  }

  void _askQuestion() async {
    if (currentQuestionIndex >= preguntasActivas.length) {
      _showSummary();
      return;
    }

    final pregunta = preguntasActivas[currentQuestionIndex];
    String questionText = pregunta.texto;

    if (pregunta.tipoRespuesta == 'opciones' && pregunta.opciones != null) {
      final opcionesNumeradas = List<String>.generate(
        pregunta.opciones!.length,
        (index) => '${index + 1} para ${pregunta.opciones![index].valor}',
      );
      questionText +=
          '. Opciones: ${opcionesNumeradas.join(', ')}. Responda con el número de la opción.';
    } else if (pregunta.tipoRespuesta == 'numero') {
      questionText +=
          '. Responda con un número entre ${pregunta.min ?? 0} y ${pregunta.max ?? 100}';
    }

    setState(() {
      assistantMessage = questionText;
    });

    await voiceAssistant.speak(questionText);
    final response = await voiceAssistant.listen(
      duration: pregunta.tipoRespuesta == 'texto' ? 7 : 5,
    );

    if (response.isNotEmpty) {
      await _processQuestionResponse(response);
    }
  }

  Future<void> _processQuestionResponse(String text) async {
    setState(() {
      isProcessingVoice = true;
    });

    final pregunta = preguntasActivas[currentQuestionIndex];
    final respuestaMap = <String, dynamic>{};

    bool respuestaValida = voiceAssistant.procesarRespuestaPregunta(
      pregunta,
      text,
      1,
      respuestaMap,
    );

    if (respuestaValida) {
      final respuesta = MonitoreoRespuesta(
        preguntaId: pregunta.id,
        preguntaTexto: pregunta.texto,
        respuesta: respuestaMap['respuesta'],
      );

      setState(() {
        respuestasVoz.add(respuesta);
        currentQuestionIndex++;
        isProcessingVoice = false;
      });

      if (currentQuestionIndex < preguntasActivas.length) {
        await Future.delayed(Duration(milliseconds: 500));
        _askQuestion();
      } else {
        _showSummary();
      }
    } else {
      setState(() {
        isProcessingVoice = false;
      });
      await voiceAssistant.speak(
        "Respuesta no válida. Por favor intente nuevamente.",
      );
      await Future.delayed(Duration(milliseconds: 1000));
      _askQuestion();
    }
  }

  void _showSummary() async {
    String summary = 'Resumen de respuestas:\n';

    for (var respuesta in respuestasVoz) {
      summary += '${respuesta.preguntaTexto}: ${respuesta.respuesta}\n';
    }

    summary +=
        '¿Los datos son correctos? Diga "confirmar" para guardar o "cancelar" para repetir.';

    setState(() {
      assistantMessage = summary;
    });

    await voiceAssistant.speak(summary);
    final response = await voiceAssistant.listen(duration: 5);
    if (response.isNotEmpty) {
      _processFinalConfirmation(response);
    }
  }

  void _processFinalConfirmation(String text) async {
    if (voiceAssistant.confirmacionReconocida(text, 'confirmar')) {
      await _saveResponses();
    } else if (voiceAssistant.confirmacionReconocida(text, 'cancelar')) {
      setState(() {
        assistantMessage = 'Reiniciando el monitoreo para esta colmena.';
        respuestasVoz = [];
        currentQuestionIndex = 0;
      });

      await voiceAssistant.speak(assistantMessage);
      await Future.delayed(Duration(milliseconds: 1000));
      _askQuestion();
    } else {
      await voiceAssistant.speak(
        "No entendí su respuesta. Por favor diga 'confirmar' para guardar o 'cancelar' para repetir.",
      );
      final response = await voiceAssistant.listen(duration: 5);
      if (response.isNotEmpty) {
        _processFinalConfirmation(response);
      }
    }
  }

  Future<void> _saveResponses() async {
    if (selectedApiario == null || selectedColmena == null) return;

    try {
      final data = {
        'colmena': selectedColmena,
        'id_apiario': selectedApiario!.id,
        'respuestas': respuestasVoz.map((r) => r.toJson()).toList(),
      };

      final monitoreoId = await dbService.saveMonitoreo(data);
      if (monitoreoId > 0) {
        await dbService.saveRespuestas(monitoreoId, respuestasVoz);

        setState(() {
          assistantMessage =
              'Datos guardados correctamente. Monitoreo completado.';
          isAssistantActive = false;
        });

        await voiceAssistant.speak(assistantMessage);
        voiceAssistant.setActive(false);

        // Intentar sincronizar con el servidor
        _syncInBackground();

        _showSnackBar('Monitoreo guardado correctamente', Colors.green);
      } else {
        throw Exception('Error al guardar en base de datos');
      }
    } catch (e) {
      setState(() {
        assistantMessage =
            'Error al guardar los datos. Por favor intente de nuevo.';
      });
      await voiceAssistant.speak('Ocurrió un error al guardar los datos.');
      _showSnackBar('Error: $e', Colors.red);
    }
  }

  void _syncInBackground() async {
    try {
      final pendientes = await dbService.getMonitoreosPendientes();
      if (pendientes.isNotEmpty) {
        final success = await syncService.syncMonitoreos(pendientes);
        if (success) {
          debugPrint('✅ Sincronización exitosa');
        } else {
          debugPrint('⚠️ Error en sincronización - datos guardados localmente');
        }
      }
    } catch (e) {
      debugPrint('❌ Error en sincronización en segundo plano: $e');
    }
  }

  void _stopVoiceAssistant() {
    setState(() {
      isAssistantActive = false;
    });
    voiceAssistant.setActive(false);
    voiceAssistant.stop();
  }

  void _processVoiceInput(String text) async {
    if (isProcessingVoice) return;

    setState(() {
      isProcessingVoice = true;
    });

    try {
      if (selectedApiario == null) {
        _processApiarioSelection(text);
      } else if (selectedColmena == null) {
        _processColmenaSelection(text);
      } else if (currentQuestionIndex < preguntasActivas.length) {
        await _processQuestionResponse(text);
      } else {
        _processFinalConfirmation(text);
      }
    } finally {
      setState(() {
        isProcessingVoice = false;
      });
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _getTypeLabel(String? type) {
    switch (type) {
      case "texto":
        return "Texto";
      case "opciones":
        return "Opciones";
      case "numero":
        return "Número";
      case "rango":
        return "Rango";
      default:
        return "Desconocido";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAmbarClaro,
      appBar: AppBar(
        title: const Text('Monitoreo de Apiario'),
        backgroundColor: colorNaranja,
        foregroundColor: Colors.white,
        actions: [
          if (isAssistantActive)
            IconButton(
              icon: Icon(Icons.stop),
              onPressed: _stopVoiceAssistant,
              tooltip: 'Detener asistente',
            ),
        ],
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isDesktop = constraints.maxWidth > 1024;
                  double maxWidth = isDesktop ? 1200 : double.infinity;

                  return Center(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Información de la colmena
                          _buildColmenaInfo(),

                          const SizedBox(height: 20),

                          // Asistente de voz (si está activo)
                          if (isAssistantActive) _buildVoiceAssistantUI(),

                          if (isAssistantActive) const SizedBox(height: 20),

                          // Contenido principal
                          Expanded(
                            child:
                                isDesktop
                                    ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Primera parte: Banco de preguntas estándar
                                        Expanded(
                                          flex: 1,
                                          child: _buildBancoPreguntasEstandar(),
                                        ),

                                        const SizedBox(width: 20),

                                        // Segunda parte: Visualización y acomodo
                                        Expanded(
                                          flex: 1,
                                          child: _buildVisualizacionAcomodo(),
                                        ),
                                      ],
                                    )
                                    : Column(
                                      children: [
                                        // En móvil, mostrar en pestañas
                                        Expanded(
                                          child: DefaultTabController(
                                            length: 2,
                                            child: Column(
                                              children: [
                                                TabBar(
                                                  labelColor: colorNaranja,
                                                  unselectedLabelColor:
                                                      Colors.grey,
                                                  indicatorColor: colorAmarillo,
                                                  tabs: const [
                                                    Tab(
                                                      text:
                                                          "Banco de Preguntas",
                                                    ),
                                                    Tab(
                                                      text:
                                                          "Preguntas Seleccionadas",
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: TabBarView(
                                                    children: [
                                                      _buildBancoPreguntasEstandar(),
                                                      _buildVisualizacionAcomodo(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                          ),

                          const SizedBox(height: 16),

                          // Resumen y botones
                          _buildResumenYBotones(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            isAssistantActive ? _stopVoiceAssistant : _startVoiceAssistant,
        backgroundColor: isAssistantActive ? Colors.red : colorNaranja,
        child: Icon(
          isAssistantActive ? Icons.stop : Icons.mic,
          color: Colors.white,
        ),
        tooltip: isAssistantActive ? 'Detener Maya' : 'Iniciar Maya',
      ),
    );
  }

  // Widget para información de la colmena
  Widget _buildColmenaInfo() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorAmarillo, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 2 * math.pi),
                    duration: const Duration(seconds: 2),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.rotate(
                        angle: value,
                        child: Icon(Icons.hive, color: colorNaranja, size: 28),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Nombre del Apiario',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorNaranja.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _colmenaController,
                decoration: InputDecoration(
                  hintText: 'Ingrese el número o nombre de la colmena',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorAmarillo),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorNaranja, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para el asistente de voz
  Widget _buildVoiceAssistantUI() {
    return Card(
      elevation: 4,
      color: colorAmbarClaro,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorNaranja, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.mic, color: colorNaranja, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Asistente de Voz - Maya',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: colorNaranja,
                  ),
                ),
                const Spacer(),
                if (isProcessingVoice)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(colorNaranja),
                    ),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _stopVoiceAssistant,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorAmbarMedio),
              ),
              child: Text(
                assistantMessage,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),

            // Mostrar respuestas actuales
            if (respuestasVoz.isNotEmpty) ...[
              Text(
                'Respuestas registradas:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorNaranja,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                constraints: BoxConstraints(maxHeight: 150),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: respuestasVoz.length,
                  itemBuilder: (context, index) {
                    final resp = respuestasVoz[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        '${resp.preguntaTexto}: ${resp.respuesta}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Botones de control
            Row(
              children: [
                if (!isProcessingVoice)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (currentQuestionIndex < preguntasActivas.length) {
                          _askQuestion();
                        } else {
                          _showSummary();
                        }
                      },
                      icon: const Icon(Icons.volume_up, size: 18),
                      label: const Text('Repetir'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorAmarillo,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                if (isProcessingVoice)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorNaranja,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('Procesando...'),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget para el banco de preguntas estándar
  Widget _buildBancoPreguntasEstandar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de sección
        Row(
          children: [
            Icon(Icons.library_books, color: colorNaranja, size: 24),
            const SizedBox(width: 8),
            Text(
              'Banco de Preguntas Estándar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorNaranja,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Agregar nueva pregunta
        _buildAgregarPreguntaCard(),

        const SizedBox(height: 10),

        // Lista de preguntas estándar
        Expanded(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: colorAmbarMedio, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: preguntasEstandar.length,
                itemBuilder: (context, index) {
                  final pregunta = preguntasEstandar[index];
                  return _buildPreguntaEstandarCard(pregunta, index);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget para visualización y acomodo
  Widget _buildVisualizacionAcomodo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de sección
        Row(
          children: [
            Icon(Icons.view_list, color: colorNaranja, size: 24),
            const SizedBox(width: 8),
            Text(
              'Preguntas Seleccionadas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorNaranja,
              ),
            ),
            const Spacer(),
            Text(
              '${preguntasSeleccionadas.length} seleccionadas',
              style: TextStyle(
                color: colorNaranja.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Lista de preguntas seleccionadas
        Expanded(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: colorAmbarMedio, width: 1),
            ),
            child:
                preguntasSeleccionadas.isEmpty
                    ? _buildEmptySelectionState()
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ReorderableListView.builder(
                        itemCount: preguntasSeleccionadas.length,
                        onReorder: _reordenarPreguntasSeleccionadas,
                        itemBuilder: (context, index) {
                          final pregunta = preguntasSeleccionadas[index];
                          return _buildPreguntaSeleccionadaCard(
                            pregunta,
                            index,
                          );
                        },
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  // Widget para estado vacío
  Widget _buildEmptySelectionState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.playlist_add, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No hay preguntas seleccionadas',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Selecciona preguntas del banco estándar\npara agregarlas a tu monitoreo',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  // Widget para tarjeta de pregunta estándar
  Widget _buildPreguntaEstandarCard(Pregunta pregunta, int index) {
    return Card(
      key: Key(pregunta.id),
      color: pregunta.seleccionada ? colorAmbarClaro : Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Checkbox para seleccionar
                Checkbox(
                  value: pregunta.seleccionada,
                  onChanged:
                      (_) => _toggleSeleccionPreguntaEstandar(pregunta.id),
                  activeColor: colorAmarillo,
                ),

                // Texto de la pregunta
                Expanded(
                  child: Text(
                    pregunta.texto,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          pregunta.seleccionada
                              ? Colors.black87
                              : Colors.black54,
                    ),
                  ),
                ),

                // Botones de acción
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  color: colorNaranja,
                  onPressed: () {
                    // Implementar edición
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  color: Colors.red.shade300,
                  onPressed: () => _eliminarPreguntaEstandar(pregunta.id),
                ),
              ],
            ),

            // Mostrar tipo y opciones
            if (pregunta.tipoRespuesta != "texto")
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorAmbarMedio,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getTypeLabel(pregunta.tipoRespuesta),
                            style: TextStyle(
                              fontSize: 12,
                              color: colorNaranja,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (pregunta.opciones != null &&
                        pregunta.opciones!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Opciones: ${pregunta.opciones!.map((o) => o.valor).join(', ')}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget para tarjeta de pregunta seleccionada
  Widget _buildPreguntaSeleccionadaCard(Pregunta pregunta, int index) {
    return Card(
      key: Key('selected-${pregunta.id}'),
      color: colorAmbarClaro,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icono de arrastrar
                const Icon(Icons.drag_handle, color: Colors.grey),

                // Número de orden
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colorNaranja,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Texto de la pregunta
                Expanded(
                  child: Text(
                    pregunta.texto,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                // Botón para remover
                IconButton(
                  icon: const Icon(Icons.remove_circle, size: 20),
                  color: Colors.red.shade300,
                  onPressed: () => _removerPreguntaSeleccionada(pregunta.id),
                ),
              ],
            ),

            // Mostrar opciones si las hay
            if (pregunta.opciones != null && pregunta.opciones!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 8),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children:
                      pregunta.opciones!.map((opcion) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            opcion.valor,
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget para agregar pregunta
  Widget _buildAgregarPreguntaCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: _isCardExpanded ? null : 60,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            // Cabecera
            InkWell(
              onTap: () => setState(() => _isCardExpanded = !_isCardExpanded),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    Icon(Icons.add_circle, color: colorNaranja),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Agregar Nueva Pregunta',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorNaranja,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isCardExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(Icons.expand_more, color: colorNaranja),
                    ),
                  ],
                ),
              ),
            ),

            // Contenido expandible
            if (_isCardExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nuevaPreguntaController,
                      decoration: InputDecoration(
                        hintText: 'Escriba una nueva pregunta',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: colorAmarillo,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Selector de tipo
                    Text(
                      'Tipo de respuesta:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorNaranja.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children:
                          ["texto", "opciones", "numero", "rango"].map((tipo) {
                            return ChoiceChip(
                              label: Text(_getTypeLabel(tipo)),
                              selected: tipoRespuestaNuevaPregunta == tipo,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    tipoRespuestaNuevaPregunta = tipo;
                                    if (tipo == "texto") {
                                      opcionesNuevaPregunta.clear();
                                    }
                                  });
                                }
                              },
                              selectedColor: colorAmarillo,
                            );
                          }).toList(),
                    ),

                    // Mostrar sección de opciones si es necesario
                    if (tipoRespuestaNuevaPregunta == "opciones" ||
                        tipoRespuestaNuevaPregunta == "rango")
                      AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 500),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              'Opciones:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colorNaranja.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Lista de opciones actuales
                            if (opcionesNuevaPregunta.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colorAmbarClaro,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: colorAmbarMedio),
                                ),
                                child: Column(
                                  children:
                                      opcionesNuevaPregunta.asMap().entries.map((
                                        entry,
                                      ) {
                                        int idx = entry.key;
                                        Opcion opcion = entry.value;
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  initialValue: opcion.valor,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 8,
                                                        ),
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      opcionesNuevaPregunta[idx]
                                                          .valor = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  size: 18,
                                                ),
                                                color: Colors.red.shade300,
                                                onPressed:
                                                    () => _eliminarOpcion(idx),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ),

                            const SizedBox(height: 8),

                            // Agregar nueva opción
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _nuevaOpcionController,
                                    decoration: InputDecoration(
                                      hintText: 'Nueva opción',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: _agregarOpcion,
                                  icon: const Icon(Icons.add_circle),
                                  color: colorAmarillo,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 12),

                    // Botón agregar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _agregarPreguntaEstandar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorAmarillo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 18),
                            SizedBox(width: 5),
                            Text('Agregar Pregunta'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget para resumen y botones
  Widget _buildResumenYBotones() {
    return Column(
      children: [
        // Resumen
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorAmbarMedio),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total en banco: ${preguntasEstandar.length}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorNaranja.withOpacity(0.8),
                ),
              ),
              Text(
                'Seleccionadas: ${preguntasSeleccionadas.length}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorNaranja.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Botones
        Row(
          children: [
            // Botón ver preguntas
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                    preguntasSeleccionadas.isNotEmpty
                        ? () {
                          // Navegar a pantalla de visualización
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => VisualizacionPreguntasScreen(
                                    preguntas: preguntasSeleccionadas,
                                    colmena:
                                        _colmenaController.text.trim().isEmpty
                                            ? "Sin nombre"
                                            : _colmenaController.text,
                                    colorAmarillo: colorAmarillo,
                                    colorNaranja: colorNaranja,
                                    colorAmbarClaro: colorAmbarClaro,
                                    colorAmbarMedio: colorAmbarMedio,
                                  ),
                            ),
                          );
                        }
                        : null,
                icon: const Icon(Icons.visibility, size: 18),
                label: const Text('Ver Preguntas'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorAmarillo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Botón configurar monitoreo
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                    preguntasSeleccionadas.isNotEmpty
                        ? () {
                          _showSnackBar(
                            'Monitoreo configurado con ${preguntasSeleccionadas.length} preguntas',
                            Colors.green,
                          );
                        }
                        : null,
                icon: const Icon(Icons.save, size: 18),
                label: const Text('Configurar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorNaranja,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Pantalla de visualización de preguntas
class VisualizacionPreguntasScreen extends StatelessWidget {
  final List<Pregunta> preguntas;
  final String colmena;
  final Color colorAmarillo;
  final Color colorNaranja;
  final Color colorAmbarClaro;
  final Color colorAmbarMedio;

  const VisualizacionPreguntasScreen({
    Key? key,
    required this.preguntas,
    required this.colmena,
    required this.colorAmarillo,
    required this.colorNaranja,
    required this.colorAmbarClaro,
    required this.colorAmbarMedio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAmbarClaro,
      appBar: AppBar(
        title: const Text('Preguntas del Monitoreo'),
        backgroundColor: colorNaranja,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Información de la colmena
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: colorAmarillo, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.hive, color: colorNaranja, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Colmena: $colmena',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorNaranja,
                              ),
                            ),
                            Text(
                              '${preguntas.length} preguntas configuradas',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Lista de preguntas
              Expanded(
                child: ListView.builder(
                  itemCount: preguntas.length,
                  itemBuilder: (context, index) {
                    final pregunta = preguntas[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: colorNaranja,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    pregunta.texto,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (pregunta.opciones != null &&
                                pregunta.opciones!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 36,
                                  top: 8,
                                ),
                                child: Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children:
                                      pregunta.opciones!.map((opcion) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: colorAmbarClaro,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: colorAmbarMedio,
                                            ),
                                          ),
                                          child: Text(
                                            opcion.valor,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Botón iniciar monitoreo
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.play_arrow, color: Colors.white),
                            const SizedBox(width: 10),
                            Text('Iniciando monitoreo de $colmena...'),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow, size: 20),
                  label: const Text(
                    'Iniciar Monitoreo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorNaranja,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}