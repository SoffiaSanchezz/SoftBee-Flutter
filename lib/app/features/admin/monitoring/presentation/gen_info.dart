import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:soft_bee/app/features/admin/monitoring/page/colmena_page.dart';
import 'package:soft_bee/app/features/admin/monitoring/presentation/gestion_apiario.dart';
import 'package:soft_bee/app/features/admin/monitoring/presentation/queen_bee.dart';


class GenInfo extends StatelessWidget {
  final String colmenaNombre;

  const GenInfo({super.key, required this.colmenaNombre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
              'Información Detallada',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
            .animate()
            .fadeIn(duration: 500.ms)
            .slideX(
              begin: -0.2,
              end: 0,
              duration: 500.ms,
              curve: Curves.easeOutQuad,
            ),
        backgroundColor: Colors.amber[600],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true, // Centrar el título
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {})
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms)
              .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})
              .animate()
              .fadeIn(delay: 400.ms, duration: 400.ms)
              .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),
        ],
      ),
      backgroundColor: const Color(0xFFF9F8F6),
      body: SafeArea(
        child: Center( // Centrar todo el contenido
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800), // Limitar ancho máximo
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Centrar elementos
                children: [
                  _buildHeader(colmenaNombre)
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(
                        begin: -0.2,
                        end: 0,
                        duration: 600.ms,
                        curve: Curves.easeOutQuad,
                      ),
                  const SizedBox(height: 20),
                  _buildInfoSection()
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 600.ms)
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 600.ms,
                        curve: Curves.easeOutQuad,
                      ),
                  const SizedBox(height: 20),
                  _buildProductionSection()
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 600.ms)
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 600.ms,
                        curve: Curves.easeOutQuad,
                      ),
                  const SizedBox(height: 20),
                  _buildActionsSection(context)
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 600.ms)
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 600.ms,
                        curve: Curves.easeOutQuad,
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String colmenaNombre) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber[600],
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [ // Centrar contenido del header
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centrar la fila principal
            children: [
              Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.hive, size: 32, color: Colors.amber[700])
                        .animate(
                          onPlay:
                              (controller) => controller.repeat(reverse: true),
                        )
                        .rotate(
                          begin: -0.05,
                          end: 0.05,
                          duration: 2000.ms,
                          curve: Curves.easeInOut,
                        ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1, 1),
                  ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Centrar texto
                children: [
                  Text(
                        colmenaNombre,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms)
                      .slideX(begin: 0.2, end: 0),
                  Text(
                        'Información Detallada',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 400.ms)
                      .slideX(begin: 0.2, end: 0),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Estadísticas centradas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribuir uniformemente
            children: [
              _buildHeaderStat(
                    icon: Icons.calendar_today_outlined,
                    label: 'Última Inspección',
                    value: '19-09-2024',
                  )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 500.ms)
                  .slideY(begin: 0.2, end: 0),
              _buildHeaderStat(
                    icon: Icons.eco_outlined,
                    label: 'Producción',
                    value: '25 Kg',
                  )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 500.ms)
                  .slideY(begin: 0.2, end: 0),
              _buildHeaderStat(
                    icon: Icons.favorite_outline,
                    label: 'Estado',
                    value: 'Saludable',
                  )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 500.ms)
                  .slideY(begin: 0.2, end: 0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.white)
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.2, 1.2),
              duration: 1500.ms,
            ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [ // Centrar sección
          _buildSectionTitle(
            'Información General',
            Icons.info_outline,
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0),
          const SizedBox(height: 12),
          _buildInfoCard()
              .animate()
              .fadeIn(delay: 200.ms, duration: 600.ms)
              .slideY(
                begin: 0.1,
                end: 0,
                duration: 600.ms,
                curve: Curves.easeOutQuad,
              ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.amber[200]!, width: 1),
      ),
      child: Column(
        children: [
          _buildInfoRow(
                Icons.groups_outlined,
                'Población:',
                'Alta',
                iconColor: Colors.blue[700]!,
              )
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms)
              .slideX(begin: -0.1, end: 0),
          const Divider(height: 24),
          _buildInfoRow(
                Icons.favorite_outline,
                'Estado de la reina:',
                'Saludable',
                iconColor: Colors.red[700]!,
              )
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms)
              .slideX(begin: -0.1, end: 0),
          const Divider(height: 24),
          _buildInfoRow(
                Icons.calendar_today_outlined,
                'Última inspección:',
                '19-09-2024',
                iconColor: Colors.green[700]!,
                isHighlight: true,
              )
              .animate()
              .fadeIn(delay: 300.ms, duration: 400.ms)
              .slideX(begin: -0.1, end: 0)
              .shimmer(delay: 800.ms, duration: 1200.ms),
          const Divider(height: 24),
          _buildInfoRow(
                Icons.thermostat_outlined,
                'Temperatura:',
                '35°C',
                iconColor: Colors.orange[700]!,
              )
              .animate()
              .fadeIn(delay: 400.ms, duration: 400.ms)
              .slideX(begin: -0.1, end: 0),
          const Divider(height: 24),
          _buildInfoRow(
                Icons.water_drop_outlined,
                'Humedad:',
                '65%',
                iconColor: Colors.cyan[700]!,
              )
              .animate()
              .fadeIn(delay: 500.ms, duration: 400.ms)
              .slideX(begin: -0.1, end: 0),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    required Color iconColor,
    bool isHighlight = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20)
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.1, 1.1),
                duration: 2000.ms,
              ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
              ),
              Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isHighlight ? Colors.amber[800] : Colors.black87,
                    ),
                  )
                  .animate(target: isHighlight ? 1 : 0)
                  .shimmer(duration: 1500.ms, color: Colors.amber[300]!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [ // Centrar sección
          _buildSectionTitle(
            'Producción de Miel',
            Icons.eco_outlined,
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0),
          const SizedBox(height: 12),
          _buildProductionCard()
              .animate()
              .fadeIn(delay: 200.ms, duration: 600.ms)
              .slideY(
                begin: 0.1,
                end: 0,
                duration: 600.ms,
                curve: Curves.easeOutQuad,
              ),
        ],
      ),
    );
  }

  Widget _buildProductionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.amber[200]!, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Producción Actual',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.amber[300]!),
                    ),
                    child: Text(
                      '25 Kg',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[800],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1))
                  .shimmer(delay: 800.ms, duration: 1200.ms),
            ],
          ),
          const SizedBox(height: 20),
          LinearPercentIndicator(
                lineHeight: 14,
                percent: 0.5,
                backgroundColor: Colors.grey[200],
                progressColor: Colors.amber[600],
                barRadius: const Radius.circular(7),
                animation: true,
                animationDuration: 1500,
                leading: const Icon(
                      Icons.arrow_downward,
                      size: 16,
                      color: Colors.grey,
                    )
                    .animate()
                    .fadeIn(delay: 1500.ms)
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1, 1),
                    ),
                trailing: const Icon(
                      Icons.arrow_upward,
                      size: 16,
                      color: Colors.grey,
                    )
                    .animate()
                    .fadeIn(delay: 1500.ms)
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1, 1),
                    ),
                center: Text(
                  '50%',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 400.ms, duration: 800.ms)
              .slideX(
                begin: -0.2,
                end: 0,
                duration: 800.ms,
                curve: Curves.easeOutQuad,
              ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Meta: 50 Kg',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
              ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
              Text(
                'Temporada: Primavera 2024',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
              ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Centrar estadísticas
            children: [
              _buildProductionStat(
                    label: 'Producción Anterior',
                    value: '22 Kg',
                    change: '+3 Kg',
                    isPositive: true,
                  )
                  .animate()
                  .fadeIn(delay: 800.ms, duration: 500.ms)
                  .slideY(begin: 0.2, end: 0),
              _buildProductionStat(
                    label: 'Promedio Apiario',
                    value: '20 Kg',
                    change: '+5 Kg',
                    isPositive: true,
                  )
                  .animate()
                  .fadeIn(delay: 900.ms, duration: 500.ms)
                  .slideY(begin: 0.2, end: 0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductionStat({
    required String label,
    required String value,
    required String change,
    required bool isPositive,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // ¡Aquí va!
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                            isPositive
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            size: 12,
                            color:
                                isPositive
                                    ? Colors.green[700]
                                    : Colors.red[700],
                          )
                          .animate(
                            onPlay:
                                (controller) =>
                                    controller.repeat(reverse: true),
                          )
                          .moveY(
                            begin: 0,
                            end: isPositive ? -2 : 2,
                            duration: 1000.ms,
                          ),
                      const SizedBox(width: 2),
                      Text(
                        change,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:
                              isPositive ? Colors.green[700] : Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(delay: 200.ms)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [ // Centrar sección de acciones
          _buildSectionTitle(
            'Acciones',
            Icons.touch_app_outlined,
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0),
          const SizedBox(height: 12),
          // Acciones en fila horizontal hacia la derecha
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // Alinear a la derecha
              children: [
                _buildActionButton(
                      icon: Icons.add_circle_outline,
                      label: 'Nueva Inspección',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => MonitoreoApiarioScreen(),
                        ));
                      },
                      color: Colors.green[700]!,
                    )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 500.ms)
                    .slideX(begin: -0.2, end: 0),
                const SizedBox(width: 12),
                _buildActionButton(
                      icon: Icons.change_circle_outlined,
                      label: 'Remplazo de Reina',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => QueenReplacementScreen(colmenaNombre: colmenaNombre)
                          ),
                        );
                      },
                      color: Colors.amber[700]!,
                    )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 500.ms)
                    .slideX(begin: 0.2, end: 0),
                const SizedBox(width: 12),
                _buildActionButton(
                      icon: Icons.eco_outlined,
                      label: 'Registrar Cosecha',
                      onPressed: () {},
                      color: Colors.blue[700]!,
                    )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 500.ms)
                    .slideX(begin: -0.2, end: 0),
                const SizedBox(width: 12),
                _buildActionButton(
                      icon: Icons.medical_services_outlined,
                      label: 'Tratamiento',
                      onPressed: () {},
                      color: Colors.red[700]!,
                    )
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 500.ms)
                    .slideX(begin: 0.2, end: 0),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Botón de volver centrado
          Center(
            child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.arrow_back),
                    label: Text(
                      'Volver al Monitoreo',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms)
                .slideY(
                  begin: 0.2,
                  end: 0,
                  duration: 600.ms,
                  curve: Curves.easeOutQuad,
                )
                .shimmer(delay: 1200.ms, duration: 1200.ms),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return SizedBox(
      width: 120, // Ancho fijo para mantener consistencia
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color.withOpacity(0.3)),
          ),
          elevation: 0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24)
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.2, 1.2),
                  duration: 1500.ms,
                ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Centrar títulos de sección
      children: [
        Icon(icon, size: 20, color: Colors.amber[800])
            .animate()
            .fadeIn(duration: 300.ms)
            .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),
        const SizedBox(width: 8),
        Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.amber[800],
              ),
            )
            .animate()
            .fadeIn(delay: 100.ms, duration: 300.ms)
            .slideX(begin: 0.2, end: 0),
      ],
    );
  }
}