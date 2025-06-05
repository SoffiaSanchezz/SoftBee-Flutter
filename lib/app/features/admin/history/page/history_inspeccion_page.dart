import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:soft_bee/app/features/admin/history/presentation/detalle_inspeccion.dart';

class HistorialInspeccionesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Historial de Inspecciones',
          style: GoogleFonts.concertOne(
            color: Colors.white,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Color(0xFF8D6E63),
        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.amber.withOpacity(0.05), Colors.white],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Determinar si es una pantalla grande
            bool isLargeScreen = constraints.maxWidth > 768;
            bool isExtraLargeScreen = constraints.maxWidth > 1200;

            return Center(
              child: Container(
                // Limitar el ancho máximo en pantallas muy grandes
                constraints: BoxConstraints(
                  maxWidth: isExtraLargeScreen ? 1200 : double.infinity,
                ),
                child:
                    isLargeScreen
                        ? _buildLargeScreenLayout(context, constraints)
                        : _buildMobileLayout(context),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para agregar nueva inspección
        },
        backgroundColor: Color(0xFFFFB300),
        child: Icon(Icons.add, color: Colors.brown[800]),
      ).animate().scale(delay: 300.ms),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        _buildHeader(false),
        SizedBox(height: 16),
        ..._buildInspeccionItems(context, false),
      ],
    );
  }

  Widget _buildLargeScreenLayout(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Header con estadísticas en layout horizontal mejorado
          _buildHeader(true),
          SizedBox(height: 32),

          // Grid de inspecciones para pantallas grandes
          _buildInspeccionesGrid(context, constraints),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isLargeScreen) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isLargeScreen ? 24 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Resumen de Actividad',
              style: GoogleFonts.concertOne(
                fontSize: isLargeScreen ? 28 : 20,
                color: Colors.brown[800],
              ),
            ),
          ),
          SizedBox(height: isLargeScreen ? 16 : 8),
          Container(
            padding: EdgeInsets.all(isLargeScreen ? 24 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child:
                isLargeScreen ? _buildLargeScreenStats() : _buildMobileStats(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildMobileStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('3', 'Inspecciones', Icons.assignment, false),
        _buildStatItem('2', 'Colmenas\nSaludables', Icons.favorite, false),
        _buildStatItem(
          '1',
          'Alertas\nPendientes',
          Icons.warning_amber_rounded,
          false,
        ),
      ],
    );
  }

  Widget _buildLargeScreenStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '3',
            'Inspecciones Realizadas',
            Icons.assignment,
            'Total de inspecciones completadas este mes',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            '2',
            'Colmenas Saludables',
            Icons.favorite,
            'Colmenas en condiciones óptimas',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            '1',
            'Alertas Pendientes',
            Icons.warning_amber_rounded,
            'Requieren atención inmediata',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String value,
    String title,
    IconData icon,
    String description,
  ) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.brown[800], size: 36),
          SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.brown[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.brown[800],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.brown[600]),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    IconData icon,
    bool isLarge,
  ) {
    return Column(
      children: [
        Icon(icon, color: Colors.brown[800], size: isLarge ? 32 : 28),
        SizedBox(height: isLarge ? 12 : 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isLarge ? 24 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.brown[800],
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isLarge ? 14 : 12,
            color: Colors.brown[800],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInspeccionesGrid(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    // Determinar número de columnas basado en el ancho
    int crossAxisCount = 1;
    if (constraints.maxWidth > 1200) {
      crossAxisCount = 3;
    } else if (constraints.maxWidth > 768) {
      crossAxisCount = 2;
    }

    List<Widget> items = _buildInspeccionItems(context, true);

    if (crossAxisCount == 1) {
      return Column(children: items);
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.8, // Ajustar según necesidades
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => items[index],
    );
  }

  List<Widget> _buildInspeccionItems(BuildContext context, bool isLargeScreen) {
    final inspecciones = [
      {
        'fecha': '15 de marzo',
        'estado': 'Normal',
        'observaciones': 'Las colmenas están en buen estado.',
        'icon': Icons.check_circle_outline,
        'color': Colors.green,
      },
      {
        'fecha': '20 de abril',
        'estado': 'Alerta',
        'observaciones': 'Colmena 3 requiere inspección urgente.',
        'icon': Icons.warning_amber_rounded,
        'color': Colors.orange,
      },
      {
        'fecha': '5 de mayo',
        'estado': 'Normal',
        'observaciones': 'Condiciones óptimas en todas las colmenas.',
        'icon': Icons.check_circle_outline,
        'color': Colors.green,
      },
    ];

    return inspecciones.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> inspeccion = entry.value;

      return _buildHistorialItem(
            context,
            inspeccion['fecha'],
            inspeccion['estado'],
            inspeccion['observaciones'],
            inspeccion['icon'],
            inspeccion['color'],
            'assets/images/honeycomb_pattern.png',
            isLargeScreen,
          )
          .animate()
          .fadeIn(duration: Duration(milliseconds: 300 + (index * 100)))
          .slideX(delay: Duration(milliseconds: index * 100));
    }).toList();
  }

  Widget _buildHistorialItem(
    BuildContext context,
    String fecha,
    String estado,
    String observaciones,
    IconData statusIcon,
    Color statusColor,
    String backgroundPattern,
    bool isLargeScreen,
  ) {
    return Hero(
      tag: 'inspeccion_$fecha',
      child: Card(
        elevation: isLargeScreen ? 6 : 4,
        shadowColor: Colors.amber.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.amber.withOpacity(0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => InspeccionDetalleScreen(
                        fecha: fecha,
                        estado: estado,
                        observaciones: observaciones,
                      ),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(isLargeScreen ? 24.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Inspección del $fecha',
                          style: GoogleFonts.poppins(
                            fontSize: isLargeScreen ? 18 : 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[800],
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      _buildStatusBadge(
                        estado,
                        statusIcon,
                        statusColor,
                        isLargeScreen,
                      ),
                    ],
                  ),
                  SizedBox(height: isLargeScreen ? 16 : 12),
                  Text(
                    observaciones,
                    style: GoogleFonts.poppins(
                      fontSize: isLargeScreen ? 16 : 14,
                      color: Colors.brown[600],
                      height: 1.4,
                    ),
                    maxLines: isLargeScreen ? 3 : 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isLargeScreen ? 16 : 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Ver detalles',
                        style: GoogleFonts.poppins(
                          fontSize: isLargeScreen ? 16 : 14,
                          color: Colors.amber[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: isLargeScreen ? 16 : 14,
                        color: Colors.amber[800],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(
    String status,
    IconData icon,
    Color color,
    bool isLargeScreen,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLargeScreen ? 16 : 12,
        vertical: isLargeScreen ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isLargeScreen ? 18 : 16, color: color),
          SizedBox(width: 6),
          Text(
            status,
            style: GoogleFonts.poppins(
              fontSize: isLargeScreen ? 14 : 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
