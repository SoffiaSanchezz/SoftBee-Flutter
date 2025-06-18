// import 'package:flutter/material.dart';
// import 'dart:math' as math;

// // Clase para las opciones de respuesta
// class Opcion {
//   String valor;
//   String? descripcion;

//   Opcion({required this.valor, this.descripcion});
// }

// // Clase para preguntas con opciones
// class Pregunta {
//   String id;
//   String texto;
//   bool seleccionada;
//   List<Opcion>? opciones;
//   String? tipoRespuesta; // "texto", "opciones", "numero", "rango"
//   String? respuestaSeleccionada;

//   Pregunta({
//     required this.id,
//     required this.texto,
//     required this.seleccionada,
//     this.opciones,
//     this.tipoRespuesta = "texto",
//     this.respuestaSeleccionada,
//   });
// }

// // Pantalla principal de monitoreo optimizada
// class MonitoreoApiarioScreen extends StatefulWidget {
//   const MonitoreoApiarioScreen({Key? key}) : super(key: key);

//   @override
//   _MonitoreoApiarioScreenState createState() => _MonitoreoApiarioScreenState();
// }

// class _MonitoreoApiarioScreenState extends State<MonitoreoApiarioScreen>
//     with SingleTickerProviderStateMixin {
//   // Controladores
//   final TextEditingController _colmenaController = TextEditingController();
//   final TextEditingController _nuevaPreguntaController =
//       TextEditingController();
//   final TextEditingController _editarPreguntaController =
//       TextEditingController();
//   final TextEditingController _nuevaOpcionController = TextEditingController();
//   final TextEditingController _editarOpcionController = TextEditingController();

//   // Controladores de animación
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;

//   // Estado
//   String? editandoPreguntaId;
//   String? editandoOpcionIndex;
//   String tipoRespuestaNuevaPregunta = "texto";
//   List<Opcion> opcionesNuevaPregunta = [];
//   bool _isCardExpanded = false;
//   bool _isEditingOptions = false;

  // // Lista de preguntas estándar (banco de preguntas)
  // List<Pregunta> preguntasEstandar = [
  //   Pregunta(
  //     id: "1",
  //     texto: "Número de colmena",
  //     seleccionada: false,
  //     tipoRespuesta: "texto",
  //   ),
  //   Pregunta(
  //     id: "2",
  //     texto: "Actividad en las piqueras",
  //     seleccionada: false,
  //     tipoRespuesta: "opciones",
  //     opciones: [
  //       Opcion(valor: "Baja"),
  //       Opcion(valor: "Media"),
  //       Opcion(valor: "Alta"),
  //     ],
  //   ),
  //   Pregunta(
  //     id: "3",
  //     texto: "Población de abejas",
  //     seleccionada: false,
  //     tipoRespuesta: "opciones",
  //     opciones: [
  //       Opcion(valor: "Baja"),
  //       Opcion(valor: "Media"),
  //       Opcion(valor: "Alta"),
  //     ],
  //   ),
  //   Pregunta(
  //     id: "4",
  //     texto: "Cuadros de alimento",
  //     seleccionada: false,
  //     tipoRespuesta: "rango",
  //     opciones: [
  //       Opcion(valor: "1"),
  //       Opcion(valor: "2"),
  //       Opcion(valor: "3"),
  //       Opcion(valor: "4"),
  //       Opcion(valor: "5"),
  //     ],
  //   ),
  //   Pregunta(
  //     id: "5",
  //     texto: "Estado de la reina",
  //     seleccionada: false,
  //     tipoRespuesta: "opciones",
  //     opciones: [
  //       Opcion(valor: "Presente"),
  //       Opcion(valor: "Ausente"),
  //       Opcion(valor: "Celdas reales"),
  //     ],
  //   ),
  //   Pregunta(
  //     id: "6",
  //     texto: "Presencia de plagas",
  //     seleccionada: false,
  //     tipoRespuesta: "opciones",
  //     opciones: [
  //       Opcion(valor: "Ninguna"),
  //       Opcion(valor: "Varroa"),
  //       Opcion(valor: "Polilla"),
  //       Opcion(valor: "Hormigas"),
  //     ],
  //   ),
  // ];

//   // Lista de preguntas seleccionadas para el monitoreo
//   List<Pregunta> preguntasSeleccionadas = [];

//   // Colores de la paleta
//   final Color colorAmarillo = const Color(0xFFFBC209);
//   final Color colorNaranja = const Color(0xFFFF9800);
//   final Color colorAmbarClaro = const Color(0xFFFFF8E1);
//   final Color colorAmbarMedio = const Color(0xFFFFE082);

//   @override
//   void initState() {
//     super.initState();

//     // Inicializar controlador de animación
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );

//     // Definir animaciones
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0.0, 0.3),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     );

//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     );

