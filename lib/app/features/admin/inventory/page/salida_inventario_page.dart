import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
// import 'package:intl/intl.dart';
import 'package:soft_bee/app/features/admin/inventory/presentation/gestion_invetario.dart';
import 'package:soft_bee/app/features/admin/inventory/presentation/historial_inventario.dart';


// Modelo para las salidas de inventario
class SalidaInsumo {
  final int id;
  final int insumoId;
  final String nombreInsumo;
  final String cantidad;
  final String persona;
  final DateTime fecha;

  SalidaInsumo({
    required this.id,
    required this.insumoId,
    required this.nombreInsumo,
    required this.cantidad,
    required this.persona,
    required this.fecha,
  });
}

// Modelo para insumos
class Insumo {
  final int id;
  final String nombre;
  final String cantidad;
  final String unidad;

  Insumo({
    required this.id,
    required this.nombre,
    required this.cantidad,
    required this.unidad,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'nombre': nombre, 'cantidad': cantidad, 'unidad': unidad};
  }
}

class SalidaProductos extends StatefulWidget {
  @override
  _SalidaProductosState createState() => _SalidaProductosState();
}

class _SalidaProductosState extends State<SalidaProductos>
    with SingleTickerProviderStateMixin {
  // Lista de insumos (datos compartidos)
  static List<Map<String, dynamic>> _insumosCompartidos = [
    {
      'id': 1,
      'nombre': 'Traje de apicultor',
      'cantidad': '2',
      'unidad': 'unidad',
    },
    {
      'id': 2,
      'nombre': 'Guantes de protección',
      'cantidad': '4',
      'unidad': 'par',
    },
    {'id': 3, 'nombre': 'Ahumador', 'cantidad': '1', 'unidad': 'unidad'},
    {
      'id': 4,
      'nombre': 'Herramienta levanta cuadros',
      'cantidad': '3',
      'unidad': 'unidad',
    },
    {
      'id': 5,
      'nombre': 'Cepillo para abejas',
      'cantidad': '2',
      'unidad': 'unidad',
    },
    {
      'id': 6,
      'nombre': 'Alimentador de colmena',
      'cantidad': '5',
      'unidad': 'unidad',
    },
    {
      'id': 7,
      'nombre': 'Jeringas dosificadoras',
      'cantidad': '10',
      'unidad': 'unidad',
    },
  ];

  // Lista para registrar las salidas (datos compartidos)
  static List<SalidaInsumo> _salidasCompartidas = [];

  // Getters para acceder a los datos compartidos
  List<Map<String, dynamic>> get insumos => _insumosCompartidos;
  List<SalidaInsumo> get salidas => _salidasCompartidas;

  // Controladores
  TextEditingController searchController = TextEditingController();
  TextEditingController personaController = TextEditingController();
  TextEditingController cantidadController = TextEditingController();

  // Clave para validación del formulario
  final _formKeySalida = GlobalKey<FormState>();

  // Variables para el diálogo de salida
  Map<String, dynamic>? insumoSeleccionado;

  // Controlador para animaciones
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    searchController.dispose();
    personaController.dispose();
    cantidadController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Método para registrar salida de insumo con validación
  void _registrarSalida(Map<String, dynamic> insumo) {
    personaController.clear();
    cantidadController.clear();
    insumoSeleccionado = insumo;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Registrar Salida',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _formKeySalida,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.inventory_2, color: Colors.amber[700]),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              insumo['nombre'],
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.amber[800],
                              ),
                            ),
                            Text(
                              'Disponible: ${insumo['cantidad']} ${insumo['unidad']}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: personaController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de la persona',
                    labelStyle: GoogleFonts.poppins(),
                    hintText: 'Ej: Juan Pérez',
                    prefixIcon: Icon(Icons.person, color: Colors.amber),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                    errorStyle: GoogleFonts.poppins(color: Colors.red),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el nombre de la persona';
                    }
                    if (value.length < 3) {
                      return 'El nombre debe tener al menos 3 caracteres';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: cantidadController,
                  decoration: InputDecoration(
                    labelText: 'Cantidad a retirar',
                    labelStyle: GoogleFonts.poppins(),
                    hintText: 'Ej: 1',
                    prefixIcon: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.amber,
                    ),
                    suffixText: insumo['unidad'],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                    errorStyle: GoogleFonts.poppins(color: Colors.red),
                    helperText:
                        'Máximo disponible: ${insumo['cantidad']} ${insumo['unidad']}',
                    helperStyle: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una cantidad';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Ingresa un número válido';
                    }
                    if (int.parse(value) <= 0) {
                      return 'La cantidad debe ser mayor a 0';
                    }
                    if (int.parse(value) > int.parse(insumo['cantidad'])) {
                      return 'No hay suficiente inventario disponible';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: GoogleFonts.poppins(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (!_formKeySalida.currentState!.validate()) {
                  return;
                }

                int cantidadActual = int.parse(insumo['cantidad']);
                int cantidadSalida = int.parse(cantidadController.text);

                setState(() {
                  // Actualizar la cantidad del insumo
                  final index = _insumosCompartidos.indexWhere(
                    (item) => item['id'] == insumo['id'],
                  );
                  if (index != -1) {
                    _insumosCompartidos[index]['cantidad'] =
                        (cantidadActual - cantidadSalida).toString();
                  }

                  // Agregar a la lista de salidas
                  final newId =
                      _salidasCompartidas.isEmpty
                          ? 1
                          : _salidasCompartidas
                                  .map<int>((item) => item.id)
                                  .reduce((a, b) => a > b ? a : b) +
                              1;

                  _salidasCompartidas.add(
                    SalidaInsumo(
                      id: newId,
                      insumoId: insumo['id'],
                      nombreInsumo: insumo['nombre'],
                      cantidad: cantidadController.text,
                      persona: personaController.text,
                      fecha: DateTime.now(),
                    ),
                  );
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Salida registrada correctamente',
                          style: GoogleFonts.poppins(),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );

                Navigator.of(context).pop();
              },
              child: Text(
                'Registrar Salida',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  // Método para filtrar insumos
  List<Map<String, dynamic>> get filteredInsumos {
    if (searchController.text.isEmpty) {
      return insumos;
    }
    return insumos
        .where(
          (insumo) => insumo['nombre'].toLowerCase().contains(
            searchController.text.toLowerCase(),
          ),
        )
        .toList();
  }

  // Método para navegar al historial de salidas
  void _navegarAHistorial() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistorialSalidas(salidas: salidas),
      ),
    );
  }

  // Método para navegar a gestión de inventario
  void _navegarAGestion() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => GestionInventario(
              insumos: insumos,
              onInsumosChanged: (nuevosInsumos) {
                setState(() {
                  _insumosCompartidos = nuevosInsumos;
                });
              },
            ),
      ),
    ).then((_) {
      // Refrescar la vista cuando regrese de gestión
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFFFF8E1),
        child: Column(
          children: [
            // Header mejorado
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber, Colors.amber[600]!],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Salida de Productos',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Registra las salidas de tu inventario',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${insumos.length} insumos',
                            style: GoogleFonts.poppins(
                              color: Colors.amber[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.history, size: 18),
                            label: Text(
                              'Historial',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.amber[700],
                              padding: EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _navegarAHistorial,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.settings, size: 18),
                            label: Text(
                              'Gestión',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.amber[700],
                              padding: EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _navegarAGestion,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Barra de búsqueda
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber[200]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar insumo para registrar salida...',
                        hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                        prefixIcon: Icon(Icons.search, color: Colors.amber),
                        suffixIcon:
                            searchController.text.isNotEmpty
                                ? IconButton(
                                  icon: Icon(Icons.clear, color: Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      searchController.clear();
                                    });
                                  },
                                )
                                : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(
                    begin: -0.2,
                    end: 0,
                    duration: 600.ms,
                    curve: Curves.easeOutQuad,
                  ),
            ),

            // Lista de insumos para salida
            Expanded(child: _buildListaInsumos()),
          ],
        ),
      ),
    );
  }

