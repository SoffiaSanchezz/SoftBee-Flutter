import 'package:flutter/material.dart';
import 'dart:math' as math;

// Clase para las opciones de respuesta
class Opcion {
  String valor;
  String? descripcion;

  Opcion({required this.valor, this.descripcion});
}

// Clase para preguntas con opciones
class Pregunta {
  String id;
  String texto;
  bool seleccionada;
  List<Opcion>? opciones;
  String? tipoRespuesta; // "texto", "opciones", "numero", "rango"
  String? respuestaSeleccionada;

  Pregunta({
    required this.id,
    required this.texto,
    required this.seleccionada,
    this.opciones,
    this.tipoRespuesta = "texto",
    this.respuestaSeleccionada,
  });
}

// Pantalla principal de monitoreo
class MonitoreoApiarioScreen extends StatefulWidget {
  const MonitoreoApiarioScreen({Key? key}) : super(key: key);

  @override
  _MonitoreoApiarioScreenState createState() => _MonitoreoApiarioScreenState();
}

class _MonitoreoApiarioScreenState extends State<MonitoreoApiarioScreen>
    with SingleTickerProviderStateMixin {
  // Controladores
  final TextEditingController _colmenaController = TextEditingController();
  final TextEditingController _nuevaPreguntaController =
      TextEditingController();
  final TextEditingController _editarPreguntaController =
      TextEditingController();
  final TextEditingController _nuevaOpcionController = TextEditingController();
  final TextEditingController _editarOpcionController = TextEditingController();

  // Controladores de animación
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  // Estado
  String? editandoPreguntaId;
  String? editandoOpcionIndex;
  String tipoRespuestaNuevaPregunta = "texto";
  List<Opcion> opcionesNuevaPregunta = [];
  bool _isCardExpanded = false;
  bool _isEditingOptions = false;

  // Lista de preguntas con opciones
  List<Pregunta> preguntas = [
    Pregunta(
      id: "1",
      texto: "Número de colmena",
      seleccionada: true,
      tipoRespuesta: "texto",
    ),
    Pregunta(
      id: "2",
      texto: "Actividad en las piqueras",
      seleccionada: true,
      tipoRespuesta: "opciones",
      opciones: [
        Opcion(valor: "Baja"),
        Opcion(valor: "Media"),
        Opcion(valor: "Alta"),
      ],
    ),
    Pregunta(
      id: "3",
      texto: "Población de abejas",
      seleccionada: true,
      tipoRespuesta: "opciones",
      opciones: [
        Opcion(valor: "Baja"),
        Opcion(valor: "Media"),
        Opcion(valor: "Alta"),
      ],
    ),
    Pregunta(
      id: "4",
      texto: "Cuadros de alimento",
      seleccionada: true,
      tipoRespuesta: "rango",
      opciones: [
        Opcion(valor: "1"),
        Opcion(valor: "2"),
        Opcion(valor: "3"),
        Opcion(valor: "4"),
        Opcion(valor: "5"),
      ],
    ),
  ];

  // Colores de la paleta
  final Color colorAmarillo = const Color(0xFFFBC209);
  final Color colorNaranja = const Color(0xFFFF9800);
  final Color colorAmbarClaro = const Color(0xFFFFF8E1);
  final Color colorAmbarMedio = const Color(0xFFFFE082);

  @override
  void initState() {
    super.initState();

    // Inicializar controlador de animación
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Definir animaciones
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

    _rotateAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Iniciar animación
    _animationController.forward();
  }

  @override
  void dispose() {
    _colmenaController.dispose();
    _nuevaPreguntaController.dispose();
    _editarPreguntaController.dispose();
    _nuevaOpcionController.dispose();
    _editarOpcionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Agregar nueva pregunta
  void _agregarPregunta() {
    if (_nuevaPreguntaController.text.trim().isEmpty) return;

    setState(() {
      final nuevaId = (preguntas.length + 1).toString();
      preguntas.add(
        Pregunta(
          id: nuevaId,
          texto: _nuevaPreguntaController.text,
          seleccionada: true,
          tipoRespuesta: tipoRespuestaNuevaPregunta,
          opciones:
              tipoRespuestaNuevaPregunta != "texto"
                  ? List<Opcion>.from(opcionesNuevaPregunta)
                  : null,
        ),
      );
      _nuevaPreguntaController.clear();
      opcionesNuevaPregunta = [];
      tipoRespuestaNuevaPregunta = "texto";
    });

    // Animar cuando se agrega una pregunta
    _animationController.reset();
    _animationController.forward();
  }

  // Agregar opción
  void _agregarOpcion() {
    if (_nuevaOpcionController.text.trim().isEmpty) return;

    setState(() {
      opcionesNuevaPregunta.add(Opcion(valor: _nuevaOpcionController.text));
      _nuevaOpcionController.clear();
    });
  }

  // Eliminar opción
  void _eliminarOpcion(int index) {
    setState(() {
      opcionesNuevaPregunta.removeAt(index);
    });
  }

  // Eliminar opción de una pregunta existente
  void _eliminarOpcionDePregunta(String preguntaId, int opcionIndex) {
    setState(() {
      final index = preguntas.indexWhere((p) => p.id == preguntaId);
      if (index != -1 && preguntas[index].opciones != null) {
        preguntas[index].opciones!.removeAt(opcionIndex);
      }
    });
  }

  // Agregar opción a una pregunta existente
  void _agregarOpcionAPregunta(String preguntaId, String valorOpcion) {
    if (valorOpcion.trim().isEmpty) return;

    setState(() {
      final index = preguntas.indexWhere((p) => p.id == preguntaId);
      if (index != -1) {
        if (preguntas[index].opciones == null) {
          preguntas[index].opciones = [];
        }
        preguntas[index].opciones!.add(Opcion(valor: valorOpcion));
      }
    });
    _nuevaOpcionController.clear();
  }

  // Iniciar edición de opción
  void _iniciarEdicionOpcion(
    String preguntaId,
    int opcionIndex,
    String valorActual,
  ) {
    setState(() {
      editandoPreguntaId = preguntaId;
      editandoOpcionIndex = opcionIndex.toString();
      _editarOpcionController.text = valorActual;
    });
  }

  // Guardar edición de opción
  void _guardarEdicionOpcion() {
    if (editandoPreguntaId == null || editandoOpcionIndex == null) return;

    setState(() {
      final preguntaIndex = preguntas.indexWhere(
        (p) => p.id == editandoPreguntaId,
      );
      if (preguntaIndex != -1 && preguntas[preguntaIndex].opciones != null) {
        final opcionIndex = int.parse(editandoOpcionIndex!);
        if (opcionIndex < preguntas[preguntaIndex].opciones!.length) {
          preguntas[preguntaIndex].opciones![opcionIndex].valor =
              _editarOpcionController.text;
        }
      }
      editandoPreguntaId = null;
      editandoOpcionIndex = null;
    });
  }

  // Cancelar edición de opción
  void _cancelarEdicionOpcion() {
    setState(() {
      editandoPreguntaId = null;
      editandoOpcionIndex = null;
    });
  }

  // Eliminar pregunta
  void _eliminarPregunta(String id) {
    setState(() {
      preguntas.removeWhere((pregunta) => pregunta.id == id);
    });
  }

  // Iniciar edición
  void _iniciarEdicion(String id, String texto) {
    setState(() {
      editandoPreguntaId = id;
      _editarPreguntaController.text = texto;
      _isEditingOptions = false;
    });
  }

  // Iniciar edición de opciones
  void _iniciarEdicionOpciones(String id) {
    setState(() {
      editandoPreguntaId = id;
      _isEditingOptions = true;
    });
  }

  // Guardar edición
  void _guardarEdicion() {
    if (editandoPreguntaId == null) return;

    setState(() {
      final index = preguntas.indexWhere((p) => p.id == editandoPreguntaId);
      if (index != -1) {
        preguntas[index].texto = _editarPreguntaController.text;
      }
      editandoPreguntaId = null;
      _isEditingOptions = false;
    });
  }

  // Cancelar edición
  void _cancelarEdicion() {
    setState(() {
      editandoPreguntaId = null;
      _isEditingOptions = false;
    });
  }

  // Cambiar selección
  void _toggleSeleccion(String id) {
    setState(() {
      final index = preguntas.indexWhere((p) => p.id == id);
      if (index != -1) {
        preguntas[index].seleccionada = !preguntas[index].seleccionada;
      }
    });
  }

  // Reordenar preguntas
  void _reordenarPreguntas(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = preguntas.removeAt(oldIndex);
      preguntas.insert(newIndex, item);
    });
  }

  // Navegar a la pantalla de preguntas (solo visualización)
  void _navegarAPantallaPreguntas() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => PreguntasScreen(
              preguntas: preguntas.where((p) => p.seleccionada).toList(),
              colorAmarillo: colorAmarillo,
              colorNaranja: colorNaranja,
              colorAmbarClaro: colorAmbarClaro,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutQuart;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  // Alternar expansión de la tarjeta
  void _toggleCardExpansion() {
    setState(() {
      _isCardExpanded = !_isCardExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAmbarClaro,
      appBar: AppBar(
        title: const Text('Monitoreo de Apiario'),
        backgroundColor: colorNaranja,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información de la colmena con animación
                    TweenAnimationBuilder<double>(
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
                                    tween: Tween<double>(
                                      begin: 0,
                                      end: 2 * math.pi,
                                    ),
                                    duration: const Duration(seconds: 2),
                                    curve: Curves.elasticOut,
                                    builder: (context, value, child) {
                                      return Transform.rotate(
                                        angle: value,
                                        child: Icon(
                                          Icons.hive,
                                          color: colorNaranja,
                                          size: 28,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Número/Nombre de la Colmena',
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
                                  hintText:
                                      'Ingrese el número o nombre de la colmena',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: colorAmarillo,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: colorNaranja,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Título de sección con animación
                    TweenAnimationBuilder<Offset>(
                      tween: Tween<Offset>(
                        begin: const Offset(-0.5, 0),
                        end: Offset.zero,
                      ),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutCubic,
                      builder: (context, offset, child) {
                        return FractionalTranslation(
                          translation: offset,
                          child: child,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Preguntas de Monitoreo',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorNaranja,
                            ),
                          ),
                          // Botón para mostrar en otra pantalla con animación
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 1200),
                            curve: Curves.elasticOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: child,
                              );
                            },
                            child: ElevatedButton.icon(
                              onPressed: _navegarAPantallaPreguntas,
                              icon: const Icon(Icons.visibility, size: 16),
                              label: const Text('Ver Preguntas'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorNaranja,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Agregar nueva pregunta con opciones (con animación de expansión)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      height: _isCardExpanded ? null : 80,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // Cabecera siempre visible
                            InkWell(
                              onTap: _toggleCardExpansion,
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  children: [
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
                                      turns: _isCardExpanded ? 0.4 : 0,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: colorNaranja,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Contenido expandible
                            AnimatedCrossFade(
                              firstChild: const SizedBox(height: 0),
                              secondChild: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16.0,
                                  0,
                                  16.0,
                                  16.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextField(
                                      controller: _nuevaPreguntaController,
                                      decoration: InputDecoration(
                                        hintText: 'Escriba una nueva pregunta',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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

                                    // Selector de tipo de respuesta
                                    Text(
                                      'Tipo de respuesta:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: colorNaranja.withOpacity(0.8),
                                      ),
                                    ),

                                    Wrap(
                                      spacing: 8,
                                      children: [
                                        ChoiceChip(
                                          label: const Text('Texto'),
                                          selected:
                                              tipoRespuestaNuevaPregunta ==
                                              "texto",
                                          onSelected: (selected) {
                                            if (selected) {
                                              setState(() {
                                                tipoRespuestaNuevaPregunta =
                                                    "texto";
                                              });
                                            }
                                          },
                                          selectedColor: colorAmarillo,
                                        ),
                                        ChoiceChip(
                                          label: const Text('Opciones'),
                                          selected:
                                              tipoRespuestaNuevaPregunta ==
                                              "opciones",
                                          onSelected: (selected) {
                                            if (selected) {
                                              setState(() {
                                                tipoRespuestaNuevaPregunta =
                                                    "opciones";
                                              });
                                            }
                                          },
                                          selectedColor: colorAmarillo,
                                        ),
                                        ChoiceChip(
                                          label: const Text('Número'),
                                          selected:
                                              tipoRespuestaNuevaPregunta ==
                                              "numero",
                                          onSelected: (selected) {
                                            if (selected) {
                                              setState(() {
                                                tipoRespuestaNuevaPregunta =
                                                    "numero";
                                              });
                                            }
                                          },
                                          selectedColor: colorAmarillo,
                                        ),
                                        ChoiceChip(
                                          label: const Text('Rango'),
                                          selected:
                                              tipoRespuestaNuevaPregunta ==
                                              "rango",
                                          onSelected: (selected) {
                                            if (selected) {
                                              setState(() {
                                                tipoRespuestaNuevaPregunta =
                                                    "rango";
                                              });
                                            }
                                          },
                                          selectedColor: colorAmarillo,
                                        ),
                                      ],
                                    ),

                                    // Mostrar sección de opciones solo si es necesario
                                    if (tipoRespuestaNuevaPregunta ==
                                            "opciones" ||
                                        tipoRespuestaNuevaPregunta == "rango")
                                      AnimatedOpacity(
                                        opacity: 1.0,
                                        duration: const Duration(
                                          milliseconds: 500,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 12),
                                            Text(
                                              'Opciones:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: colorNaranja.withOpacity(
                                                  0.8,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),

                                            // Lista de opciones actuales
                                            if (opcionesNuevaPregunta
                                                .isNotEmpty)
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: colorAmbarMedio,
                                                  ),
                                                ),
                                                child: Column(
                                                  children:
                                                      opcionesNuevaPregunta.asMap().entries.map((
                                                        entry,
                                                      ) {
                                                        int idx = entry.key;
                                                        Opcion opcion =
                                                            entry.value;
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 4,
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  opcion.valor,
                                                                ),
                                                              ),
                                                              IconButton(
                                                                icon: const Icon(
                                                                  Icons.delete,
                                                                  size: 18,
                                                                ),
                                                                color:
                                                                    Colors
                                                                        .red
                                                                        .shade300,
                                                                onPressed:
                                                                    () =>
                                                                        _eliminarOpcion(
                                                                          idx,
                                                                        ),
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
                                                    controller:
                                                        _nuevaOpcionController,
                                                    decoration: InputDecoration(
                                                      hintText: 'Nueva opción',
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
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                IconButton(
                                                  onPressed: _agregarOpcion,
                                                  icon: const Icon(
                                                    Icons.add_circle,
                                                  ),
                                                  color: colorAmarillo,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                    const SizedBox(height: 14),

                                    // Botón agregar pregunta
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: _agregarPregunta,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: colorAmarillo,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
                              crossFadeState:
                                  _isCardExpanded
                                      ? CrossFadeState.showSecond
                                      : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 300),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Lista de preguntas
                    Expanded(
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: colorAmbarMedio, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ReorderableListView.builder(
                            itemCount: preguntas.length,
                            onReorder: _reordenarPreguntas,
                            itemBuilder: (context, index) {
                              final pregunta = preguntas[index];

                              // Si está en modo edición de opciones
                              if (editandoPreguntaId == pregunta.id &&
                                  _isEditingOptions) {
                                return Card(
                                  key: Key('editar-opciones-${pregunta.id}'),
                                  color: Colors.white,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Editar opciones para: ${pregunta.texto}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: colorNaranja,
                                          ),
                                        ),
                                        const SizedBox(height: 12),

                                        // Lista de opciones actuales para editar
                                        if (pregunta.opciones != null &&
                                            pregunta.opciones!.isNotEmpty)
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: colorAmbarMedio,
                                              ),
                                            ),
                                            child: Column(
                                              children:
                                                  pregunta.opciones!.asMap().entries.map((
                                                    entry,
                                                  ) {
                                                    int idx = entry.key;
                                                    Opcion opcion = entry.value;

                                                    // Si está editando esta opción específica
                                                    if (editandoOpcionIndex ==
                                                        idx.toString()) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 4,
                                                            ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: TextField(
                                                                controller:
                                                                    _editarOpcionController,
                                                                decoration: InputDecoration(
                                                                  border: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                  ),
                                                                  contentPadding:
                                                                      const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            12,
                                                                        vertical:
                                                                            8,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            IconButton(
                                                              icon: const Icon(
                                                                Icons.check,
                                                                size: 18,
                                                              ),
                                                              color:
                                                                  Colors.green,
                                                              onPressed:
                                                                  _guardarEdicionOpcion,
                                                            ),
                                                            IconButton(
                                                              icon: const Icon(
                                                                Icons.close,
                                                                size: 18,
                                                              ),
                                                              color:
                                                                  Colors.grey,
                                                              onPressed:
                                                                  _cancelarEdicionOpcion,
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }

                                                    // Modo normal (no editando esta opción)
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 4,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              opcion.valor,
                                                            ),
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(
                                                              Icons.edit,
                                                              size: 18,
                                                            ),
                                                            color: colorNaranja,
                                                            onPressed:
                                                                () =>
                                                                    _iniciarEdicionOpcion(
                                                                      pregunta
                                                                          .id,
                                                                      idx,
                                                                      opcion
                                                                          .valor,
                                                                    ),
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(
                                                              Icons.delete,
                                                              size: 18,
                                                            ),
                                                            color:
                                                                Colors
                                                                    .red
                                                                    .shade300,
                                                            onPressed:
                                                                () =>
                                                                    _eliminarOpcionDePregunta(
                                                                      pregunta
                                                                          .id,
                                                                      idx,
                                                                    ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                            ),
                                          ),

                                        const SizedBox(height: 12),

                                        // Agregar nueva opción a la pregunta existente
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller:
                                                    _nuevaOpcionController,
                                                decoration: InputDecoration(
                                                  hintText: 'Nueva opción',
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
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              onPressed:
                                                  () => _agregarOpcionAPregunta(
                                                    pregunta.id,
                                                    _nuevaOpcionController.text,
                                                  ),
                                              icon: const Icon(
                                                Icons.add_circle,
                                              ),
                                              color: colorAmarillo,
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 12),

                                        // Botones de acción
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton.icon(
                                              onPressed: _cancelarEdicion,
                                              icon: const Icon(
                                                Icons.arrow_back,
                                                size: 18,
                                              ),
                                              label: const Text('Volver'),
                                              style: TextButton.styleFrom(
                                                foregroundColor: colorNaranja,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              // Si está en modo edición de pregunta
                              if (editandoPreguntaId == pregunta.id) {
                                return Card(
                                  key: Key('editar-${pregunta.id}'),
                                  color: Colors.white,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          controller: _editarPreguntaController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: colorAmarillo,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          maxLines: 3,
                                          minLines: 1,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton.icon(
                                              onPressed: _guardarEdicion,
                                              icon: const Icon(
                                                Icons.save,
                                                size: 18,
                                              ),
                                              label: const Text('Guardar'),
                                              style: TextButton.styleFrom(
                                                foregroundColor: colorNaranja,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            TextButton.icon(
                                              onPressed: _cancelarEdicion,
                                              icon: const Icon(
                                                Icons.close,
                                                size: 18,
                                              ),
                                              label: const Text('Cancelar'),
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              // Modo normal (no edición)
                              return Card(
                                key: Key(pregunta.id),
                                color:
                                    pregunta.seleccionada
                                        ? colorAmbarClaro
                                        : Colors.white,
                                margin: const EdgeInsets.only(bottom: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          // Icono de arrastrar
                                          const Icon(
                                            Icons.drag_handle,
                                            color: Colors.grey,
                                          ),

                                          // Checkbox
                                          Checkbox(
                                            value: pregunta.seleccionada,
                                            onChanged:
                                                (_) => _toggleSeleccion(
                                                  pregunta.id,
                                                ),
                                            activeColor: colorAmarillo,
                                          ),

                                          // Texto de la pregunta
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  pregunta.texto,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        pregunta.seleccionada
                                                            ? Colors.black87
                                                            : Colors.black54,
                                                  ),
                                                ),
                                                if (pregunta
                                                        .respuestaSeleccionada !=
                                                    null)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 4,
                                                        ),
                                                    child: Text(
                                                      'Respuesta: ${pregunta.respuestaSeleccionada}',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: colorNaranja,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),

                                          // Botones de acción
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 20,
                                            ),
                                            color: colorNaranja,
                                            onPressed:
                                                () => _iniciarEdicion(
                                                  pregunta.id,
                                                  pregunta.texto,
                                                ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              size: 20,
                                            ),
                                            color: Colors.red.shade300,
                                            onPressed:
                                                () => _eliminarPregunta(
                                                  pregunta.id,
                                                ),
                                          ),
                                        ],
                                      ),

                                      // Mostrar opciones y botón para editarlas
                                      if (pregunta.opciones != null &&
                                          pregunta.opciones!.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 40,
                                            top: 8,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Opciones: ',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      pregunta.opciones!
                                                          .map((o) => o.valor)
                                                          .join(', '),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Colors
                                                                .grey
                                                                .shade700,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  TextButton.icon(
                                                    onPressed:
                                                        () =>
                                                            _iniciarEdicionOpciones(
                                                              pregunta.id,
                                                            ),
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      size: 14,
                                                    ),
                                                    label: const Text(
                                                      'Editar opciones',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          colorNaranja,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Resumen con animación
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeInOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
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
                              'Total de preguntas: ${preguntas.length}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colorNaranja.withOpacity(0.8),
                              ),
                            ),
                            Text(
                              'Seleccionadas: ${preguntas.where((p) => p.seleccionada).length}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colorNaranja.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Botón guardar con animación
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Animar el botón al presionar
                            _animationController.reset();
                            _animationController.forward();

                            // Aquí puedes implementar la lógica para guardar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    RotationTransition(
                                      turns: _rotateAnimation,
                                      child: const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Monitoreo guardado correctamente',
                                    ),
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorNaranja,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Guardar Monitoreo',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Pantalla separada para mostrar las preguntas (solo visualización)
class PreguntasScreen extends StatefulWidget {
  final List<Pregunta> preguntas;
  final Color colorAmarillo;
  final Color colorNaranja;
  final Color colorAmbarClaro;

  const PreguntasScreen({
    Key? key,
    required this.preguntas,
    required this.colorAmarillo,
    required this.colorNaranja,
    required this.colorAmbarClaro,
  }) : super(key: key);

  @override
  _PreguntasScreenState createState() => _PreguntasScreenState();
}

class _PreguntasScreenState extends State<PreguntasScreen>
    with SingleTickerProviderStateMixin {
  late List<Pregunta> preguntasLocales;

  // Controlador de animación
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Crear una copia local de las preguntas para trabajar
    preguntasLocales = List.from(widget.preguntas);

    // Inicializar animación
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.colorAmbarClaro,
      appBar: AppBar(
        title: const Text('Preguntas de Monitoreo'),
        backgroundColor: widget.colorNaranja,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: preguntasLocales.length,
                  itemBuilder: (context, index) {
                    final pregunta = preguntasLocales[index];

                    // Calcular el retraso para la animación en cascada
                    final delay = index * 0.2;

                    return AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        // Calcular el valor de la animación con retraso
                        final animationValue =
                            _animationController.value - delay;
                        final value = animationValue.clamp(0.0, 1.0);

                        return Transform.translate(
                          offset: Offset(0, 50 * (1 - value)),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Número y texto de la pregunta
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: widget.colorNaranja,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      pregunta.texto,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Mostrar tipo de respuesta
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: widget.colorAmbarClaro,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: widget.colorAmarillo,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _getIconForType(pregunta.tipoRespuesta),
                                      size: 16,
                                      color: widget.colorNaranja,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _getTypeLabel(pregunta.tipoRespuesta),
                                      style: TextStyle(
                                        color: widget.colorNaranja,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Mostrar opciones disponibles si las hay
                              if (pregunta.opciones != null &&
                                  pregunta.opciones!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Opciones disponibles:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children:
                                            pregunta.opciones!.map((opcion) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: Colors.grey.shade300,
                                                  ),
                                                ),
                                                child: Text(opcion.valor),
                                              );
                                            }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Botón iniciar monitoreo con animación
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Aquí puedes implementar la lógica para iniciar el monitoreo
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Iniciando monitoreo...'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.colorNaranja,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Iniciar Monitoreo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Obtener ícono según el tipo de respuesta
  IconData _getIconForType(String? type) {
    switch (type) {
      case "texto":
        return Icons.text_fields;
      case "opciones":
        return Icons.list;
      case "numero":
        return Icons.numbers;
      case "rango":
        return Icons.linear_scale;
      default:
        return Icons.help_outline;
    }
  }

  // Obtener etiqueta según el tipo de respuesta
  String _getTypeLabel(String? type) {
    switch (type) {
      case "texto":
        return "Respuesta de texto";
      case "opciones":
        return "Selección de opciones";
      case "numero":
        return "Valor numérico";
      case "rango":
        return "Selección de rango";
      default:
        return "Tipo desconocido";
    }
  }
}