//     // Iniciar animación
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _colmenaController.dispose();
//     _nuevaPreguntaController.dispose();
//     _editarPreguntaController.dispose();
//     _nuevaOpcionController.dispose();
//     _editarOpcionController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   // Agregar pregunta al banco estándar
//   void _agregarPreguntaEstandar() {
//     if (_nuevaPreguntaController.text.trim().isEmpty) return;

//     setState(() {
//       final nuevaId = (preguntasEstandar.length + 1).toString();
//       preguntasEstandar.add(
//         Pregunta(
//           id: nuevaId,
//           texto: _nuevaPreguntaController.text,
//           seleccionada: false,
//           tipoRespuesta: tipoRespuestaNuevaPregunta,
//           opciones:
//               tipoRespuestaNuevaPregunta != "texto"
//                   ? List<Opcion>.from(opcionesNuevaPregunta)
//                   : null,
//         ),
//       );
//       _nuevaPreguntaController.clear();
//       opcionesNuevaPregunta = [];
//       tipoRespuestaNuevaPregunta = "texto";
//       _isCardExpanded = false;
//     });
//   }

//   // Seleccionar/deseleccionar pregunta del banco estándar
//   void _toggleSeleccionPreguntaEstandar(String id) {
//     setState(() {
//       final index = preguntasEstandar.indexWhere((p) => p.id == id);
//       if (index != -1) {
//         preguntasEstandar[index].seleccionada =
//             !preguntasEstandar[index].seleccionada;

