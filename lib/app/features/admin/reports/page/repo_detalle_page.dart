import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Clase principal del dashboard
class InformesHistorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ApiarioDashboard();
  }
}

// Configuración de breakpoints responsive
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1600;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobile &&
      MediaQuery.of(context).size.width < desktop;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;

  static bool isLargeDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= largeDesktop;
}

// Configuración de tema y constantes
class ApiarioTheme {
  static const Color primaryColor = Color(0xFF8D6E63);
  static const Color secondaryColor = Color(0xFFFFA000);
  static const Color backgroundColor = Color(0xFFFFF8E1);
  static const Color cardColor = Color(0xFFFFECB3);
  static const Color successColor = Colors.green;
  static const Color warningColor = Colors.orange;
  static const Color dangerColor = Colors.red;

  static TextStyle get titleStyle =>
      GoogleFonts.concertOne(color: primaryColor, fontWeight: FontWeight.w500);

  static TextStyle get bodyStyle => GoogleFonts.poppins();

  // Responsive padding
  static double getPadding(BuildContext context) {
    if (ResponsiveBreakpoints.isLargeDesktop(context)) return 32.0;
    if (ResponsiveBreakpoints.isDesktop(context)) return 24.0;
    if (ResponsiveBreakpoints.isTablet(context)) return 20.0;
    return 16.0;
  }

  // Responsive font sizes
  static double getTitleFontSize(BuildContext context) {
    if (ResponsiveBreakpoints.isLargeDesktop(context)) return 32.0;
    if (ResponsiveBreakpoints.isDesktop(context)) return 28.0;
    if (ResponsiveBreakpoints.isTablet(context)) return 26.0;
    return 24.0;
  }

  static double getSubtitleFontSize(BuildContext context) {
    if (ResponsiveBreakpoints.isLargeDesktop(context)) return 24.0;
    if (ResponsiveBreakpoints.isDesktop(context)) return 22.0;
    if (ResponsiveBreakpoints.isTablet(context)) return 20.0;
    return 18.0;
  }

  static double getBodyFontSize(BuildContext context) {
    if (ResponsiveBreakpoints.isLargeDesktop(context)) return 18.0;
    if (ResponsiveBreakpoints.isDesktop(context)) return 16.0;
    if (ResponsiveBreakpoints.isTablet(context)) return 15.0;
    return 14.0;
  }
}

// Modelos de datos (igual que antes)
class InventoryItem {
  final String name;
  final int quantity;
  final IconData icon;
  final String? description;
  final String category;

  InventoryItem({
    required this.name,
    required this.quantity,
    required this.icon,
    this.description,
    required this.category,
  });
}

class ColmenaStatus {
  final String name;
  final String status;
  final Color color;
  final DateTime lastInspection;
  final String? notes;
  final double productivity;

  ColmenaStatus({
    required this.name,
    required this.status,
    required this.color,
    required this.lastInspection,
    this.notes,
    required this.productivity,
  });
}

class InspectionRecord {
  final DateTime date;
  final String status;
  final String observations;
  final Color statusColor;
  final String inspector;
  final List<String> actions;

  InspectionRecord({
    required this.date,
    required this.status,
    required this.observations,
    required this.statusColor,
    required this.inspector,
    required this.actions,
  });
}

