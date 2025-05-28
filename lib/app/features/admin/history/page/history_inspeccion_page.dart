import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:soft_bee/app/features/admin/history/presentation/detalle_inspeccion.dart';
// import 'inspeccion_detalle_screen.dart';

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
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            _buildHeader(),
            SizedBox(height: 16),
            _buildHistorialItem(
              context,
              '15 de marzo',
              'Normal',
              'Las colmenas están en buen estado.',
              Icons.check_circle_outline,
              Colors.green,
              'assets/images/honeycomb_pattern.png',
            ).animate().fadeIn(duration: 300.ms).slideX(),
            _buildHistorialItem(
              context,
              '20 de abril',
              'Alerta',
              'Colmena 3 requiere inspección urgente.',
              Icons.warning_amber_rounded,
              Colors.orange,
              'assets/images/honeycomb_pattern.png',
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideX(),
            _buildHistorialItem(
              context,
              '5 de mayo',
              'Normal',
              'Condiciones óptimas en todas las colmenas.',
              Icons.check_circle_outline,
              Colors.green,
              'assets/images/honeycomb_pattern.png',
            ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideX(),
          ],
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

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen de Actividad',
            style: GoogleFonts.concertOne(
              fontSize: 20,
              color: Colors.brown[800],
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('3', 'Inspecciones', Icons.assignment),
                _buildStatItem('2', 'Colmenas\nSaludables', Icons.favorite),
                _buildStatItem(
                  '1',
                  'Alertas\nPendientes',
                  Icons.warning_amber_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.brown[800], size: 28),
        SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.brown[800],
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.brown[800]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildHistorialItem(
    BuildContext context,
    String fecha,
    String estado,
    String observaciones,
    IconData statusIcon,
    Color statusColor,
    String backgroundPattern,
  ) {
    return Hero(
      tag: 'inspeccion_$fecha',
      child: Card(
        elevation: 4,
        shadowColor: Colors.amber.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.amber.withOpacity(0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Inspección del $fecha',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[800],
                        ),
                      ),
                      _buildStatusBadge(estado, statusIcon, statusColor),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    observaciones,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.brown[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Ver detalles',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.amber[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
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

  Widget _buildStatusBadge(String status, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 4),
          Text(
            status,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
