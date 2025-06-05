import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:soft_bee/app/features/admin/inventory/page/salida_inventario_page.dart';

// Enum para definir los tipos de pantalla
enum ScreenType { mobile, tablet, desktop }

// Clase para manejar breakpoints responsivos
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1200;

  static ScreenType getScreenType(double width) {
    if (width < mobile) return ScreenType.mobile;
    if (width < desktop) return ScreenType.tablet;
    return ScreenType.desktop;
  }
}

// Widget responsivo principal
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenType = ResponsiveBreakpoints.getScreenType(
          constraints.maxWidth,
        );

        switch (screenType) {
          case ScreenType.mobile:
            return mobile;
          case ScreenType.tablet:
            return tablet ?? desktop;
          case ScreenType.desktop:
            return desktop;
        }
      },
    );
  }
}

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
    return Scaffold(
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
    );
  }

  // Layout para móviles
  Widget _buildMobileLayout() {
    final stats = estadisticas;

    return Container(
      color: Color(0xFFFFF8E1),
      child: Column(
        children: [
          _buildHeader(ScreenType.mobile),
          _buildEstadisticas(stats, ScreenType.mobile),
          _buildFiltrosYBusqueda(ScreenType.mobile),
          SizedBox(height: 16),
          Expanded(child: _buildListaSalidas(ScreenType.mobile)),
        ],
      ),
    );
  }

  // Layout para tablets
  Widget _buildTabletLayout() {
    final stats = estadisticas;

    return Container(
      color: Color(0xFFFFF8E1),
      child: Column(
        children: [
          _buildHeader(ScreenType.tablet),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Panel lateral con estadísticas
                  Container(width: 280, child: _buildSidePanel(stats)),
                  SizedBox(width: 16),
                  // Contenido principal
                  Expanded(
                    child: Column(
                      children: [
                        _buildFiltrosYBusqueda(ScreenType.tablet),
                        SizedBox(height: 16),
                        Expanded(child: _buildListaSalidas(ScreenType.tablet)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Layout para desktop
  Widget _buildDesktopLayout() {
    final stats = estadisticas;

    return Container(
      color: Color(0xFFFFF8E1),
      child: Column(
        children: [
          _buildHeader(ScreenType.desktop),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Panel lateral con estadísticas
                  Container(width: 350, child: _buildSidePanel(stats)),
                  SizedBox(width: 24),
                  // Contenido principal
                  Expanded(
                    child: Column(
                      children: [
                        _buildFiltrosYBusqueda(ScreenType.desktop),
                        SizedBox(height: 24),
                        Expanded(child: _buildListaSalidas(ScreenType.desktop)),
                      ],
                    ),
                  ),
                  SizedBox(width: 24),
                  // Panel de análisis (solo desktop)
                  Container(width: 300, child: _buildAnalysisPanel()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header responsivo
  Widget _buildHeader(ScreenType screenType) {
    final isDesktop = screenType == ScreenType.desktop;
    final isTablet = screenType == ScreenType.tablet;

    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
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
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: isDesktop ? 28 : 24,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Historial de Salidas',
                    style: GoogleFonts.poppins(
                      fontSize:
                          isDesktop
                              ? 32
                              : isTablet
                              ? 28
                              : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Registro completo de movimientos',
                    style: GoogleFonts.poppins(
                      fontSize: isDesktop ? 16 : 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 16 : 12,
                vertical: isDesktop ? 8 : 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history,
                    color: Colors.amber[700],
                    size: isDesktop ? 20 : 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${widget.salidas.length}',
                    style: GoogleFonts.poppins(
                      color: Colors.amber[700],
                      fontWeight: FontWeight.bold,
                      fontSize: isDesktop ? 16 : 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Estadísticas responsivas
  Widget _buildEstadisticas(Map<String, dynamic> stats, ScreenType screenType) {
    final isDesktop = screenType == ScreenType.desktop;
    final isTablet = screenType == ScreenType.tablet;

    // En tablet y desktop, las estadísticas van en el panel lateral
    if (isTablet || isDesktop) {
      return SizedBox.shrink();
    }

    return Container(
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
                  screenType,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Insumos',
                  stats['insumosUnicos'].toString(),
                  Icons.inventory_2,
                  Colors.green,
                  screenType,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Personas',
                  stats['personasUnicas'].toString(),
                  Icons.people,
                  Colors.orange,
                  screenType,
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
        );
  }

  // Panel lateral para tablet y desktop
  Widget _buildSidePanel(Map<String, dynamic> stats) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estadísticas de Salidas',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 20),
            _buildSummaryCard(
              'Total de Salidas',
              stats['totalSalidas'].toString(),
              Icons.exit_to_app,
              Colors.blue,
            ),
            SizedBox(height: 12),
            _buildSummaryCard(
              'Insumos Diferentes',
              stats['insumosUnicos'].toString(),
              Icons.inventory_2,
              Colors.green,
            ),
            SizedBox(height: 12),
            _buildSummaryCard(
              'Personas Involucradas',
              stats['personasUnicas'].toString(),
              Icons.people,
              Colors.orange,
            ),
            SizedBox(height: 12),
            _buildSummaryCard(
              'Salidas Filtradas',
              '${salidasFiltradas.length}',
              Icons.filter_list,
              Colors.purple,
            ),
            SizedBox(height: 24),
            Text(
              'Filtro Activo',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.filter_alt, color: Colors.amber[700], size: 20),
                  SizedBox(width: 8),
                  Text(
                    _getFiltroTexto(),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.amber[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Panel de análisis para desktop
  Widget _buildAnalysisPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Análisis Detallado',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 20),
            _buildAnalysisItem(
              'Insumo más solicitado',
              _getInsumoMasSolicitado(),
            ),
            SizedBox(height: 16),
            _buildAnalysisItem('Persona más activa', _getPersonaMasActiva()),
            SizedBox(height: 16),
            _buildAnalysisItem(
              'Promedio diario',
              '${_getPromedioDiario()} salidas',
            ),
            SizedBox(height: 16),
            _buildAnalysisItem('Última salida', _getUltimaSalida()),
            SizedBox(height: 24),
            Text(
              'Tendencias',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            ..._buildTendencias(),
          ],
        ),
      ),
    );
  }

  // Filtros y búsqueda responsivos
  Widget _buildFiltrosYBusqueda(ScreenType screenType) {
    final isDesktop = screenType == ScreenType.desktop;
    final isTablet = screenType == ScreenType.tablet;
    final padding = (isDesktop || isTablet) ? 0.0 : 16.0;

    return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: padding,
            vertical: padding / 2,
          ),
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
                      fontSize: isDesktop ? 16 : 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.amber,
                      size: isDesktop ? 24 : 20,
                    ),
                    suffixIcon:
                        searchController.text.isNotEmpty
                            ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.grey,
                                size: isDesktop ? 24 : 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  searchController.clear();
                                });
                              },
                            )
                            : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: isDesktop ? 20 : 16,
                      horizontal: 16,
                    ),
                  ),
                  style: GoogleFonts.poppins(fontSize: isDesktop ? 16 : 14),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              SizedBox(height: 16),

              // Filtros de fecha
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFiltroChip('Todos', 'todos', screenType),
                    SizedBox(width: 8),
                    _buildFiltroChip('Hoy', 'hoy', screenType),
                    SizedBox(width: 8),
                    _buildFiltroChip('Esta semana', 'semana', screenType),
                    SizedBox(width: 8),
                    _buildFiltroChip('Este mes', 'mes', screenType),
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
        );
  }

  // Lista de salidas responsiva
  Widget _buildListaSalidas(ScreenType screenType) {
    final salidas = salidasFiltradas;
    final isDesktop = screenType == ScreenType.desktop;
    final isTablet = screenType == ScreenType.tablet;

    if (salidas.isEmpty) {
      return _buildEmptyState(screenType);
    }

    if (isDesktop) {
      return _buildDesktopTable(salidas);
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: (isDesktop || isTablet) ? 0 : 16,
        vertical: 8,
      ),
      itemCount: salidas.length,
      itemBuilder: (context, index) {
        return _buildSalidaCard(salidas[index], index, screenType);
      },
    );
  }

  // Card de salida responsivo
  Widget _buildSalidaCard(
    SalidaInsumo salida,
    int index,
    ScreenType screenType,
  ) {
    final isTablet = screenType == ScreenType.tablet;
    final cardPadding = isTablet ? EdgeInsets.all(12) : EdgeInsets.all(16);
    final titleFontSize = isTablet ? 14.0 : 16.0;
    final subtitleFontSize = isTablet ? 12.0 : 14.0;

    return Card(
          margin: EdgeInsets.symmetric(vertical: isTablet ? 4 : 6),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: cardPadding,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isTablet ? 8 : 10),
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.amber[700],
                    size: isTablet ? 20 : 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        salida.nombreInsumo,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: titleFontSize,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: isTablet ? 14 : 16,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Text(
                            salida.persona,
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: subtitleFontSize,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(
                            Icons.calendar_today,
                            size: isTablet ? 14 : 16,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Text(
                            DateFormat('dd/MM/yy').format(salida.fecha),
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: subtitleFontSize,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Text(
                    '${salida.cantidad}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                      fontSize: isTablet ? 12 : 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: Duration(milliseconds: index * 50))
        .slideX(
          begin: 0.2,
          end: 0,
          duration: 600.ms,
          curve: Curves.easeOutQuad,
        );
  }

  // Tabla para desktop
  Widget _buildDesktopTable(List<SalidaInsumo> salidas) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header de la tabla
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Insumo',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.amber[800],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Cantidad',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.amber[800],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Persona',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.amber[800],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Fecha y Hora',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.amber[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Contenido de la tabla
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: salidas.length,
              itemBuilder: (context, index) {
                final salida = salidas[index];
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.amber[100],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.inventory_2,
                                color: Colors.amber[700],
                                size: 16,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                salida.nombreInsumo,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Text(
                            salida.cantidad,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                salida.persona,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('dd/MM/yyyy').format(salida.fecha),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                            Text(
                              DateFormat('HH:mm').format(salida.fecha),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widgets auxiliares
  Widget _buildStatCard(
    String titulo,
    String valor,
    IconData icono,
    Color color,
    ScreenType screenType,
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
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
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
    );
  }

  Widget _buildFiltroChip(String texto, String valor, ScreenType screenType) {
    final selected = filtroSeleccionado == valor;
    final isDesktop = screenType == ScreenType.desktop;

    return ChoiceChip(
      label: Text(
        texto,
        style: GoogleFonts.poppins(
          color: selected ? Colors.white : Colors.amber[800],
          fontWeight: FontWeight.w600,
          fontSize: isDesktop ? 14 : 12,
        ),
      ),
      selected: selected,
      selectedColor: Colors.amber,
      backgroundColor: Colors.amber[100],
      padding:
          isDesktop
              ? EdgeInsets.symmetric(horizontal: 12, vertical: 8)
              : EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      onSelected: (bool seleccionado) {
        setState(() {
          filtroSeleccionado = seleccionado ? valor : 'todos';
        });
      },
    );
  }

  Widget _buildAnalysisItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ScreenType screenType) {
    final isDesktop = screenType == ScreenType.desktop;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: isDesktop ? 80 : 64,
            color: Colors.amber[300],
          ),
          SizedBox(height: 16),
          Text(
            'No se encontraron salidas',
            style: GoogleFonts.poppins(
              fontSize: isDesktop ? 20 : 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Text(
            'Intenta ajustar los filtros o términos de búsqueda',
            style: GoogleFonts.poppins(
              fontSize: isDesktop ? 16 : 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  List<Widget> _buildTendencias() {
    List<Widget> tendencias = [];

    final salidas = salidasFiltradas;
    if (salidas.length > 1) {
      final hoy =
          salidas
              .where(
                (s) =>
                    s.fecha.day == DateTime.now().day &&
                    s.fecha.month == DateTime.now().month &&
                    s.fecha.year == DateTime.now().year,
              )
              .length;

      final ayer =
          salidas
              .where(
                (s) =>
                    s.fecha.day ==
                        DateTime.now().subtract(Duration(days: 1)).day &&
                    s.fecha.month == DateTime.now().month &&
                    s.fecha.year == DateTime.now().year,
              )
              .length;

      if (hoy > ayer) {
        tendencias.add(
          _buildTendencia(
            'Actividad en aumento',
            Icons.trending_up,
            Colors.green,
          ),
        );
      } else if (hoy < ayer) {
        tendencias.add(
          _buildTendencia(
            'Actividad en descenso',
            Icons.trending_down,
            Colors.red,
          ),
        );
      } else {
        tendencias.add(
          _buildTendencia(
            'Actividad estable',
            Icons.trending_flat,
            Colors.blue,
          ),
        );
      }
    }

    if (tendencias.isEmpty) {
      tendencias.add(
        _buildTendencia('Datos insuficientes', Icons.info, Colors.grey),
      );
    }

    return tendencias;
  }

  Widget _buildTendencia(String mensaje, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              mensaje,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Métodos auxiliares para análisis
  String _getFiltroTexto() {
    switch (filtroSeleccionado) {
      case 'hoy':
        return 'Salidas de hoy';
      case 'semana':
        return 'Última semana';
      case 'mes':
        return 'Este mes';
      default:
        return 'Todas las salidas';
    }
  }

  String _getInsumoMasSolicitado() {
    if (salidasFiltradas.isEmpty) return 'Sin datos';

    Map<String, int> conteo = {};
    for (var salida in salidasFiltradas) {
      conteo[salida.nombreInsumo] = (conteo[salida.nombreInsumo] ?? 0) + 1;
    }

    if (conteo.isEmpty) return 'Sin datos';

    var sorted =
        conteo.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  String _getPersonaMasActiva() {
    if (salidasFiltradas.isEmpty) return 'Sin datos';

    Map<String, int> conteo = {};
    for (var salida in salidasFiltradas) {
      conteo[salida.persona] = (conteo[salida.persona] ?? 0) + 1;
    }

    if (conteo.isEmpty) return 'Sin datos';

    var sorted =
        conteo.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  double _getPromedioDiario() {
    if (salidasFiltradas.isEmpty) return 0.0;

    final dias =
        DateTime.now().difference(salidasFiltradas.first.fecha).inDays + 1;
    return salidasFiltradas.length / dias;
  }

  String _getUltimaSalida() {
    if (salidasFiltradas.isEmpty) return 'Sin salidas';

    final ultima = salidasFiltradas.last;
    final ahora = DateTime.now();
    final diferencia = ahora.difference(ultima.fecha);

    if (diferencia.inDays > 0) {
      return 'Hace ${diferencia.inDays} días';
    } else if (diferencia.inHours > 0) {
      return 'Hace ${diferencia.inHours} horas';
    } else {
      return 'Hace ${diferencia.inMinutes} minutos';
    }
  }
}