//         if (preguntasEstandar[index].seleccionada) {
//           // Agregar a preguntas seleccionadas
//           preguntasSeleccionadas.add(
//             Pregunta(
//               id: preguntasEstandar[index].id,
//               texto: preguntasEstandar[index].texto,
//               seleccionada: true,
//               tipoRespuesta: preguntasEstandar[index].tipoRespuesta,
//               opciones:
//                   preguntasEstandar[index].opciones
//                       ?.map(
//                         (o) =>
//                             Opcion(valor: o.valor, descripcion: o.descripcion),
//                       )
//                       .toList(),
//             ),
//           );
//         } else {
//           // Remover de preguntas seleccionadas
//           preguntasSeleccionadas.removeWhere((p) => p.id == id);
//         }
//       }
//     });
//   }

  // // Eliminar pregunta del banco estándar
  // void _eliminarPreguntaEstandar(String id) {
  //   setState(() {
  //     preguntasEstandar.removeWhere((pregunta) => pregunta.id == id);
  //     preguntasSeleccionadas.removeWhere((pregunta) => pregunta.id == id);
  //   });
  // }

  // // Reordenar preguntas seleccionadas
  // void _reordenarPreguntasSeleccionadas(int oldIndex, int newIndex) {
  //   setState(() {
  //     if (newIndex > oldIndex) {
  //       newIndex -= 1;
  //     }
  //     final item = preguntasSeleccionadas.removeAt(oldIndex);
  //     preguntasSeleccionadas.insert(newIndex, item);
  //   });
  // }

  // // Remover pregunta de la selección
  // void _removerPreguntaSeleccionada(String id) {
  //   setState(() {
  //     preguntasSeleccionadas.removeWhere((p) => p.id == id);
  //     // Actualizar el estado en el banco estándar
  //     final index = preguntasEstandar.indexWhere((p) => p.id == id);
  //     if (index != -1) {
  //       preguntasEstandar[index].seleccionada = false;
  //     }
  //   });
  // }

  // // Métodos para manejar opciones
  // void _agregarOpcion() {
  //   if (_nuevaOpcionController.text.trim().isEmpty) return;
  //   setState(() {
  //     opcionesNuevaPregunta.add(Opcion(valor: _nuevaOpcionController.text));
  //     _nuevaOpcionController.clear();
  //   });
  // }

  // void _eliminarOpcion(int index) {
  //   setState(() {
  //     opcionesNuevaPregunta.removeAt(index);
  //   });
  // }

  // void _editarOpcion(int index, String nuevoValor) {
  //   setState(() {
  //     opcionesNuevaPregunta[index].valor = nuevoValor;
  //   });
  // }

  // // Métodos para editar preguntas existentes
  // void _iniciarEdicion(String id, String texto) {
  //   setState(() {
  //     editandoPreguntaId = id;
  //     _editarPreguntaController.text = texto;
  //     _isEditingOptions = false;
  //   });
  // }

  // void _iniciarEdicionOpciones(String id) {
  //   setState(() {
  //     editandoPreguntaId = id;
  //     _isEditingOptions = true;
  //   });
  // }

  // void _guardarEdicion() {
  //   if (editandoPreguntaId == null) return;

  //   setState(() {
  //     final index = preguntasEstandar.indexWhere(
  //       (p) => p.id == editandoPreguntaId,
  //     );
  //     if (index != -1) {
  //       preguntasEstandar[index].texto = _editarPreguntaController.text;

  //       // Actualizar también en preguntas seleccionadas si existe
  //       final selectedIndex = preguntasSeleccionadas.indexWhere(
  //         (p) => p.id == editandoPreguntaId,
  //       );
  //       if (selectedIndex != -1) {
  //         preguntasSeleccionadas[selectedIndex].texto =
  //             _editarPreguntaController.text;
  //       }
  //     }
  //     editandoPreguntaId = null;
  //     _isEditingOptions = false;
  //   });
  // }

  // void _cancelarEdicion() {
  //   setState(() {
  //     editandoPreguntaId = null;
  //     _isEditingOptions = false;
  //   });
  // }

  // // Métodos para editar opciones de preguntas existentes
  // void _agregarOpcionAPregunta(String preguntaId, String valorOpcion) {
  //   if (valorOpcion.trim().isEmpty) return;

  //   setState(() {
  //     final index = preguntasEstandar.indexWhere((p) => p.id == preguntaId);
  //     if (index != -1) {
  //       if (preguntasEstandar[index].opciones == null) {
  //         preguntasEstandar[index].opciones = [];
  //       }
  //       preguntasEstandar[index].opciones!.add(Opcion(valor: valorOpcion));

  //       // Actualizar también en preguntas seleccionadas si existe
  //       final selectedIndex = preguntasSeleccionadas.indexWhere(
  //         (p) => p.id == preguntaId,
  //       );
  //       if (selectedIndex != -1) {
  //         if (preguntasSeleccionadas[selectedIndex].opciones == null) {
  //           preguntasSeleccionadas[selectedIndex].opciones = [];
  //         }
  //         preguntasSeleccionadas[selectedIndex].opciones!.add(
  //           Opcion(valor: valorOpcion),
  //         );
  //       }
  //     }
  //   });
  //   _nuevaOpcionController.clear();
  // }

  // void _eliminarOpcionDePregunta(String preguntaId, int opcionIndex) {
  //   setState(() {
  //     final index = preguntasEstandar.indexWhere((p) => p.id == preguntaId);
  //     if (index != -1 && preguntasEstandar[index].opciones != null) {
  //       preguntasEstandar[index].opciones!.removeAt(opcionIndex);

  //       // Actualizar también en preguntas seleccionadas si existe
  //       final selectedIndex = preguntasSeleccionadas.indexWhere(
  //         (p) => p.id == preguntaId,
  //       );
  //       if (selectedIndex != -1 &&
  //           preguntasSeleccionadas[selectedIndex].opciones != null) {
  //         preguntasSeleccionadas[selectedIndex].opciones!.removeAt(opcionIndex);
  //       }
  //     }
  //   });
  // }

  // void _editarOpcionDePregunta(
  //   String preguntaId,
  //   int opcionIndex,
  //   String nuevoValor,
  // ) {
  //   setState(() {
  //     final index = preguntasEstandar.indexWhere((p) => p.id == preguntaId);
  //     if (index != -1 && preguntasEstandar[index].opciones != null) {
  //       preguntasEstandar[index].opciones![opcionIndex].valor = nuevoValor;

  //       // Actualizar también en preguntas seleccionadas si existe
  //       final selectedIndex = preguntasSeleccionadas.indexWhere(
  //         (p) => p.id == preguntaId,
  //       );
  //       if (selectedIndex != -1 &&
  //           preguntasSeleccionadas[selectedIndex].opciones != null) {
  //         preguntasSeleccionadas[selectedIndex].opciones![opcionIndex].valor =
  //             nuevoValor;
  //       }
  //     }
  //   });
  // }

  // // Alternar expansión de la tarjeta
  // void _toggleCardExpansion() {
  //   setState(() {
  //     _isCardExpanded = !_isCardExpanded;
  //   });
  // }

//   // Navegar a la pantalla de visualización de preguntas
//   void _navegarAPantallaVisualizacion() {
//     if (preguntasSeleccionadas.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Debe seleccionar al menos una pregunta'),
//           backgroundColor: Colors.orange,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       );
//       return;
//     }

//     Navigator.of(context).push(
//       PageRouteBuilder(
//         pageBuilder:
//             (context, animation, secondaryAnimation) =>
//                 VisualizacionPreguntasScreen(
//                   preguntas: preguntasSeleccionadas,
//                   colmena:
//                       _colmenaController.text.trim().isEmpty
//                           ? "Sin nombre"
//                           : _colmenaController.text,
//                   colorAmarillo: colorAmarillo,
//                   colorNaranja: colorNaranja,
//                   colorAmbarClaro: colorAmbarClaro,
//                   colorAmbarMedio: colorAmbarMedio,
//                 ),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           const begin = Offset(1.0, 0.0);
//           const end = Offset.zero;
//           const curve = Curves.easeInOutQuart;

