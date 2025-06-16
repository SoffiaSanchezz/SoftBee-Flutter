import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:soft_bee/app/features/admin/monitoring/page/registro_cosecha_page.dart';
import 'package:soft_bee/app/features/admin/monitoring/page/tratamiento_page.dart';
import 'package:soft_bee/app/features/admin/monitoring/presentation/queen_bee.dart';

class GenInfo extends StatelessWidget {
  final String colmenaNombre;

  const GenInfo({super.key, required this.colmenaNombre});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;

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
        centerTitle: true,
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
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 1200 : (isTablet ? 900 : double.infinity),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(colmenaNombre, isDesktop, isTablet)
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(
                        begin: -0.2,
                        end: 0,
                        duration: 600.ms,
                        curve: Curves.easeOutQuad,
                      ),
                  SizedBox(height: isDesktop ? 32 : 20),

                  // Layout responsive: en desktop, mostrar info y producción lado a lado
                  if (isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildInfoSection(isDesktop, isTablet)
                              .animate()
                              .fadeIn(delay: 200.ms, duration: 600.ms)
                              .slideX(begin: -0.2, end: 0),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 1,
                          child: _buildProductionSection(isDesktop, isTablet)
                              .animate()
                              .fadeIn(delay: 400.ms, duration: 600.ms)
                              .slideX(begin: 0.2, end: 0),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildInfoSection(isDesktop, isTablet)
                            .animate()
                            .fadeIn(delay: 200.ms, duration: 600.ms)
                            .slideY(begin: 0.2, end: 0),
                        SizedBox(height: isDesktop ? 32 : 20),
                        _buildProductionSection(isDesktop, isTablet)
                            .animate()
                            .fadeIn(delay: 400.ms, duration: 600.ms)
                            .slideY(begin: 0.2, end: 0),
                      ],
                    ),

                  SizedBox(height: isDesktop ? 32 : 20),
                  _buildActionsSection(context, isDesktop, isTablet)
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String colmenaNombre, bool isDesktop, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 32 : (isTablet ? 24 : 20)),
      decoration: BoxDecoration(
        color: Colors.amber[600],
        borderRadius: BorderRadius.circular(isDesktop ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header principal más compacto en desktop
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(isDesktop ? 16 : 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
                ),
                child: Icon(
                      Icons.hive,
                      size: isDesktop ? 40 : 32,
                      color: Colors.amber[700],
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .rotate(begin: -0.05, end: 0.05, duration: 2000.ms),
              ),
              SizedBox(width: isDesktop ? 24 : 16),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      colmenaNombre,
                      style: GoogleFonts.poppins(
                        fontSize: isDesktop ? 28 : (isTablet ? 26 : 24),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Información Detallada',
                      style: GoogleFonts.poppins(
                        fontSize: isDesktop ? 16 : 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isDesktop ? 32 : 20),

          // Estadísticas en grid responsive
          if (isDesktop)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHeaderStat(
                  icon: Icons.calendar_today_outlined,
                  label: 'Última Inspección',
                  value: '19-09-2024',
                  isDesktop: isDesktop,
                ),
                _buildHeaderStat(
                  icon: Icons.eco_outlined,
                  label: 'Producción',
                  value: '25 Kg',
                  isDesktop: isDesktop,
                ),
                _buildHeaderStat(
                  icon: Icons.favorite_outline,
                  label: 'Estado',
                  value: 'Saludable',
                  isDesktop: isDesktop,
                ),
              ],
            )
          else
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildHeaderStat(
                  icon: Icons.calendar_today_outlined,
                  label: 'Última Inspección',
                  value: '19-09-2024',
                  isDesktop: isDesktop,
                ),
                _buildHeaderStat(
                  icon: Icons.eco_outlined,
                  label: 'Producción',
                  value: '25 Kg',
                  isDesktop: isDesktop,
                ),
                _buildHeaderStat(
                  icon: Icons.favorite_outline,
                  label: 'Estado',
                  value: 'Saludable',
                  isDesktop: isDesktop,
                ),
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
    required bool isDesktop,
  }) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isDesktop ? 24 : 20, color: Colors.white),
          SizedBox(height: isDesktop ? 8 : 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isDesktop ? 14 : 12,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isDesktop ? 16 : 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(bool isDesktop, bool isTablet) {
    return Column(
      children: [
        _buildSectionTitle(
          'Información General',
          Icons.info_outline,
          isDesktop,
        ),
        SizedBox(height: isDesktop ? 16 : 12),
        _buildInfoCard(isDesktop, isTablet),
      ],
    );
  }

  Widget _buildInfoCard(bool isDesktop, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isDesktop ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
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
            isDesktop: isDesktop,
          ),
          Divider(height: isDesktop ? 32 : 24),
          _buildInfoRow(
            Icons.favorite_outline,
            'Estado de la reina:',
            'Saludable',
            iconColor: Colors.red[700]!,
            isDesktop: isDesktop,
          ),
          Divider(height: isDesktop ? 32 : 24),
          _buildInfoRow(
            Icons.calendar_today_outlined,
            'Última inspección:',
            '19-09-2024',
            iconColor: Colors.green[700]!,
            isHighlight: true,
            isDesktop: isDesktop,
          ),
          Divider(height: isDesktop ? 32 : 24),
          _buildInfoRow(
            Icons.thermostat_outlined,
            'Temperatura:',
            '35°C',
            iconColor: Colors.orange[700]!,
            isDesktop: isDesktop,
          ),
          Divider(height: isDesktop ? 32 : 24),
          _buildInfoRow(
            Icons.water_drop_outlined,
            'Humedad:',
            '65%',
            iconColor: Colors.cyan[700]!,
            isDesktop: isDesktop,
          ),
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
    required bool isDesktop,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isDesktop ? 12 : 8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(isDesktop ? 12 : 8),
          ),
          child: Icon(icon, color: iconColor, size: isDesktop ? 24 : 20),
        ),
        SizedBox(width: isDesktop ? 20 : 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: isDesktop ? 16 : 14,
                  color: Colors.black54,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: isDesktop ? 18 : 16,
                  fontWeight: FontWeight.bold,
                  color: isHighlight ? Colors.amber[800] : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductionSection(bool isDesktop, bool isTablet) {
    return Column(
      children: [
        _buildSectionTitle('Producción de Miel', Icons.eco_outlined, isDesktop),
        SizedBox(height: isDesktop ? 16 : 12),
        _buildProductionCard(isDesktop, isTablet),
      ],
    );
  }

  Widget _buildProductionCard(bool isDesktop, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isDesktop ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
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
                  fontSize: isDesktop ? 20 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 16 : 12,
                  vertical: isDesktop ? 8 : 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber[300]!),
                ),
                child: Text(
                  '25 Kg',
                  style: GoogleFonts.poppins(
                    fontSize: isDesktop ? 16 : 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isDesktop ? 24 : 20),
          LinearPercentIndicator(
            lineHeight: isDesktop ? 18 : 14,
            percent: 0.5,
            backgroundColor: Colors.grey[200],
            progressColor: Colors.amber[600],
            barRadius: Radius.circular(isDesktop ? 9 : 7),
            animation: true,
            animationDuration: 1500,
            center: Text(
              '50%',
              style: GoogleFonts.poppins(
                fontSize: isDesktop ? 12 : 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: isDesktop ? 16 : 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Meta: 50 Kg',
                style: GoogleFonts.poppins(
                  fontSize: isDesktop ? 16 : 14,
                  color: Colors.black54,
                ),
              ),
              Text(
                'Temporada: Primavera 2024',
                style: GoogleFonts.poppins(
                  fontSize: isDesktop ? 16 : 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          SizedBox(height: isDesktop ? 24 : 20),
          const Divider(),
          SizedBox(height: isDesktop ? 16 : 12),

          // En desktop, mostrar estadísticas en fila; en móvil, en columna
          if (isDesktop || isTablet)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildProductionStat(
                  label: 'Producción Anterior',
                  value: '22 Kg',
                  change: '+3 Kg',
                  isPositive: true,
                  isDesktop: isDesktop,
                ),
                _buildProductionStat(
                  label: 'Promedio Apiario',
                  value: '20 Kg',
                  change: '+5 Kg',
                  isPositive: true,
                  isDesktop: isDesktop,
                ),
              ],
            )
          else
            Column(
              children: [
                _buildProductionStat(
                  label: 'Producción Anterior',
                  value: '22 Kg',
                  change: '+3 Kg',
                  isPositive: true,
                  isDesktop: isDesktop,
                ),
                const SizedBox(height: 16),
                _buildProductionStat(
                  label: 'Promedio Apiario',
                  value: '20 Kg',
                  change: '+5 Kg',
                  isPositive: true,
                  isDesktop: isDesktop,
                ),
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
    required bool isDesktop,
  }) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isDesktop ? 16 : 14,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isDesktop ? 8 : 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: isDesktop ? 18 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isPositive ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12,
                      color: isPositive ? Colors.green[700] : Colors.red[700],
                    ),
                    const SizedBox(width: 2),
                    Text(
                      change,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isPositive ? Colors.green[700] : Colors.red[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(
    BuildContext context,
    bool isDesktop,
    bool isTablet,
  ) {
    return Column(
      children: [
        _buildSectionTitle('Acciones', Icons.touch_app_outlined, isDesktop),
        SizedBox(height: isDesktop ? 16 : 12),

        // En desktop, mostrar acciones en grid 2x2; en tablet 2x2; en móvil, scroll horizontal
        if (isDesktop)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: _buildActionButtons(context, isDesktop),
          )
        else if (isTablet)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: _buildActionButtons(context, isDesktop),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  _buildActionButtons(context, isDesktop)
                      .map(
                        (button) => Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: button,
                        ),
                      )
                      .toList(),
            ),
          ),

        SizedBox(height: isDesktop ? 32 : 20),

        // Botón de volver
        SizedBox(
          width: isDesktop ? 300 : double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black87,
              padding: EdgeInsets.symmetric(vertical: isDesktop ? 16 : 12),
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
                fontSize: isDesktop ? 18 : 16,
              ),
            ),
          ),
        ),
        SizedBox(height: isDesktop ? 40 : 30),
      ],
    );
  }

  List<Widget> _buildActionButtons(BuildContext context, bool isDesktop) {
    final buttonWidth = isDesktop ? 140.0 : 120.0;

    return [
      _buildActionButton(
        icon: Icons.add_circle_outline,
        label: 'Nueva Inspección',
        onPressed: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => MonitoreoApiarioScreen()));
        },
        color: Colors.green[700]!,
        width: buttonWidth,
        isDesktop: isDesktop,
      ),
      _buildActionButton(
        icon: Icons.change_circle_outlined,
        label: 'Remplazo de Reina',
        onPressed: () {
          Navigator.push(context, MaterialPageRoute
          (builder: (context) => QueenReplacementScreen(colmenaNombre: colmenaNombre)));
        },
        color: Colors.amber[700]!,
        width: buttonWidth,
        isDesktop: isDesktop,
      ),
      _buildActionButton(
        icon: Icons.eco_outlined,
        label: 'Registrar Cosecha',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>RegistrarCosechaScreen(colmenaNombre: colmenaNombre),
            ),
          );
        },
        color: Colors.blue[700]!,
        width: buttonWidth,
        isDesktop: isDesktop,
      ),
      _buildActionButton(
        icon: Icons.medical_services_outlined,
        label: 'Tratamiento',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => TratamientoScreen(colmenaNombre: colmenaNombre),
            ),
          );
        },
        color: Colors.red[700]!,
        width: buttonWidth,
        isDesktop: isDesktop,
      ),
    ];
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    required double width,
    required bool isDesktop,
  }) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          foregroundColor: color,
          padding: EdgeInsets.symmetric(
            vertical: isDesktop ? 20 : 16,
            horizontal: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
            side: BorderSide(color: color.withOpacity(0.3)),
          ),
          elevation: 0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: isDesktop ? 28 : 24),
            SizedBox(height: isDesktop ? 12 : 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: isDesktop ? 13 : 11,
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

  Widget _buildSectionTitle(String title, IconData icon, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: isDesktop ? 24 : 20, color: Colors.amber[800]),
        SizedBox(width: isDesktop ? 12 : 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: isDesktop ? 22 : 18,
            fontWeight: FontWeight.bold,
            color: Colors.amber[800],
          ),
        ),
      ],
    );
  }
}
