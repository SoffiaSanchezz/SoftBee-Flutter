import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InformesHistorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashboardScreen();
  }
}

class DashboardScreen extends StatelessWidget {
  // Definición de colores para mantener consistencia
  final Color primaryColor = Color(0xFF8D6E63); // Marrón más suave
  final Color secondaryColor = Color(0xFFFFA000); // Ámbar más vibrante
  final Color backgroundColor = Color(0xFFFFF8E1); // Fondo color miel claro
  final Color cardColor = Color(0xFFFFECB3); // Color para tarjetas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 4,
        title: Text(
              'Información del Apiario',
              style: GoogleFonts.concertOne(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideX(begin: -0.2, end: 0, curve: Curves.easeOutQuad),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDashboardSummary()
                .animate()
                .fadeIn(duration: 800.ms)
                .slideY(begin: -0.2, end: 0, curve: Curves.easeOutQuad),
            SizedBox(height: 24),
            _buildSectionTitle('Inventario de Insumos', Icons.inventory_2)
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .slideX(begin: -0.2, end: 0),
            SizedBox(height: 12),
            _buildInventoryGrid().animate().fadeIn(
              delay: 400.ms,
              duration: 800.ms,
            ),
            SizedBox(height: 24),
            _buildSectionTitle('Colmenas en Riesgo', Icons.warning_amber)
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms)
                .slideX(begin: -0.2, end: 0),
            SizedBox(height: 12),
            _buildRiskGrid().animate().fadeIn(delay: 800.ms, duration: 800.ms),
            SizedBox(height: 24),
            _buildSectionTitle('Estado General', Icons.bar_chart)
                .animate()
                .fadeIn(delay: 1000.ms, duration: 600.ms)
                .slideX(begin: -0.2, end: 0),
            SizedBox(height: 12),
            _buildGeneralStatus()
                .animate()
                .fadeIn(delay: 1200.ms, duration: 800.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
            SizedBox(height: 24),
            _buildHistorialInspecciones(context)
                .animate()
                .fadeIn(delay: 1400.ms, duration: 800.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: primaryColor.withOpacity(0.3), width: 2.0),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 28)
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.1, 1.1),
                duration: 2000.ms,
              ),
          SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.concertOne(
              fontSize: 22,
              color: primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryGrid() {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildInventoryCard(
              'Ahumador',
              'Cantidad: 5',
              Icons.local_fire_department,
            )
            .animate()
            .fadeIn(delay: 100.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0),
        _buildInventoryCard(
              'Trajes de Apicultor',
              'Cantidad: 10',
              Icons.security,
            )
            .animate()
            .fadeIn(delay: 200.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0),
        _buildInventoryCard('Guantes', 'Cantidad: 20', Icons.pan_tool)
            .animate()
            .fadeIn(delay: 300.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0),
        _buildInventoryCard('Herramientas', 'Cantidad: 15', Icons.build)
            .animate()
            .fadeIn(delay: 400.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildInventoryCard(String title, String subtitle, IconData icon) {
    return Card(
      color: cardColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: secondaryColor, size: 24)
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .rotate(
                    begin: -0.05,
                    end: 0.05,
                    duration: 2000.ms,
                    curve: Curves.easeInOut,
                  ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: primaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms)
                      .slideX(begin: 0.2, end: 0),
                  Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 400.ms)
                      .slideX(begin: 0.2, end: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskGrid() {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildRiskCard('Colmena 1', 'Bajo Riesgo', Colors.green)
            .animate()
            .fadeIn(delay: 100.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0),
        _buildRiskCard('Colmena 2', 'Alto Riesgo', Colors.red)
            .animate()
            .fadeIn(delay: 200.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0)
            .then(delay: 500.ms)
            .shimmer(duration: 1200.ms, color: Colors.red.withOpacity(0.3)),
        _buildRiskCard('Colmena 3', 'Moderado', Colors.orange)
            .animate()
            .fadeIn(delay: 300.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0)
            .then(delay: 500.ms)
            .shimmer(duration: 1200.ms, color: Colors.orange.withOpacity(0.3)),
        _buildRiskCard('Colmena 4', 'Bajo Riesgo', Colors.green)
            .animate()
            .fadeIn(delay: 400.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildRiskCard(String colmena, String estado, Color color) {
    return Card(
      color: color.withOpacity(0.15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.bug_report, color: color, size: 24)
                  .animate(
                    onPlay:
                        (controller) =>
                            color != Colors.green
                                ? controller.repeat(reverse: true)
                                : controller.forward(),
                  )
                  .scale(
                    begin: const Offset(1, 1),
                    end:
                        color != Colors.green
                            ? const Offset(1.2, 1.2)
                            : const Offset(1.1, 1.1),
                    duration: 1000.ms,
                  ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                        colmena,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms)
                      .slideX(begin: 0.2, end: 0),
                  Text(
                        estado,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 400.ms)
                      .slideX(begin: 0.2, end: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardSummary() {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                      Icons.headphones_battery_rounded,
                      color: secondaryColor,
                      size: 28,
                    )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1, 1),
                    )
                    .then(delay: 500.ms)
                    .rotate(begin: -0.1, end: 0.1, duration: 1500.ms)
                    .then()
                    .rotate(begin: 0.1, end: -0.1, duration: 1500.ms),
                SizedBox(width: 10),
                Text(
                      'Resumen del Apiario',
                      style: GoogleFonts.concertOne(
                        fontSize: 24,
                        color: primaryColor,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 600.ms)
                    .slideX(begin: 0.2, end: 0),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryItem('Inspecciones', '120', Icons.search)
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms)
                    .slideY(begin: 0.2, end: 0),
                _buildSummaryItem(
                      'Reinas Reemplazadas',
                      '8',
                      Icons.change_circle,
                    )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 600.ms)
                    .slideY(begin: 0.2, end: 0),
                _buildSummaryItem('Colmenas en Riesgo', '5', Icons.warning)
                    .animate()
                    .fadeIn(delay: 800.ms, duration: 600.ms)
                    .slideY(begin: 0.2, end: 0)
                    .then(delay: 500.ms)
                    .shimmer(
                      duration: 1200.ms,
                      color: Colors.red.withOpacity(0.3),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: secondaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: secondaryColor, size: 24)
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.2, 1.2),
                duration: 2000.ms,
              ),
        ),
        SizedBox(height: 8),
        Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            )
            .animate()
            .fadeIn(delay: 200.ms)
            .custom(
              builder:
                  (context, value, child) =>
                      Transform.scale(scale: 1.0 + (0.2 * value), child: child),
              duration: 600.ms,
              curve: Curves.easeOut,
            ),
        SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildGeneralStatus() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cardColor,
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.analytics, color: primaryColor, size: 24)
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1, 1),
                    ),
                SizedBox(width: 10),
                Text(
                      'Estado General del Apiario',
                      style: GoogleFonts.concertOne(
                        fontSize: 20,
                        color: primaryColor,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 400.ms)
                    .slideX(begin: 0.2, end: 0),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusInfo('Colmenas Saludables', '8', Colors.green)
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 600.ms)
                    .slideY(begin: 0.2, end: 0),
                Container(
                  height: 50,
                  width: 1,
                  color: Colors.grey.withOpacity(0.3),
                ),
                _buildStatusInfo('Colmenas en Riesgo', '2', Colors.red)
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms)
                    .slideY(begin: 0.2, end: 0)
                    .then(delay: 500.ms)
                    .shimmer(
                      duration: 1200.ms,
                      color: Colors.red.withOpacity(0.3),
                    ),
              ],
            ),
            SizedBox(height: 15),
            // Animación especial para el indicador de progreso
            Animate(
              effects: [
                FadeEffect(delay: 600.ms, duration: 800.ms),
                SlideEffect(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                  delay: 600.ms,
                  duration: 800.ms,
                ),
                CustomEffect(
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: 0.8 * value, // Animación de crecimiento
                      backgroundColor: Colors.red.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    );
                  },
                  delay: 800.ms,
                  duration: 1500.ms,
                  curve: Curves.easeOut,
                ),
              ],
              child: const SizedBox(height: 8, width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusInfo(String title, String value, Color color) {
    return Column(
      children: [
        Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            )
            .animate()
            .fadeIn(duration: 600.ms)
            .custom(
              builder:
                  (context, value, child) =>
                      Transform.scale(scale: 1.0 + (0.3 * value), child: child),
              duration: 800.ms,
              curve: Curves.elasticOut,
            ),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildHistorialInspecciones(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'Historial de Inspecciones',
          Icons.history,
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
        SizedBox(height: 12),
        Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildInspectionItem(
                        context,
                        fecha: '15 de marzo',
                        estado: 'Normal',
                        observaciones: 'Las colmenas están en buen estado.',
                        color: Colors.green,
                      )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 600.ms)
                      .slideX(begin: -0.2, end: 0),
                  Divider(height: 1, thickness: 1, indent: 70),
                  _buildInspectionItem(
                        context,
                        fecha: '2 de abril',
                        estado: 'Alerta',
                        observaciones:
                            'Se detectó una posible infestación de ácaros.',
                        color: Colors.orange,
                      )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 600.ms)
                      .slideX(begin: -0.2, end: 0)
                      .then(delay: 500.ms)
                      .shimmer(
                        duration: 1200.ms,
                        color: Colors.orange.withOpacity(0.3),
                      ),
                  Divider(height: 1, thickness: 1, indent: 70),
                  _buildInspectionItem(
                        context,
                        fecha: '20 de abril',
                        estado: 'Normal',
                        observaciones:
                            'Tratamiento completado, colmenas recuperadas.',
                        color: Colors.green,
                      )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 600.ms)
                      .slideX(begin: -0.2, end: 0),
                ],
              ),
            )
            .animate()
            .fadeIn(delay: 100.ms, duration: 800.ms)
            .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
      ],
    );
  }

  Widget _buildInspectionItem(
    BuildContext context, {
    required String fecha,
    required String estado,
    required String observaciones,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        // Aquí puedes navegar a la pantalla de detalle cuando esté implementada
        // Navigator.push(
        //   context,
        //   PageRouteBuilder(
        //     pageBuilder: (context, animation, secondaryAnimation) =>
        //       InspeccionDetalleScreen(
        //         fecha: fecha,
        //         estado: estado,
        //         observaciones: observaciones,
        //       ),
        //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //       const begin = Offset(1.0, 0.0);
        //       const end = Offset.zero;
        //       const curve = Curves.easeInOut;
        //       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        //       var offsetAnimation = animation.drive(tween);
        //       return SlideTransition(position: offsetAnimation, child: child);
        //     },
        //     transitionDuration: const Duration(milliseconds: 500),
        //   ),
        // );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                )
                .animate(
                  onPlay:
                      (controller) =>
                          color != Colors.green
                              ? controller.repeat(reverse: true)
                              : controller.forward(),
                )
                .scale(
                  begin: const Offset(1, 1),
                  end:
                      color != Colors.green
                          ? const Offset(1.5, 1.5)
                          : const Offset(1.2, 1.2),
                  duration: 1000.ms,
                ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                        'Inspección del $fecha',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms)
                      .slideX(begin: 0.1, end: 0),
                  SizedBox(height: 4),
                  Text(
                        'Estado: $estado',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 400.ms)
                      .slideX(begin: 0.1, end: 0),
                  SizedBox(height: 2),
                  Text(
                        observaciones,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms)
                      .slideX(begin: 0.1, end: 0),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .moveX(begin: 0, end: 3, duration: 1000.ms)
                .then()
                .moveX(begin: 3, end: 0, duration: 1000.ms),
          ],
        ),
      ),
    );
  }
}