//           var tween = Tween(
//             begin: begin,
//             end: end,
//           ).chain(CurveTween(curve: curve));
//           var offsetAnimation = animation.drive(tween);

//           return SlideTransition(position: offsetAnimation, child: child);
//         },
//         transitionDuration: const Duration(milliseconds: 500),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: colorAmbarClaro,
//       appBar: AppBar(
//         title: const Text('Monitoreo de Apiario'),
//         backgroundColor: colorNaranja,
//         foregroundColor: Colors.white,
//       ),
//       body: SafeArea(
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: SlideTransition(
//             position: _slideAnimation,
//             child: ScaleTransition(
//               scale: _scaleAnimation,
//               child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   // Determinar si es desktop
//                   bool isDesktop = constraints.maxWidth > 1024;
//                   double maxWidth = isDesktop ? 1200 : double.infinity;

//                   return Center(
//                     child: Container(
//                       constraints: BoxConstraints(maxWidth: maxWidth),
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Información de la colmena
//                           _buildColmenaInfo(),

//                           const SizedBox(height: 20),

//                           // Contenido principal - dos columnas en desktop
//                           Expanded(
//                             child:
//                                 isDesktop
//                                     ? Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         // Primera parte: Banco de preguntas estándar
//                                         Expanded(
//                                           flex: 1,
//                                           child: _buildBancoPreguntasEstandar(),
//                                         ),

//                                         const SizedBox(width: 20),

//                                         // Segunda parte: Visualización y acomodo
//                                         Expanded(
//                                           flex: 1,
//                                           child: _buildVisualizacionAcomodo(),
//                                         ),
//                                       ],
//                                     )
//                                     : Column(
//                                       children: [
//                                         // En móvil, mostrar en pestañas
//                                         Expanded(
//                                           child: DefaultTabController(
//                                             length: 2,
//                                             child: Column(
//                                               children: [
//                                                 TabBar(
//                                                   labelColor: colorNaranja,
//                                                   unselectedLabelColor:
//                                                       Colors.grey,
//                                                   indicatorColor: colorAmarillo,
//                                                   tabs: const [
//                                                     Tab(
//                                                       text:
//                                                           "Banco de Preguntas",
//                                                     ),
//                                                     Tab(
//                                                       text:
//                                                           "Preguntas Seleccionadas",
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Expanded(
//                                                   child: TabBarView(
//                                                     children: [
//                                                       _buildBancoPreguntasEstandar(),
//                                                       _buildVisualizacionAcomodo(),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                           ),

//                           const SizedBox(height: 16),

//                           // Resumen y botones
//                           _buildResumenYBotones(),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget para información de la colmena
//   Widget _buildColmenaInfo() {
//     return TweenAnimationBuilder<double>(
//       tween: Tween<double>(begin: 0.0, end: 1.0),
//       duration: const Duration(milliseconds: 800),
//       curve: Curves.easeOutBack,
//       builder: (context, value, child) {
//         return Transform.scale(scale: value, child: child);
//       },
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//           side: BorderSide(color: colorAmarillo, width: 1),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   TweenAnimationBuilder<double>(
//                     tween: Tween<double>(begin: 0, end: 2 * math.pi),
//                     duration: const Duration(seconds: 2),
//                     curve: Curves.elasticOut,
//                     builder: (context, value, child) {
//                       return Transform.rotate(
//                         angle: value,
//                         child: Icon(Icons.hive, color: colorNaranja, size: 28),
//                       );
//                     },
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Nombre de el apiario',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: colorNaranja.withOpacity(0.8),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: _colmenaController,
//                 decoration: InputDecoration(
//                   hintText: 'Ingrese el número o nombre de la colmena',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide(color: colorAmarillo),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide(color: colorNaranja, width: 2),
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget para el banco de preguntas estándar
//   Widget _buildBancoPreguntasEstandar() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Título de sección
//         Row(
//           children: [
//             Icon(Icons.library_books, color: colorNaranja, size: 24),
//             const SizedBox(width: 8),
//             Text(
//               'Banco de Preguntas Estándar',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: colorNaranja,
//               ),
//             ),
//           ],
//         ),

//         const SizedBox(height: 12),

//         // Agregar nueva pregunta
//         _buildAgregarPreguntaCard(),

//         const SizedBox(height: 10),

//         // Lista de preguntas estándar
//         Expanded(
//           child: Card(
//             elevation: 2,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//               side: BorderSide(color: colorAmbarMedio, width: 1),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ListView.builder(
//                 itemCount: preguntasEstandar.length,
//                 itemBuilder: (context, index) {
//                   final pregunta = preguntasEstandar[index];
//                   return _buildPreguntaEstandarCard(pregunta, index);
//                 },
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // Widget para visualización y acomodo
//   Widget _buildVisualizacionAcomodo() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Título de sección
//         Row(
//           children: [
//             Icon(Icons.view_list, color: colorNaranja, size: 24),
//             const SizedBox(width: 8),
//             Text(
//               'Preguntas Seleccionadas',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: colorNaranja,
//               ),
//             ),
//             const Spacer(),
//             Text(
//               '${preguntasSeleccionadas.length} seleccionadas',
//               style: TextStyle(
//                 color: colorNaranja.withOpacity(0.7),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),

//         const SizedBox(height: 12),

//         // Lista de preguntas seleccionadas
//         Expanded(
//           child: Card(
//             elevation: 2,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//               side: BorderSide(color: colorAmbarMedio, width: 1),
//             ),
//             child:
//                 preguntasSeleccionadas.isEmpty
//                     ? _buildEmptySelectionState()
//                     : Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: ReorderableListView.builder(
//                         itemCount: preguntasSeleccionadas.length,
//                         onReorder: _reordenarPreguntasSeleccionadas,
//                         itemBuilder: (context, index) {
//                           final pregunta = preguntasSeleccionadas[index];
//                           return _buildPreguntaSeleccionadaCard(
//                             pregunta,
//                             index,
//                           );
//                         },
//                       ),
//                     ),
//           ),
//         ),
//       ],
//     );
//   }

//   // Widget para estado vacío
//   Widget _buildEmptySelectionState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.playlist_add, size: 64, color: Colors.grey.shade400),
//           const SizedBox(height: 16),
//           Text(
//             'No hay preguntas seleccionadas',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey.shade600,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Selecciona preguntas del banco estándar\npara agregarlas a tu monitoreo',
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget para tarjeta de pregunta estándar
//   Widget _buildPreguntaEstandarCard(Pregunta pregunta, int index) {
//     // Si está en modo edición de opciones
//     if (editandoPreguntaId == pregunta.id && _isEditingOptions) {
//       return Card(
//         key: Key('editar-opciones-${pregunta.id}'),
//         color: Colors.white,
//         margin: const EdgeInsets.only(bottom: 8),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Editar opciones para: ${pregunta.texto}',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: colorNaranja,
//                 ),
//               ),
//               const SizedBox(height: 12),

//               // Lista de opciones actuales para editar
//               if (pregunta.opciones != null && pregunta.opciones!.isNotEmpty)
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: colorAmbarClaro,
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: colorAmbarMedio),
//                   ),
//                   child: Column(
//                     children:
//                         pregunta.opciones!.asMap().entries.map((entry) {
//                           int idx = entry.key;
//                           Opcion opcion = entry.value;

//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 4),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: TextFormField(
//                                     initialValue: opcion.valor,
//                                     decoration: InputDecoration(
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                             horizontal: 12,
//                                             vertical: 8,
//                                           ),
//                                     ),
//                                     onChanged: (value) {
//                                       _editarOpcionDePregunta(
//                                         pregunta.id,
//                                         idx,
//                                         value,
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(Icons.delete, size: 18),
//                                   color: Colors.red.shade300,
//                                   onPressed:
//                                       () => _eliminarOpcionDePregunta(
//                                         pregunta.id,
//                                         idx,
//                                       ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }).toList(),
//                   ),
//                 ),

//               const SizedBox(height: 12),

//               // Agregar nueva opción a la pregunta existente
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _nuevaOpcionController,
//                       decoration: InputDecoration(
//                         hintText: 'Nueva opción',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 8,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     onPressed:
//                         () => _agregarOpcionAPregunta(
//                           pregunta.id,
//                           _nuevaOpcionController.text,
//                         ),
//                     icon: const Icon(Icons.add_circle),
//                     color: colorAmarillo,
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 12),

