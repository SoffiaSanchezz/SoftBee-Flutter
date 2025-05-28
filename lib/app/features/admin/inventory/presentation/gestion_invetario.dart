import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GestionInventario extends StatefulWidget {
  final List<Map<String, dynamic>> insumos;
  final Function(List<Map<String, dynamic>>) onInsumosChanged;

  const GestionInventario({
    Key? key,
    required this.insumos,
    required this.onInsumosChanged,
  }) : super(key: key);

  @override
  _GestionInventarioState createState() => _GestionInventarioState();
}

class _GestionInventarioState extends State<GestionInventario>
    with SingleTickerProviderStateMixin {
  // Controladores para los formularios
  TextEditingController nombreController = TextEditingController();
  TextEditingController cantidadController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  // Clave para validación del formulario
  final _formKeyAgregar = GlobalKey<FormState>();

  // Variables de estado
  bool isEditing = false;
  int? editingId;
  String unidadSeleccionada = 'unidad';

  // Lista de unidades disponibles
  final List<String> unidades = [
    'unidad',
    'par',
    'kg',
    'litro',
    'metro',
    'caja',
    'gramo',
    'ml',
    'docena',
  ];

  // Controlador de animación
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
    nombreController.dispose();
    cantidadController.dispose();
    searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Método para agregar o editar insumos
  void _guardarInsumo() {
    if (!_formKeyAgregar.currentState!.validate()) {
      return;
    }

    List<Map<String, dynamic>> nuevosInsumos = List.from(widget.insumos);

    if (isEditing && editingId != null) {
      // Editar insumo existente
      final index = nuevosInsumos.indexWhere((item) => item['id'] == editingId);
      if (index != -1) {
        nuevosInsumos[index] = {
          'id': editingId,
          'nombre': nombreController.text.trim(),
          'cantidad': cantidadController.text,
          'unidad': unidadSeleccionada,
        };
      }
    } else {
      // Agregar nuevo insumo
      final newId =
          nuevosInsumos.isEmpty
              ? 1
              : nuevosInsumos
                      .map<int>((item) => item['id'])
                      .reduce((a, b) => a > b ? a : b) +
                  1;

      nuevosInsumos.add({
        'id': newId,
        'nombre': nombreController.text.trim(),
        'cantidad': cantidadController.text,
        'unidad': unidadSeleccionada,
      });
    }

    // Actualizar la lista
    widget.onInsumosChanged(nuevosInsumos);

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text(
              isEditing
                  ? 'Insumo actualizado correctamente'
                  : 'Insumo agregado correctamente',
              style: GoogleFonts.poppins(),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    // Limpiar formulario y cerrar diálogo
    _limpiarFormulario();
    Navigator.of(context).pop();
  }

  // Método para limpiar el formulario
  void _limpiarFormulario() {
    nombreController.clear();
    cantidadController.clear();
    unidadSeleccionada = 'unidad';
    isEditing = false;
    editingId = null;
  }

  // Método para editar insumos
  void _editarInsumo(Map<String, dynamic> insumo) {
    nombreController.text = insumo['nombre'];
    cantidadController.text = insumo['cantidad'];
    unidadSeleccionada = insumo['unidad'] ?? 'unidad';
    isEditing = true;
    editingId = insumo['id'];

    _mostrarDialogoAgregar();
  }

  // Método para eliminar insumos
  void _eliminarInsumo(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 8),
              Text(
                '¿Eliminar insumo?',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            'Esta acción no se puede deshacer. El insumo será eliminado permanentemente del inventario.',
            style: GoogleFonts.poppins(),
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
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                List<Map<String, dynamic>> nuevosInsumos = List.from(
                  widget.insumos,
                );
                nuevosInsumos.removeWhere((item) => item['id'] == id);
                widget.onInsumosChanged(nuevosInsumos);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Insumo eliminado correctamente',
                          style: GoogleFonts.poppins(),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.red,
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
                'Eliminar',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  // Método para mostrar diálogo de agregar/editar
  void _mostrarDialogoAgregar() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(
                    isEditing ? Icons.edit : Icons.add_circle,
                    color: Colors.amber,
                  ),
                  SizedBox(width: 8),
                  Text(
                    isEditing ? 'Editar Insumo' : 'Agregar Insumo',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Form(
                key: _formKeyAgregar,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Completa los detalles del insumo para tu apiario.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre del insumo',
                        labelStyle: GoogleFonts.poppins(),
                        hintText: 'Ej: Traje de apicultor',
                        prefixIcon: Icon(
                          Icons.inventory_2,
                          color: Colors.amber,
                        ),
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
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingresa un nombre';
                        }
                        if (value.trim().length < 3) {
                          return 'El nombre debe tener al menos 3 caracteres';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: cantidadController,
                            decoration: InputDecoration(
                              labelText: 'Cantidad',
                              labelStyle: GoogleFonts.poppins(),
                              hintText: 'Ej: 5',
                              prefixIcon: Icon(
                                Icons.numbers,
                                color: Colors.amber,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.amber),
                              ),
                              errorStyle: GoogleFonts.poppins(
                                color: Colors.red,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa cantidad';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Número válido';
                              }
                              if (int.parse(value) < 0) {
                                return 'Mayor a 0';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            value: unidadSeleccionada,
                            decoration: InputDecoration(
                              labelText: 'Unidad',
                              labelStyle: GoogleFonts.poppins(),
                              prefixIcon: Icon(
                                Icons.straighten,
                                color: Colors.amber,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.amber),
                              ),
                            ),
                            items:
                                unidades.map((String unidad) {
                                  return DropdownMenuItem<String>(
                                    value: unidad,
                                    child: Text(
                                      unidad,
                                      style: GoogleFonts.poppins(),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              setDialogState(() {
                                unidadSeleccionada = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _limpiarFormulario();
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
                  onPressed: _guardarInsumo,
                  child: Text(
                    isEditing ? 'Actualizar' : 'Agregar',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Método para filtrar insumos
  List<Map<String, dynamic>> get filteredInsumos {
    if (searchController.text.isEmpty) {
      return widget.insumos;
    }
    return widget.insumos
        .where(
          (insumo) => insumo['nombre'].toLowerCase().contains(
            searchController.text.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFFFF8E1),
        child: Column(
          children: [
            // Header
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
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gestión de Inventario',
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Administra tus insumos de apiario',
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
                            '${widget.insumos.length}',
                            style: GoogleFonts.poppins(
                              color: Colors.amber[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Barra de búsqueda y botón agregar
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
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
                        hintText: 'Buscar insumo...',
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
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add, size: 20),
                      label: Text(
                        'Agregar Nuevo Insumo',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        _limpiarFormulario();
                        _mostrarDialogoAgregar();
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Lista de insumos
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
              searchController.text.isNotEmpty
                  ? Icons.search_off
                  : Icons.inventory_2_outlined,
              size: 64,
              color: Colors.amber[300] ?? Colors.amber,
            ),
            SizedBox(height: 16),
            Text(
              searchController.text.isNotEmpty
                  ? 'No se encontraron insumos'
                  : 'No hay insumos registrados',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600] ?? Colors.grey,
              ),
            ),
            Text(
              searchController.text.isNotEmpty
                  ? 'Intenta con otro término de búsqueda'
                  : 'Agrega tu primer insumo al inventario',
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
        // Manejo seguro de valores nulos
        final cantidad =
            int.tryParse(insumo['cantidad']?.toString() ?? '0') ?? 0;
        final unidad = insumo['unidad']?.toString() ?? '';
        final nombre = insumo['nombre']?.toString() ?? 'Sin nombre';
        final id = insumo['id']?.toString() ?? '';

        final bool cantidadBaja = cantidad <= 1;

        return Card(
              margin: EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color:
                      cantidadBaja
                          ? Colors.red[100] ?? Colors.red.shade100
                          : Colors.amber[100] ?? Colors.amber.shade100,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors:
                        cantidadBaja
                            ? [
                              Colors.red[50] ?? Colors.red.shade50,
                              Colors.red[25] ?? Colors.red.shade100,
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
                                  cantidadBaja
                                      ? Colors.red[100] ?? Colors.red.shade100
                                      : Colors.amber[100] ??
                                          Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.inventory_2,
                              color:
                                  cantidadBaja
                                      ? Colors.red[700] ?? Colors.red
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
                                        cantidadBaja
                                            ? Colors.red[800] ?? Colors.red
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
                                            cantidadBaja
                                                ? Colors.red[700] ?? Colors.red
                                                : Colors.amber[700] ??
                                                    Colors.amber,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (cantidadBaja)
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
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: Icon(Icons.edit, size: 16),
                              label: Text(
                                'Editar',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    Colors.amber[700] ?? Colors.amber,
                                side: BorderSide(
                                  color: Colors.amber[300] ?? Colors.amber,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => _editarInsumo(insumo),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: Icon(Icons.delete, size: 16),
                              label: Text(
                                'Eliminar',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red[700] ?? Colors.red,
                                side: BorderSide(
                                  color: Colors.red[300] ?? Colors.red,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => _eliminarInsumo,
                            ),
                          ),
                        ],
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
}