// Datos de ejemplo expandidos
class ApiarioData {
  static List<InventoryItem> get inventoryItems => [
    InventoryItem(
      name: 'Ahumador',
      quantity: 5,
      icon: Icons.local_fire_department,
      description: 'Para calmar las abejas durante inspecciones',
      category: 'Herramientas',
    ),
    InventoryItem(
      name: 'Trajes de Apicultor',
      quantity: 10,
      icon: Icons.security,
      description: 'Protección completa para apicultores',
      category: 'Protección',
    ),
    InventoryItem(
      name: 'Guantes',
      quantity: 20,
      icon: Icons.pan_tool,
      description: 'Guantes de cuero resistentes',
      category: 'Protección',
    ),
    InventoryItem(
      name: 'Herramientas',
      quantity: 15,
      icon: Icons.build,
      description: 'Palancas, cepillos y herramientas varias',
      category: 'Herramientas',
    ),
    InventoryItem(
      name: 'Marcos',
      quantity: 150,
      icon: Icons.crop_landscape,
      description: 'Marcos de madera para panales',
      category: 'Estructura',
    ),
    InventoryItem(
      name: 'Alimentadores',
      quantity: 25,
      icon: Icons.local_dining,
      description: 'Para alimentación suplementaria',
      category: 'Alimentación',
    ),
    InventoryItem(
      name: 'Medicamentos',
      quantity: 8,
      icon: Icons.medical_services,
      description: 'Tratamientos para varroa y enfermedades',
      category: 'Medicina',
    ),
    InventoryItem(
      name: 'Cera Estampada',
      quantity: 50,
      icon: Icons.grid_on,
      description: 'Láminas de cera para nuevos panales',
      category: 'Estructura',
    ),
  ];

  static List<ColmenaStatus> get colmenas => [
    ColmenaStatus(
      name: 'Colmena Alpha',
      status: 'Excelente',
      color: ApiarioTheme.successColor,
      lastInspection: DateTime.now().subtract(Duration(days: 3)),
      notes: 'Producción alta, reina activa',
      productivity: 0.95,
    ),
    ColmenaStatus(
      name: 'Colmena Beta',
      status: 'Alto Riesgo',
      color: ApiarioTheme.dangerColor,
      lastInspection: DateTime.now().subtract(Duration(days: 1)),
      notes: 'Posible infestación de varroa',
      productivity: 0.45,
    ),
    ColmenaStatus(
      name: 'Colmena Gamma',
      status: 'Moderado',
      color: ApiarioTheme.warningColor,
      lastInspection: DateTime.now().subtract(Duration(days: 5)),
      notes: 'Población baja, necesita seguimiento',
      productivity: 0.70,
    ),
    ColmenaStatus(
      name: 'Colmena Delta',
      status: 'Bueno',
      color: ApiarioTheme.successColor,
      lastInspection: DateTime.now().subtract(Duration(days: 2)),
      notes: 'Desarrollo normal',
      productivity: 0.85,
    ),
    ColmenaStatus(
      name: 'Colmena Epsilon',
      status: 'Crítico',
      color: ApiarioTheme.dangerColor,
      lastInspection: DateTime.now().subtract(Duration(hours: 12)),
      notes: 'Reina ausente, requiere intervención inmediata',
      productivity: 0.20,
    ),
    ColmenaStatus(
      name: 'Colmena Zeta',
      status: 'Excelente',
      color: ApiarioTheme.successColor,
      lastInspection: DateTime.now().subtract(Duration(days: 4)),
      notes: 'Nueva colmena, desarrollo prometedor',
      productivity: 0.90,
    ),
  ];

  static List<InspectionRecord> get inspectionHistory => [
    InspectionRecord(
      date: DateTime.now().subtract(Duration(days: 1)),
      status: 'Crítico',
      observations: 'Colmena Epsilon sin reina. Iniciado proceso de reemplazo.',
      statusColor: ApiarioTheme.dangerColor,
      inspector: 'Dr. García',
      actions: ['Reemplazo de reina', 'Monitoreo intensivo'],
    ),
    InspectionRecord(
      date: DateTime.now().subtract(Duration(days: 3)),
      status: 'Alerta',
      observations: 'Detectada varroa en Colmena Beta. Aplicado tratamiento.',
      statusColor: ApiarioTheme.warningColor,
      inspector: 'Ing. Martínez',
      actions: ['Tratamiento varroa', 'Seguimiento semanal'],
    ),
    InspectionRecord(
      date: DateTime.now().subtract(Duration(days: 7)),
      status: 'Normal',
      observations: 'Inspección rutinaria. Todas las colmenas en buen estado.',
      statusColor: ApiarioTheme.successColor,
      inspector: 'Dr. García',
      actions: ['Inspección general', 'Limpieza'],
    ),
    InspectionRecord(
      date: DateTime.now().subtract(Duration(days: 14)),
      status: 'Normal',
      observations: 'Cosecha de miel completada. Rendimiento excelente.',
      statusColor: ApiarioTheme.successColor,
      inspector: 'Ing. Martínez',
      actions: ['Cosecha', 'Preparación invierno'],
    ),
  ];
}