Widget _buildListaInsumos() {
    // Asegúrate de que filteredInsumos no sea nulo
    final insumosFiltrados = filteredInsumos ?? [];

    if (insumosFiltrados.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.amber[300] ?? Colors.amber,
            ),
            SizedBox(height: 16),
            Text(
              'No se encontraron insumos',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600] ?? Colors.grey,
              ),
            ),
            Text(
              searchController.text.isNotEmpty
                  ? 'Intenta con otro término de búsqueda'
                  : 'No hay insumos disponibles',
              style: GoogleFonts.poppins(
                color: Colors.grey[500] ?? Colors.grey,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 600.ms);
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: insumosFiltrados.length,
      itemBuilder: (context, index) {
        final insumo = insumosFiltrados[index];
        // Asegúrate de que los campos no sean nulos y proporciona valores por defecto
        final cantidad =
            int.tryParse(insumo['cantidad']?.toString() ?? '0') ?? 0;
        final unidad = insumo['unidad']?.toString() ?? '';
        final nombre = insumo['nombre']?.toString() ?? 'Sin nombre';

        final bool cantidadBaja = cantidad <= 1;
        final bool sinStock = cantidad <= 0;

        return Card(
              margin: EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color:
                      sinStock
                          ? Colors.red[300] ?? Colors.red
                          : cantidadBaja
                          ? Colors.orange[200] ?? Colors.orange
                          : Colors.amber[100] ?? Colors.amber,
                  width: sinStock ? 2 : 1,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors:
                        sinStock
                            ? [
                              Colors.red[50] ?? Colors.red.shade50,
                              Colors.red[25] ?? Colors.red.shade100,
                            ]
                            : cantidadBaja
                            ? [
                              Colors.orange[50] ?? Colors.orange.shade50,
                              Colors.orange[25] ?? Colors.orange.shade100,
                            ]
                            : [
                              Colors.amber[50] ?? Colors.amber.shade50,
                              Colors.white,
                            ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  sinStock
                                      ? Colors.red[100] ?? Colors.red.shade100
                                      : cantidadBaja
                                      ? Colors.orange[100] ??
                                          Colors.orange.shade100
                                      : Colors.amber[100] ??
                                          Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.inventory_2,
                              color:
                                  sinStock
                                      ? Colors.red[700] ?? Colors.red
                                      : cantidadBaja
                                      ? Colors.orange[700] ?? Colors.orange
                                      : Colors.amber[700] ?? Colors.amber,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nombre,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color:
                                        sinStock
                                            ? Colors.red[800] ?? Colors.red
                                            : cantidadBaja
                                            ? Colors.orange[800] ??
                                                Colors.orange
                                            : Colors.grey[800] ?? Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      'Stock: ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey[600] ?? Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '$cantidad $unidad',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            sinStock
                                                ? Colors.red[700] ?? Colors.red
                                                : cantidadBaja
                                                ? Colors.orange[700] ??
                                                    Colors.orange
                                                : Colors.amber[700] ??
                                                    Colors.amber,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (sinStock)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'SIN STOCK',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          else if (cantidadBaja)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'STOCK BAJO',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Icon(
                            sinStock ? Icons.block : Icons.exit_to_app,
                            size: 18,
                          ),
                          label: Text(
                            sinStock
                                ? 'Sin Stock Disponible'
                                : 'Registrar Salida',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                sinStock
                                    ? Colors.grey[400] ?? Colors.grey
                                    : Colors.amber,
                            foregroundColor:
                                sinStock
                                    ? Colors.grey[600] ?? Colors.grey
                                    : Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed:
                              sinStock ? null : () => _registrarSalida(insumo),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(
              duration: 600.ms,
              delay: Duration(milliseconds: index * 100),
            )
            .slideX(
              begin: 0.2,
              end: 0,
              duration: 600.ms,
              curve: Curves.easeOutQuad,
            );
      },
    );
  }
  // // Método estático para acceder a los datos desde otras pantallas
  // static List<Map<String, dynamic>> getInsumos() => _insumosCompartidos;
  // static List<SalidaInsumo> getSalidas() => _salidasCompartidas;
  // static void updateInsumos(List<Map<String, dynamic>> nuevosInsumos) {
  //   _insumosCompartidos = nuevosInsumos;
  // }
}