//               // Botones de acción
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton.icon(
//                     onPressed: _cancelarEdicion,
//                     icon: const Icon(Icons.arrow_back, size: 18),
//                     label: const Text('Volver'),
//                     style: TextButton.styleFrom(foregroundColor: colorNaranja),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     // Si está en modo edición de pregunta
//     if (editandoPreguntaId == pregunta.id && !_isEditingOptions) {
//       return Card(
//         key: Key('editar-${pregunta.id}'),
//         color: Colors.white,
//         margin: const EdgeInsets.only(bottom: 8),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextField(
//                 controller: _editarPreguntaController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide(color: colorAmarillo, width: 2),
//                   ),
//                 ),
//                 maxLines: 3,
//                 minLines: 1,
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton.icon(
//                     onPressed: _guardarEdicion,
//                     icon: const Icon(Icons.save, size: 18),
//                     label: const Text('Guardar'),
//                     style: TextButton.styleFrom(foregroundColor: colorNaranja),
//                   ),
//                   const SizedBox(width: 8),
//                   TextButton.icon(
//                     onPressed: _cancelarEdicion,
//                     icon: const Icon(Icons.close, size: 18),
//                     label: const Text('Cancelar'),
//                     style: TextButton.styleFrom(foregroundColor: Colors.grey),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     // Modo normal
//     return Card(
//       key: Key(pregunta.id),
//       color: pregunta.seleccionada ? colorAmbarClaro : Colors.white,
//       margin: const EdgeInsets.only(bottom: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 // Checkbox para seleccionar
//                 Checkbox(
//                   value: pregunta.seleccionada,
//                   onChanged:
//                       (_) => _toggleSeleccionPreguntaEstandar(pregunta.id),
//                   activeColor: colorAmarillo,
//                 ),

//                 // Texto de la pregunta
//                 Expanded(
//                   child: Text(
//                     pregunta.texto,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color:
//                           pregunta.seleccionada
//                               ? Colors.black87
//                               : Colors.black54,
//                     ),
//                   ),
//                 ),

//                 // Botones de acción
//                 IconButton(
//                   icon: const Icon(Icons.edit, size: 20),
//                   color: colorNaranja,
//                   onPressed: () => _iniciarEdicion(pregunta.id, pregunta.texto),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete, size: 20),
//                   color: Colors.red.shade300,
//                   onPressed: () => _eliminarPreguntaEstandar(pregunta.id),
//                 ),
//               ],
//             ),

//             // Mostrar tipo y opciones
//             if (pregunta.tipoRespuesta != "texto")
//               Padding(
//                 padding: const EdgeInsets.only(left: 40, top: 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: colorAmbarMedio,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             _getTypeLabel(pregunta.tipoRespuesta),
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: colorNaranja,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         const Spacer(),
//                         if (pregunta.tipoRespuesta == "opciones" ||
//                             pregunta.tipoRespuesta == "rango")
//                           TextButton.icon(
//                             onPressed:
//                                 () => _iniciarEdicionOpciones(pregunta.id),
//                             icon: const Icon(Icons.edit, size: 14),
//                             label: const Text(
//                               'Editar opciones',
//                               style: TextStyle(fontSize: 12),
//                             ),
//                             style: TextButton.styleFrom(
//                               foregroundColor: colorNaranja,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                     if (pregunta.opciones != null &&
//                         pregunta.opciones!.isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 4),
//                         child: Text(
//                           'Opciones: ${pregunta.opciones!.map((o) => o.valor).join(', ')}',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey.shade700,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget para tarjeta de pregunta seleccionada
//   Widget _buildPreguntaSeleccionadaCard(Pregunta pregunta, int index) {
//     return Card(
//       key: Key('selected-${pregunta.id}'),
//       color: colorAmbarClaro,
//       margin: const EdgeInsets.only(bottom: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 // Icono de arrastrar
//                 const Icon(Icons.drag_handle, color: Colors.grey),

//                 // Número de orden
//                 Container(
//                   width: 24,
//                   height: 24,
//                   decoration: BoxDecoration(
//                     color: colorNaranja,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: Text(
//                       '${index + 1}',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(width: 12),

//                 // Texto de la pregunta
//                 Expanded(
//                   child: Text(
//                     pregunta.texto,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),

//                 // Botón para remover
//                 IconButton(
//                   icon: const Icon(Icons.remove_circle, size: 20),
//                   color: Colors.red.shade300,
//                   onPressed: () => _removerPreguntaSeleccionada(pregunta.id),
//                 ),
//               ],
//             ),

//             // Mostrar opciones si las hay
//             if (pregunta.opciones != null && pregunta.opciones!.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(left: 40, top: 8),
//                 child: Wrap(
//                   spacing: 6,
//                   runSpacing: 4,
//                   children:
//                       pregunta.opciones!.map((opcion) {
//                         return Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.grey.shade300),
//                           ),
//                           child: Text(
//                             opcion.valor,
//                             style: const TextStyle(fontSize: 12),
//                           ),
//                         );
//                       }).toList(),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget para agregar pregunta con opciones completas
//   Widget _buildAgregarPreguntaCard() {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 500),
//       curve: Curves.easeInOut,
//       height: _isCardExpanded ? null : 60,
//       child: Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Column(
//           children: [
//             // Cabecera
//             InkWell(
//               onTap: _toggleCardExpansion,
//               child: Padding(
//                 padding: const EdgeInsets.all(14.0),
//                 child: Row(
//                   children: [
//                     Icon(Icons.add_circle, color: colorNaranja),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'Agregar Nueva Pregunta',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: colorNaranja,
//                         ),
//                       ),
//                     ),
//                     AnimatedRotation(
//                       turns: _isCardExpanded ? 0.5 : 0,
//                       duration: const Duration(milliseconds: 300),
//                       child: Icon(Icons.expand_more, color: colorNaranja),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Contenido expandible
//             if (_isCardExpanded)
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     TextField(
//                       controller: _nuevaPreguntaController,
//                       decoration: InputDecoration(
//                         hintText: 'Escriba una nueva pregunta',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(
//                             color: colorAmarillo,
//                             width: 2,
//                           ),
//                         ),
//                         filled: true,
//                         fillColor: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 12),

//                     // Selector de tipo
//                     Text(
//                       'Tipo de respuesta:',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: colorNaranja.withOpacity(0.8),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Wrap(
//                       spacing: 8,
//                       children:
//                           ["texto", "opciones", "numero", "rango"].map((tipo) {
//                             return ChoiceChip(
//                               label: Text(_getTypeLabel(tipo)),
//                               selected: tipoRespuestaNuevaPregunta == tipo,
//                               onSelected: (selected) {
//                                 if (selected) {
//                                   setState(() {
//                                     tipoRespuestaNuevaPregunta = tipo;
//                                     if (tipo == "texto") {
//                                       opcionesNuevaPregunta.clear();
//                                     }
//                                   });
//                                 }
//                               },
//                               selectedColor: colorAmarillo,
//                             );
//                           }).toList(),
//                     ),

//                     // Mostrar sección de opciones si es necesario
//                     if (tipoRespuestaNuevaPregunta == "opciones" ||
//                         tipoRespuestaNuevaPregunta == "rango")
//                       AnimatedOpacity(
//                         opacity: 1.0,
//                         duration: const Duration(milliseconds: 500),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 12),
//                             Text(
//                               'Opciones:',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: colorNaranja.withOpacity(0.8),
//                               ),
//                             ),
//                             const SizedBox(height: 8),

//                             // Lista de opciones actuales
//                             if (opcionesNuevaPregunta.isNotEmpty)
//                               Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: colorAmbarClaro,
//                                   borderRadius: BorderRadius.circular(8),
//                                   border: Border.all(color: colorAmbarMedio),
//                                 ),
//                                 child: Column(
//                                   children:
//                                       opcionesNuevaPregunta.asMap().entries.map((
//                                         entry,
//                                       ) {
//                                         int idx = entry.key;
//                                         Opcion opcion = entry.value;
//                                         return Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                             vertical: 4,
//                                           ),
//                                           child: Row(
//                                             children: [
//                                               Expanded(
//                                                 child: TextFormField(
//                                                   initialValue: opcion.valor,
//                                                   decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                             8,
//                                                           ),
//                                                     ),
//                                                     contentPadding:
//                                                         const EdgeInsets.symmetric(
//                                                           horizontal: 12,
//                                                           vertical: 8,
//                                                         ),
//                                                   ),
//                                                   onChanged: (value) {
//                                                     _editarOpcion(idx, value);
//                                                   },
//                                                 ),
//                                               ),
//                                               IconButton(
//                                                 icon: const Icon(
//                                                   Icons.delete,
//                                                   size: 18,
//                                                 ),
//                                                 color: Colors.red.shade300,
//                                                 onPressed:
//                                                     () => _eliminarOpcion(idx),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       }).toList(),
//                                 ),
//                               ),

//                             const SizedBox(height: 8),

//                             // Agregar nueva opción
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: TextField(
//                                     controller: _nuevaOpcionController,
//                                     decoration: InputDecoration(
//                                       hintText: 'Nueva opción',
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                             horizontal: 12,
//                                             vertical: 8,
//                                           ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 IconButton(
//                                   onPressed: _agregarOpcion,
//                                   icon: const Icon(Icons.add_circle),
//                                   color: colorAmarillo,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),

//                     const SizedBox(height: 12),

//                     // Botón agregar
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _agregarPreguntaEstandar,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: colorAmarillo,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 10),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: const Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.add, size: 18),
//                             SizedBox(width: 5),
//                             Text('Agregar Pregunta'),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget para resumen y botones
//   Widget _buildResumenYBotones() {
//     return Column(
//       children: [
//         // Resumen
//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: colorAmbarMedio),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 5,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Total en banco: ${preguntasEstandar.length}',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: colorNaranja.withOpacity(0.8),
//                 ),
//               ),
//               Text(
//                 'Seleccionadas: ${preguntasSeleccionadas.length}',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: colorNaranja.withOpacity(0.8),
//                 ),
//               ),
//             ],
//           ),
//         ),

//         const SizedBox(height: 16),

//         // Botones
//         Row(
//           children: [
//             // Botón ver preguntas
//             Expanded(
//               child: ElevatedButton.icon(
//                 onPressed: _navegarAPantallaVisualizacion,
//                 icon: const Icon(Icons.visibility, size: 18),
//                 label: const Text('Ver Preguntas'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: colorAmarillo,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(width: 12),

//             // Botón configurar monitoreo
//             Expanded(
//               child: ElevatedButton.icon(
//                 onPressed:
//                     preguntasSeleccionadas.isNotEmpty
//                         ? () {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Row(
//                                 children: [
//                                   const Icon(
//                                     Icons.check_circle,
//                                     color: Colors.white,
//                                   ),
//                                   const SizedBox(width: 10),
//                                   Text(
//                                     'Monitoreo configurado con ${preguntasSeleccionadas.length} preguntas',
//                                   ),
//                                 ],
//                               ),
//                               backgroundColor: Colors.green,
//                               behavior: SnackBarBehavior.floating,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                           );
//                         }
//                         : null,
//                 icon: const Icon(Icons.save, size: 18),
//                 label: const Text('Configurar'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: colorNaranja,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   // Método auxiliar para obtener etiqueta del tipo
//   String _getTypeLabel(String? type) {
//     switch (type) {
//       case "texto":
//         return "Texto";
//       case "opciones":
//         return "Opciones";
//       case "numero":
//         return "Número";
//       case "rango":
//         return "Rango";
//       default:
//         return "Desconocido";
//     }
//   }
// }

// // Nueva pantalla de visualización de preguntas
// class VisualizacionPreguntasScreen extends StatefulWidget {
//   final List<Pregunta> preguntas;
//   final String colmena;
//   final Color colorAmarillo;
//   final Color colorNaranja;
//   final Color colorAmbarClaro;
//   final Color colorAmbarMedio;

//   const VisualizacionPreguntasScreen({
//     Key? key,
//     required this.preguntas,
//     required this.colmena,
//     required this.colorAmarillo,
//     required this.colorNaranja,
//     required this.colorAmbarClaro,
//     required this.colorAmbarMedio,
//   }) : super(key: key);

//   @override
//   _VisualizacionPreguntasScreenState createState() =>
//       _VisualizacionPreguntasScreenState();
// }

// class _VisualizacionPreguntasScreenState
//     extends State<VisualizacionPreguntasScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;

//   @override
//   void initState() {
//     super.initState();

//     // Inicializar animación
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );

//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   // Obtener ícono según el tipo de respuesta
//   IconData _getIconForType(String? type) {
//     switch (type) {
//       case "texto":
//         return Icons.text_fields;
//       case "opciones":
//         return Icons.list;
//       case "numero":
//         return Icons.numbers;
//       case "rango":
//         return Icons.linear_scale;
//       default:
//         return Icons.help_outline;
//     }
//   }

//   // Obtener etiqueta según el tipo de respuesta
//   String _getTypeLabel(String? type) {
//     switch (type) {
//       case "texto":
//         return "Respuesta de texto";
//       case "opciones":
//         return "Selección de opciones";
//       case "numero":
//         return "Valor numérico";
//       case "rango":
//         return "Selección de rango";
//       default:
//         return "Tipo desconocido";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: widget.colorAmbarClaro,
//       appBar: AppBar(
//         title: const Text('Preguntas del Monitoreo'),
//         backgroundColor: widget.colorNaranja,
//         foregroundColor: Colors.white,
//       ),
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             bool isDesktop = constraints.maxWidth > 1024;
//             double maxWidth = isDesktop ? 800 : double.infinity;

//             return Center(
//               child: Container(
//                 constraints: BoxConstraints(maxWidth: maxWidth),
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     // Información de la colmena
//                     TweenAnimationBuilder<double>(
//                       tween: Tween<double>(begin: 0.0, end: 1.0),
//                       duration: const Duration(milliseconds: 800),
//                       curve: Curves.easeOutBack,
//                       builder: (context, value, child) {
//                         return Transform.scale(scale: value, child: child);
//                       },
//                       child: Card(
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           side: BorderSide(
//                             color: widget.colorAmarillo,
//                             width: 1,
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.hive,
//                                 color: widget.colorNaranja,
//                                 size: 32,
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Colmena: ${widget.colmena}',
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: widget.colorNaranja,
//                                       ),
//                                     ),
//                                     Text(
//                                       '${widget.preguntas.length} preguntas configuradas',
//                                       style: TextStyle(
//                                         color: Colors.grey.shade600,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     // Botón iniciar monitoreo
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton.icon(
//                         onPressed: () {
//                           // Aquí puedes navegar a la pantalla de monitoreo real
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Row(
//                                 children: [
//                                   const Icon(
//                                     Icons.play_arrow,
//                                     color: Colors.white,
//                                   ),
//                                   const SizedBox(width: 10),
//                                   Text(
//                                     'Iniciando monitoreo de ${widget.colmena}...',
//                                   ),
//                                 ],
//                               ),
//                               backgroundColor: Colors.green,
//                               behavior: SnackBarBehavior.floating,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                           );
//                         },
//                         icon: const Icon(Icons.play_arrow, size: 20),
//                         label: const Text(
//                           'Iniciar Monitoreo',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: widget.colorNaranja,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 4,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