// Widget principal del dashboard
class ApiarioDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ApiarioTheme.backgroundColor,
      appBar: _buildAppBar(context),
      body: _buildResponsiveBody(context),
      floatingActionButton: _buildFloatingActionButton(context),
      drawer:
          ResponsiveBreakpoints.isMobile(context)
              ? _buildDrawer(context)
              : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 4,
      title: Text(
            ResponsiveBreakpoints.isMobile(context)
                ? 'Apiario Dashboard'
                : 'Dashboard del Apiario',
            style: ApiarioTheme.titleStyle.copyWith(
              color: Colors.white,
              fontSize: ApiarioTheme.getTitleFontSize(context),
            ),
          )
          .animate()
          .fadeIn(duration: 600.ms)
          .slideX(begin: -0.2, end: 0, curve: Curves.easeOutQuad),
      backgroundColor: ApiarioTheme.primaryColor,
      centerTitle: true,
      actions:
          ResponsiveBreakpoints.isMobile(context)
              ? [IconButton(icon: Icon(Icons.refresh), onPressed: () {})]
              : [
                IconButton(icon: Icon(Icons.refresh), onPressed: () {}),
                IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
                IconButton(icon: Icon(Icons.settings), onPressed: () {}),
              ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: ApiarioTheme.primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.hive, color: Colors.white, size: 48),
                SizedBox(height: 8),
                Text(
                  'Apiario Manager',
                  style: ApiarioTheme.titleStyle.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Gestión Integral',
                  style: ApiarioTheme.bodyStyle.copyWith(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.inventory),
            title: Text('Inventario'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.home_work),
            title: Text('Colmenas'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Historial'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.analytics),
            title: Text('Reportes'),
            onTap: () => Navigator.pop(context),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configuración'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveBody(BuildContext context) {
    if (ResponsiveBreakpoints.isMobile(context)) {
      return _buildMobileLayout(context);
    } else if (ResponsiveBreakpoints.isTablet(context)) {
      return _buildTabletLayout(context);
    } else {
      return _buildDesktopLayout(context);
    }
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ApiarioTheme.getPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resumen compacto para móvil
          DashboardSummaryCard(isMobile: true),
          SizedBox(height: 20),

          // Alertas críticas primero en móvil
          AlertsWidget(),
          SizedBox(height: 20),

          // Estado de colmenas (1 columna)
          ColmenasStatusSection(crossAxisCount: 1),
          SizedBox(height: 20),

          // Inventario (1 columna)
          InventorySection(crossAxisCount: 1),
          SizedBox(height: 20),

          // Clima compacto
          WeatherWidget(isCompact: true),
          SizedBox(height: 20),

          // Historial reducido
          InspectionHistorySection(maxItems: 3),
          SizedBox(height: 20),

          // Gráfico simplificado
          ProductionChart(isCompact: true),
          SizedBox(height: 100), // Espacio para FAB
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ApiarioTheme.getPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resumen principal
          DashboardSummaryCard(),
          SizedBox(height: 24),

          // Layout de dos columnas para tablet
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Columna izquierda
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    ColmenasStatusSection(crossAxisCount: 1),
                    SizedBox(height: 20),
                    AlertsWidget(),
                  ],
                ),
              ),
              SizedBox(width: 20),

              // Columna derecha
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    InventorySection(crossAxisCount: 1),
                    SizedBox(height: 20),
                    WeatherWidget(),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // Secciones de ancho completo
          InspectionHistorySection(),
          SizedBox(height: 24),
          ProductionChart(),
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ApiarioTheme.getPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resumen principal
          DashboardSummaryCard(),
          SizedBox(height: 32),

          // Layout de tres columnas para desktop
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Columna izquierda (30%)
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    InventorySection(crossAxisCount: 1),
                    SizedBox(height: 24),
                    WeatherWidget(),
                  ],
                ),
              ),
              SizedBox(width: 24),

              // Columna central (40%)
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    ColmenasStatusSection(
                      crossAxisCount:
                          ResponsiveBreakpoints.isLargeDesktop(context) ? 2 : 1,
                    ),
                    SizedBox(height: 24),
                    ProductionChart(),
                  ],
                ),
              ),
              SizedBox(width: 24),

              // Columna derecha (30%)
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    AlertsWidget(),
                    SizedBox(height: 24),
                    InspectionHistorySection(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    if (ResponsiveBreakpoints.isMobile(context)) {
      return FloatingActionButton(
        onPressed: () {},
        backgroundColor: ApiarioTheme.secondaryColor,
        child: Icon(Icons.add),
      );
    } else {
      return FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: ApiarioTheme.secondaryColor,
        icon: Icon(Icons.add),
        label: Text('Nueva Inspección'),
      );
    }
  }
}

