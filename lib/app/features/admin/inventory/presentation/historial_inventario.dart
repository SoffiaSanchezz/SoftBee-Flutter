import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:soft_bee/app/features/admin/inventory/page/salida_inventario_page.dart';

class HistorialSalidas extends StatefulWidget {
  final List<SalidaInsumo> salidas;

  const HistorialSalidas({Key? key, required this.salidas}) : super(key: key);

  @override
  _HistorialSalidasState createState() => _HistorialSalidasState();
}

class _HistorialSalidasState extends State<HistorialSalidas>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  late AnimationController _animationController;
  String filtroSeleccionado = 'todos'; // todos, hoy, semana, mes

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
    _animationController.dispose();
    super.dispose();
  }

  List<SalidaInsumo> get salidasFiltradas {
    List<SalidaInsumo> salidas = widget.salidas;

    if (searchController.text.isNotEmpty) {
      salidas =
          salidas.where((salida) {
            return salida.nombreInsumo.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ) ||
                salida.persona.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                );
          }).toList();
    }

    DateTime ahora = DateTime.now();
    switch (filtroSeleccionado) {
      case 'hoy':
        salidas =
            salidas.where((salida) {
              return salida.fecha.year == ahora.year &&
                  salida.fecha.month == ahora.month &&
                  salida.fecha.day == ahora.day;
            }).toList();
        break;
      case 'semana':
        DateTime inicioSemana = ahora.subtract(Duration(days: 7));
        salidas =
            salidas.where((salida) {
              return salida.fecha.isAfter(inicioSemana);
            }).toList();
        break;
      case 'mes':
        DateTime inicioMes = DateTime(ahora.year, ahora.month, 1);
        salidas =
            salidas.where((salida) {
              return salida.fecha.isAfter(inicioMes);
            }).toList();
        break;
    }

    return salidas;
  }

  Map<String, dynamic> get estadisticas {
    final salidas = salidasFiltradas;
    final totalSalidas = salidas.length;
    final insumosUnicos = salidas.map((s) => s.nombreInsumo).toSet().length;
    final personasUnicas = salidas.map((s) => s.persona).toSet().length;

    return {
      'totalSalidas': totalSalidas,
      'insumosUnicos': insumosUnicos,
      'personasUnicas': personasUnicas,
    };
  }

  @override
  Widget build(BuildContext context) {
    final stats = estadisticas;

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
                child: Row(
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
                            'Historial de Salidas',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Registro completo de movimientos',
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
                        '${widget.salidas.length}',
                        style: GoogleFonts.poppins(
                          color: Colors.amber[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Estadísticas
            Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Salidas',
                          stats['totalSalidas'].toString(),
                          Icons.exit_to_app,
                          Colors.blue,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Insumos',
                          stats['insumosUnicos'].toString(),
                          Icons.inventory_2,
                          Colors.green,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Personas',
                          stats['personasUnicas'].toString(),
                          Icons.people,
                          Colors.orange,
                        ),
                      ),
                    ],
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

            // Filtros y búsqueda
            Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Barra de búsqueda
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
                            hintText: 'Buscar por insumo o persona...',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey[500],
                            ),
                            prefixIcon: Icon(Icons.search, color: Colors.amber),
                            suffixIcon:
                                searchController.text.isNotEmpty
                                    ? IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.grey,
                                      ),
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
                      SizedBox(height: 12),

                      // Filtros de fecha
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFiltroChip('Todos', 'todos'),
                            SizedBox(width: 8),
                            _buildFiltroChip('Hoy', 'hoy'),
                            SizedBox(width: 8),
                            _buildFiltroChip('Esta semana', 'semana'),
                            SizedBox(width: 8),
                            _buildFiltroChip('Este mes', 'mes'),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 600.ms, delay: 200.ms)
                .slideY(
                  begin: -0.2,
                  end: 0,
                  duration: 600.ms,
                  curve: Curves.easeOutQuad,
                ),

            SizedBox(height: 16),

            // Lista de salidas
            Expanded(child: _buildListaSalidas()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String titulo,
    String valor,
    IconData icono,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icono, color: color, size: 32),
          SizedBox(height: 8),
          Text(
            valor,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            titulo,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltroChip(String texto, String valor) {
    final selected = filtroSeleccionado == valor;
    return ChoiceChip(
      label: Text(
        texto,
        style: GoogleFonts.poppins(
          color: selected ? Colors.white : Colors.amber[800],
          fontWeight: FontWeight.w600,
        ),
      ),
      selected: selected,
      selectedColor: Colors.amber,
      backgroundColor: Colors.amber[100],
      onSelected: (bool seleccionado) {
        setState(() {
          filtroSeleccionado = seleccionado ? valor : 'todos';
        });
      },
    );
  }

  Widget _buildListaSalidas() {
    final salidas = salidasFiltradas;

    if (salidas.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron salidas',
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: salidas.length,
      itemBuilder: (context, index) {
        final salida = salidas[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.amber[700]),
            title: Text(
              salida.nombreInsumo,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              '${salida.persona} • ${DateFormat.yMMMd().format(salida.fecha)}',
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.amber[700]),
            onTap: () {
              // Aquí puedes agregar acción al tocar una salida, si quieres
            },
          ),
        );
      },
    );
  }
}
