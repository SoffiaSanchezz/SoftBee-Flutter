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
                fontSize: _getAppBarFontSize(context),
                fontWeight: FontWeight.w500,
              ),
            )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideX(begin: -0.2, end: 0, curve: Curves.easeOutQuad),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 1200;
          final isTablet =
              constraints.maxWidth > 768 && constraints.maxWidth <= 1200;
          final isMobile = constraints.maxWidth <= 768;

          return SingleChildScrollView(
            padding: EdgeInsets.all(_getPadding(context)),
            child: _buildResponsiveLayout(
              context,
              isDesktop,
              isTablet,
              isMobile,
            ),
          );
        },
      ),
    );
  }

  Widget _buildResponsiveLayout(
    BuildContext context,
    bool isDesktop,
    bool isTablet,
    bool isMobile,
  ) {
    if (isDesktop) {
      return _buildDesktopLayout(context);
    } else if (isTablet) {
      return _buildTabletLayout(context);
    } else {
      return _buildMobileLayout(context);
    }
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dashboard Summary - Más ancho en desktop
        _buildDashboardSummary()
            .animate()
            .fadeIn(duration: 800.ms)
            .slideY(begin: -0.2, end: 0, curve: Curves.easeOutQuad),
        SizedBox(height: 32),

        // Layout de dos columnas para desktop
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Columna izquierda
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Inventario de Insumos', Icons.inventory_2)
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 600.ms)
                      .slideX(begin: -0.2, end: 0),
                  SizedBox(height: 16),
                  _buildInventoryGrid(
                    crossAxisCount: 2,
                    childAspectRatio: 2.2,
                  ).animate().fadeIn(delay: 400.ms, duration: 800.ms),
                  SizedBox(height: 32),
                  _buildSectionTitle('Estado General', Icons.bar_chart)
                      .animate()
                      .fadeIn(delay: 1000.ms, duration: 600.ms)
                      .slideX(begin: -0.2, end: 0),
                  SizedBox(height: 16),
                  _buildGeneralStatus()
                      .animate()
                      .fadeIn(delay: 1200.ms, duration: 800.ms)
                      .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
                ],
              ),
            ),
            SizedBox(width: 32),

            // Columna derecha
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Colmenas en Riesgo', Icons.warning_amber)
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 600.ms)
                      .slideX(begin: -0.2, end: 0),
                  SizedBox(height: 16),
                  _buildRiskGrid(
                    crossAxisCount: 1,
                    childAspectRatio: 4.0,
                  ).animate().fadeIn(delay: 800.ms, duration: 800.ms),
                  SizedBox(height: 32),
                  _buildHistorialInspecciones(context)
                      .animate()
                      .fadeIn(delay: 1400.ms, duration: 800.ms)
                      .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDashboardSummary()
            .animate()
            .fadeIn(duration: 800.ms)
            .slideY(begin: -0.2, end: 0, curve: Curves.easeOutQuad),
        SizedBox(height: 24),

        // Layout de dos filas para tablet
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Inventario de Insumos', Icons.inventory_2)
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 600.ms)
                      .slideX(begin: -0.2, end: 0),
                  SizedBox(height: 12),
                  _buildInventoryGrid(
                    crossAxisCount: 2,
                    childAspectRatio: 2.8,
                  ).animate().fadeIn(delay: 400.ms, duration: 800.ms),
                ],
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Colmenas en Riesgo', Icons.warning_amber)
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 600.ms)
                      .slideX(begin: -0.2, end: 0),
                  SizedBox(height: 12),
                  _buildRiskGrid(
                    crossAxisCount: 2,
                    childAspectRatio: 2.8,
                  ).animate().fadeIn(delay: 800.ms, duration: 800.ms),
                ],
              ),
            ),
          ],
        ),
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
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
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
        _buildInventoryGrid().animate().fadeIn(delay: 400.ms, duration: 800.ms),
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
    );
  }

  // Funciones helper para responsive design
  double _getPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 32.0; // Desktop
    if (width > 768) return 24.0; // Tablet
    return 16.0; // Mobile
  }

  double _getAppBarFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 28.0; // Desktop
    if (width > 768) return 26.0; // Tablet
    return 24.0; // Mobile
  }

  int _getGridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4; // Desktop
    if (width > 768) return 3; // Tablet
    return 2; // Mobile
  }

  double _getChildAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 2.8; // Desktop
    if (width > 768) return 2.6; // Tablet
    return 2.5; // Mobile
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

  Widget _buildInventoryGrid({int? crossAxisCount, double? childAspectRatio}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveCrossAxisCount =
            crossAxisCount ?? _getGridCrossAxisCount(context);
        final effectiveAspectRatio =
            childAspectRatio ?? _getChildAspectRatio(context);

        return GridView.count(
          crossAxisCount: effectiveCrossAxisCount,
          childAspectRatio: effectiveAspectRatio,
          crossAxisSpacing: constraints.maxWidth > 768 ? 16 : 10,
          mainAxisSpacing: constraints.maxWidth > 768 ? 16 : 10,
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
      },
    );
  }

  Widget _buildInventoryCard(String title, String subtitle, IconData icon) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 200;

        return Card(
          color: cardColor,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(isLargeScreen ? 16.0 : 12.0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isLargeScreen ? 12 : 8),
                  decoration: BoxDecoration(
                    color: secondaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                        icon,
                        color: secondaryColor,
                        size: isLargeScreen ? 28 : 24,
                      )
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
                ),
                SizedBox(width: isLargeScreen ? 16 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: isLargeScreen ? 18 : 16,
                              color: primaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 400.ms)
                          .slideX(begin: 0.2, end: 0),
                      SizedBox(height: 4),
                      Text(
                            subtitle,
                            style: GoogleFonts.poppins(
                              fontSize: isLargeScreen ? 16 : 14,
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
      },
    );
  }

  Widget _buildRiskGrid({int? crossAxisCount, double? childAspectRatio}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveCrossAxisCount =
            crossAxisCount ?? _getGridCrossAxisCount(context);
        final effectiveAspectRatio =
            childAspectRatio ?? _getChildAspectRatio(context);

        return GridView.count(
          crossAxisCount: effectiveCrossAxisCount,
          childAspectRatio: effectiveAspectRatio,
          crossAxisSpacing: constraints.maxWidth > 768 ? 16 : 10,
          mainAxisSpacing: constraints.maxWidth > 768 ? 16 : 10,
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
                .shimmer(
                  duration: 1200.ms,
                  color: Colors.orange.withOpacity(0.3),
                ),
            _buildRiskCard('Colmena 4', 'Bajo Riesgo', Colors.green)
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms)
                .slideY(begin: 0.2, end: 0),
          ],
        );
      },
    );
  }

  Widget _buildRiskCard(String colmena, String estado, Color color) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 200;

        return Card(
          color: color.withOpacity(0.15),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(isLargeScreen ? 16.0 : 12.0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isLargeScreen ? 12 : 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                        Icons.bug_report,
                        color: color,
                        size: isLargeScreen ? 28 : 24,
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
                                ? const Offset(1.2, 1.2)
                                : const Offset(1.1, 1.1),
                        duration: 1000.ms,
                      ),
                ),
                SizedBox(width: isLargeScreen ? 16 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                            colmena,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: isLargeScreen ? 18 : 16,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 400.ms)
                          .slideX(begin: 0.2, end: 0),
                      SizedBox(height: 4),
                      Text(
                            estado,
                            style: GoogleFonts.poppins(
                              fontSize: isLargeScreen ? 16 : 14,
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
      },
    );
  }

  Widget _buildDashboardSummary() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 768;

        return Card(
          elevation: 4,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(
              isDesktop
                  ? 32.0
                  : isTablet
                  ? 24.0
                  : 20.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                          Icons.headphones_battery_rounded,
                          color: secondaryColor,
                          size: isDesktop ? 32 : 28,
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
                            fontSize:
                                isDesktop
                                    ? 28
                                    : isTablet
                                    ? 26
                                    : 24,
                            color: primaryColor,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 600.ms)
                        .slideX(begin: 0.2, end: 0),
                  ],
                ),
                SizedBox(height: isDesktop ? 32 : 20),

                // Layout responsive para los elementos del resumen
                isDesktop
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _buildSummaryItems(),
                    )
                    : isTablet
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _buildSummaryItems(),
                    )
                    : Column(
                      children:
                          _buildSummaryItems()
                              .map(
                                (item) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: item,
                                ),
                              )
                              .toList(),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildSummaryItems() {
    return [
      _buildSummaryItem('Inspecciones', '120', Icons.search)
          .animate()
          .fadeIn(delay: 400.ms, duration: 600.ms)
          .slideY(begin: 0.2, end: 0),
      _buildSummaryItem('Reinas Reemplazadas', '8', Icons.change_circle)
          .animate()
          .fadeIn(delay: 600.ms, duration: 600.ms)
          .slideY(begin: 0.2, end: 0),
      _buildSummaryItem('Colmenas en Riesgo', '5', Icons.warning)
          .animate()
          .fadeIn(delay: 800.ms, duration: 600.ms)
          .slideY(begin: 0.2, end: 0)
          .then(delay: 500.ms)
          .shimmer(duration: 1200.ms, color: Colors.red.withOpacity(0.3)),
    ];
  }

  Widget _buildSummaryItem(String title, String value, IconData icon) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = MediaQuery.of(context).size.width > 768;

        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(isLargeScreen ? 16 : 12),
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                    icon,
                    color: secondaryColor,
                    size: isLargeScreen ? 28 : 24,
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
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
                    fontSize: isLargeScreen ? 26 : 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                )
                .animate()
                .fadeIn(delay: 200.ms)
                .custom(
                  builder:
                      (context, value, child) => Transform.scale(
                        scale: 1.0 + (0.2 * value),
                        child: child,
                      ),
                  duration: 600.ms,
                  curve: Curves.easeOut,
                ),
            SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: isLargeScreen ? 14 : 12,
                color: Colors.grey[600],
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
          ],
        );
      },
    );
  }

  Widget _buildGeneralStatus() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 768;

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: cardColor,
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.all(isLargeScreen ? 24.0 : 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                          Icons.analytics,
                          color: primaryColor,
                          size: isLargeScreen ? 28 : 24,
                        )
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
                            fontSize: isLargeScreen ? 22 : 20,
                            color: primaryColor,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 400.ms)
                        .slideX(begin: 0.2, end: 0),
                  ],
                ),
                SizedBox(height: isLargeScreen ? 24 : 20),
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
                          value: 0.8 * value,
                          backgroundColor: Colors.red.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green,
                          ),
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
      },
    );
  }

  Widget _buildStatusInfo(String title, String value, Color color) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = MediaQuery.of(context).size.width > 768;

        return Column(
          children: [
            Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: isLargeScreen ? 32 : 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                )
                .animate()
                .fadeIn(duration: 600.ms)
                .custom(
                  builder:
                      (context, value, child) => Transform.scale(
                        scale: 1.0 + (0.3 * value),
                        child: child,
                      ),
                  duration: 800.ms,
                  curve: Curves.elasticOut,
                ),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: isLargeScreen ? 16 : 14,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          ],
        );
      },
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 768;

        return InkWell(
          onTap: () {
            // Navegación a pantalla de detalle
          },
          child: Padding(
            padding: EdgeInsets.all(isLargeScreen ? 20.0 : 16.0),
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
                SizedBox(width: isLargeScreen ? 20 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                            'Inspección del $fecha',
                            style: GoogleFonts.poppins(
                              fontSize: isLargeScreen ? 18 : 16,
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
                              fontSize: isLargeScreen ? 16 : 14,
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
                              fontSize: isLargeScreen ? 16 : 14,
                              color: Colors.grey[600],
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 400.ms)
                          .slideX(begin: 0.1, end: 0),
                    ],
                  ),
                ),
                Icon(
                      Icons.arrow_forward_ios,
                      size: isLargeScreen ? 18 : 16,
                      color: Colors.grey,
                    )
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
      },
    );
  }
}