// Widget para el resumen del dashboard
class DashboardSummaryCard extends StatelessWidget {
  final bool isMobile;

  const DashboardSummaryCard({this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(ApiarioTheme.getPadding(context)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.dashboard,
                  color: ApiarioTheme.secondaryColor,
                  size: isMobile ? 24 : 32,
                ),
                SizedBox(width: 12),
                Flexible(
                  child: Text(
                    'Resumen del Apiario',
                    style: ApiarioTheme.titleStyle.copyWith(
                      fontSize: ApiarioTheme.getSubtitleFontSize(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Layout responsive para items del resumen
            _buildSummaryLayout(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryLayout(BuildContext context) {
    final items = _buildSummaryItems(context);

    if (ResponsiveBreakpoints.isMobile(context)) {
      // En móvil: 2x2 grid
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: items,
      );
    } else if (ResponsiveBreakpoints.isTablet(context)) {
      // En tablet: fila horizontal
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.map((item) => Expanded(child: item)).toList(),
      );
    } else {
      // En desktop: fila horizontal con más espacio
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items,
      );
    }
  }

  List<Widget> _buildSummaryItems(BuildContext context) {
    final colmenasSaludables =
        ApiarioData.colmenas
            .where((c) => c.color == ApiarioTheme.successColor)
            .length;
    final colmenasRiesgo =
        ApiarioData.colmenas
            .where((c) => c.color != ApiarioTheme.successColor)
            .length;

    return [
      _SummaryItem(
        title: 'Total Colmenas',
        value: '${ApiarioData.colmenas.length}',
        icon: Icons.home,
        color: ApiarioTheme.primaryColor,
      ),
      _SummaryItem(
        title: 'Saludables',
        value: '$colmenasSaludables',
        icon: Icons.check_circle,
        color: ApiarioTheme.successColor,
      ),
      _SummaryItem(
        title: 'En Riesgo',
        value: '$colmenasRiesgo',
        icon: Icons.warning,
        color: ApiarioTheme.dangerColor,
      ),
      _SummaryItem(
        title: 'Última Inspección',
        value:
            '${DateTime.now().difference(ApiarioData.inspectionHistory.first.date).inHours}h',
        icon: Icons.schedule,
        color: ApiarioTheme.secondaryColor,
      ),
    ];
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: isMobile ? 20 : 28),
          SizedBox(height: 8),
          Text(
            value,
            style: ApiarioTheme.bodyStyle.copyWith(
              fontSize: isMobile ? 18 : 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: ApiarioTheme.bodyStyle.copyWith(
              fontSize: isMobile ? 10 : 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Sección de inventario responsive
class InventorySection extends StatelessWidget {
  final int crossAxisCount;

  const InventorySection({this.crossAxisCount = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Inventario de Insumos', icon: Icons.inventory_2),
        SizedBox(height: 16),

        // Grid responsive
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getEffectiveCrossAxisCount(context),
            childAspectRatio: _getChildAspectRatio(context),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: ApiarioData.inventoryItems.length,
          itemBuilder: (context, index) {
            final item = ApiarioData.inventoryItems[index];
            return _InventoryCard(item: item);
          },
        ),
      ],
    );
  }

  int _getEffectiveCrossAxisCount(BuildContext context) {
    if (ResponsiveBreakpoints.isMobile(context)) return 1;
    if (ResponsiveBreakpoints.isTablet(context)) return crossAxisCount;
    if (ResponsiveBreakpoints.isLargeDesktop(context)) return crossAxisCount;
    return crossAxisCount;
  }

  double _getChildAspectRatio(BuildContext context) {
    if (ResponsiveBreakpoints.isMobile(context)) return 3.5;
    if (ResponsiveBreakpoints.isTablet(context)) return 3.0;
    return 3.2;
  }
}

class _InventoryCard extends StatelessWidget {
  final InventoryItem item;

  const _InventoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    return Card(
      color: ApiarioTheme.cardColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showItemDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 8 : 12),
                decoration: BoxDecoration(
                  color: ApiarioTheme.secondaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item.icon,
                  color: ApiarioTheme.secondaryColor,
                  size: isMobile ? 20 : 28,
                ),
              ),
              SizedBox(width: isMobile ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.name,
                      style: ApiarioTheme.bodyStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: ApiarioTheme.getBodyFontSize(context),
                        color: ApiarioTheme.primaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Cantidad: ${item.quantity}',
                      style: ApiarioTheme.bodyStyle.copyWith(
                        fontSize: ApiarioTheme.getBodyFontSize(context) - 2,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (!isMobile && item.description != null) ...[
                      SizedBox(height: 2),
                      Text(
                        item.description!,
                        style: ApiarioTheme.bodyStyle.copyWith(
                          fontSize: ApiarioTheme.getBodyFontSize(context) - 4,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (!isMobile)
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showItemDetails(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(item.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Categoría: ${item.category}'),
                SizedBox(height: 8),
                Text('Cantidad disponible: ${item.quantity}'),
                if (item.description != null) ...[
                  SizedBox(height: 8),
                  Text('Descripción: ${item.description}'),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cerrar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Editar'),
              ),
            ],
          ),
    );
  }
}

// Sección de estado de colmenas responsive
class ColmenasStatusSection extends StatelessWidget {
  final int crossAxisCount;

  const ColmenasStatusSection({this.crossAxisCount = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Estado de Colmenas', icon: Icons.home_work),
        SizedBox(height: 16),

        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getEffectiveCrossAxisCount(context),
            childAspectRatio: _getChildAspectRatio(context),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: ApiarioData.colmenas.length,
          itemBuilder: (context, index) {
            final colmena = ApiarioData.colmenas[index];
            return _ColmenaCard(colmena: colmena);
          },
        ),
      ],
    );
  }

  int _getEffectiveCrossAxisCount(BuildContext context) {
    if (ResponsiveBreakpoints.isMobile(context)) return 1;
    return crossAxisCount;
  }

  double _getChildAspectRatio(BuildContext context) {
    if (ResponsiveBreakpoints.isMobile(context)) return 2.8;
    if (ResponsiveBreakpoints.isTablet(context)) return 2.5;
    return 2.2;
  }
}

class _ColmenaCard extends StatelessWidget {
  final ColmenaStatus colmena;

  const _ColmenaCard({required this.colmena});

  @override
  Widget build(BuildContext context) {
    final daysSinceInspection =
        DateTime.now().difference(colmena.lastInspection).inDays;
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    return Card(
      color: colmena.color.withOpacity(0.15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showColmenaDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isMobile ? 8 : 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.home,
                      color: colmena.color,
                      size: isMobile ? 20 : 28,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          colmena.name,
                          style: ApiarioTheme.bodyStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: ApiarioTheme.getBodyFontSize(context),
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          colmena.status,
                          style: ApiarioTheme.bodyStyle.copyWith(
                            fontSize: ApiarioTheme.getBodyFontSize(context) - 2,
                            color: colmena.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Barra de productividad
              Row(
                children: [
                  Text(
                    'Productividad: ',
                    style: ApiarioTheme.bodyStyle.copyWith(
                      fontSize: ApiarioTheme.getBodyFontSize(context) - 4,
                      color: Colors.grey[600],
                    ),
                  ),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: colmena.productivity,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(colmena.color),
                      minHeight: 4,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${(colmena.productivity * 100).toInt()}%',
                    style: ApiarioTheme.bodyStyle.copyWith(
                      fontSize: ApiarioTheme.getBodyFontSize(context) - 4,
                      fontWeight: FontWeight.bold,
                      color: colmena.color,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 4),
              Text(
                'Última inspección: hace $daysSinceInspection días',
                style: ApiarioTheme.bodyStyle.copyWith(
                  fontSize: ApiarioTheme.getBodyFontSize(context) - 4,
                  color: Colors.grey[600],
                ),
              ),

              if (!isMobile && colmena.notes != null) ...[
                SizedBox(height: 4),
                Text(
                  colmena.notes!,
                  style: ApiarioTheme.bodyStyle.copyWith(
                    fontSize: ApiarioTheme.getBodyFontSize(context) - 4,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showColmenaDetails(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(colmena.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Estado: ${colmena.status}'),
                SizedBox(height: 8),
                Text('Productividad: ${(colmena.productivity * 100).toInt()}%'),
                SizedBox(height: 8),
                Text(
                  'Última inspección: ${_formatDate(colmena.lastInspection)}',
                ),
                if (colmena.notes != null) ...[
                  SizedBox(height: 8),
                  Text('Notas: ${colmena.notes}'),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cerrar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Inspeccionar'),
              ),
            ],
          ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Widget para mostrar el clima responsive
class WeatherWidget extends StatelessWidget {
  final bool isCompact;

  const WeatherWidget({this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(ApiarioTheme.getPadding(context)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wb_sunny,
                  color: ApiarioTheme.secondaryColor,
                  size: isCompact ? 20 : 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Condiciones Climáticas',
                  style: ApiarioTheme.titleStyle.copyWith(
                    fontSize: ApiarioTheme.getSubtitleFontSize(context) - 4,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Layout responsive para items del clima
            isCompact || ResponsiveBreakpoints.isMobile(context)
                ? Column(
                  children: [
                    _WeatherItem('Temperatura', '24°C', Icons.thermostat),
                    SizedBox(height: 8),
                    _WeatherItem('Humedad', '65%', Icons.water_drop),
                    SizedBox(height: 8),
                    _WeatherItem('Viento', '12 km/h', Icons.air),
                  ],
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _WeatherItem('Temperatura', '24°C', Icons.thermostat),
                    _WeatherItem('Humedad', '65%', Icons.water_drop),
                    _WeatherItem('Viento', '12 km/h', Icons.air),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}

class _WeatherItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _WeatherItem(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 8 : 12),
      decoration: BoxDecoration(
        color: ApiarioTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: isMobile ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: ApiarioTheme.primaryColor,
            size: isMobile ? 20 : 24,
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: ApiarioTheme.bodyStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ApiarioTheme.getBodyFontSize(context),
                ),
              ),
              Text(
                label,
                style: ApiarioTheme.bodyStyle.copyWith(
                  fontSize: ApiarioTheme.getBodyFontSize(context) - 4,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget para alertas importantes responsive
class AlertsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final alertas = [
      'Colmena Epsilon requiere atención inmediata',
      'Próxima cosecha programada para el 15/05',
      'Revisar niveles de alimentadores',
      'Tratamiento varroa pendiente en Colmena Beta',
    ];

    return Card(
      elevation: 3,
      color: ApiarioTheme.dangerColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(ApiarioTheme.getPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notification_important,
                  color: ApiarioTheme.dangerColor,
                  size: 24,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Alertas Importantes',
                    style: ApiarioTheme.titleStyle.copyWith(
                      fontSize: ApiarioTheme.getSubtitleFontSize(context) - 4,
                      color: ApiarioTheme.dangerColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Alertas en lista
            Column(
              children:
                  alertas
                      .take(ResponsiveBreakpoints.isMobile(context) ? 3 : 4)
                      .map(
                        (alerta) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning,
                                  color: ApiarioTheme.dangerColor,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    alerta,
                                    style: ApiarioTheme.bodyStyle.copyWith(
                                      fontSize:
                                          ApiarioTheme.getBodyFontSize(
                                            context,
                                          ) -
                                          2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Sección de historial de inspecciones responsive
class InspectionHistorySection extends StatelessWidget {
  final int? maxItems;

  const InspectionHistorySection({this.maxItems});

  @override
  Widget build(BuildContext context) {
    final itemsToShow =
        maxItems ?? (ResponsiveBreakpoints.isMobile(context) ? 3 : 5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Historial de Inspecciones', icon: Icons.history),
        SizedBox(height: 16),

        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children:
                ApiarioData.inspectionHistory
                    .take(itemsToShow)
                    .map((record) => _InspectionItem(record: record))
                    .toList(),
          ),
        ),
      ],
    );
  }
}

class _InspectionItem extends StatelessWidget {
  final InspectionRecord record;

  const _InspectionItem({required this.record});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    return InkWell(
      onTap: () => _showInspectionDetails(context),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: record.statusColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inspección del ${_formatDate(record.date)}',
                    style: ApiarioTheme.bodyStyle.copyWith(
                      fontSize: ApiarioTheme.getBodyFontSize(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Estado: ${record.status} • Inspector: ${record.inspector}',
                    style: ApiarioTheme.bodyStyle.copyWith(
                      fontSize: ApiarioTheme.getBodyFontSize(context) - 2,
                      color: record.statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (!isMobile) ...[
                    SizedBox(height: 2),
                    Text(
                      record.observations,
                      style: ApiarioTheme.bodyStyle.copyWith(
                        fontSize: ApiarioTheme.getBodyFontSize(context) - 2,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (!isMobile)
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showInspectionDetails(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Inspección del ${_formatDate(record.date)}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Estado: ${record.status}'),
                  SizedBox(height: 8),
                  Text('Inspector: ${record.inspector}'),
                  SizedBox(height: 8),
                  Text('Observaciones:'),
                  SizedBox(height: 4),
                  Text(record.observations),
                  SizedBox(height: 8),
                  Text('Acciones realizadas:'),
                  SizedBox(height: 4),
                  ...record.actions.map(
                    (action) => Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 2),
                      child: Text('• $action'),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cerrar'),
              ),
            ],
          ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Widget para gráfico de producción responsive
class ProductionChart extends StatelessWidget {
  final bool isCompact;

  const ProductionChart({this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    final height =
        isCompact
            ? 150.0
            : (ResponsiveBreakpoints.isMobile(context) ? 180.0 : 200.0);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(ApiarioTheme.getPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bar_chart,
                  color: ApiarioTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Producción de Miel',
                    style: ApiarioTheme.titleStyle.copyWith(
                      fontSize: ApiarioTheme.getSubtitleFontSize(context) - 4,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.show_chart,
                      size: isCompact ? 32 : 48,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Gráfico de Producción',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: ApiarioTheme.getBodyFontSize(context),
                      ),
                    ),
                    Text(
                      'Próximamente',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: ApiarioTheme.getBodyFontSize(context) - 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget reutilizable para títulos de sección
class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ApiarioTheme.primaryColor.withOpacity(0.3),
            width: 2.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: ApiarioTheme.primaryColor,
            size: ResponsiveBreakpoints.isMobile(context) ? 24 : 28,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: ApiarioTheme.titleStyle.copyWith(
                fontSize: ApiarioTheme.getSubtitleFontSize(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}