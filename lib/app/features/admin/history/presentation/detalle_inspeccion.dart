import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InspeccionDetalleScreen extends StatefulWidget {
  final String fecha;
  final String estado;
  final String observaciones;

  const InspeccionDetalleScreen({
    Key? key,
    required this.fecha,
    required this.estado,
    required this.observaciones,
  }) : super(key: key);

  @override
  _InspeccionDetalleScreenState createState() =>
      _InspeccionDetalleScreenState();
}

class _InspeccionDetalleScreenState extends State<InspeccionDetalleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showingBarChart = false;
  bool _showingLineChart = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Delayed animations for charts
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _showingLineChart = true;
      });
    });

    Future.delayed(Duration(milliseconds: 600), () {
      setState(() {
        _showingBarChart = true;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1200;
        final isTablet =
            constraints.maxWidth > 768 && constraints.maxWidth <= 1200;
        final isMobile = constraints.maxWidth <= 768;

        if (isDesktop) {
          return _buildDesktopLayout();
        } else if (isTablet) {
          return _buildTabletLayout();
        } else {
          return _buildMobileLayout();
        }
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar con información principal
          Container(
            width: 400,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _getStatusColor(widget.estado),
                  _getStatusColor(widget.estado).withOpacity(0.7),
                ],
              ),
            ),
            child: _buildSidebarContent(),
          ),
          // Contenido principal
          Expanded(
            child: Container(
              color: Colors.grey[50],
              child: Column(
                children: [
                  _buildDesktopTabBar(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildDesktopInfoTab(),
                        _buildDesktopProduccionTab(),
                        _buildDesktopColmenasTab(),
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

  Widget _buildTabletLayout() {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              backgroundColor: _getStatusColor(widget.estado),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Detalles de Inspección',
                  style: GoogleFonts.concertOne(
                    fontSize: 24,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                background: _buildTabletHeader(),
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: _getStatusColor(widget.estado),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: _getStatusColor(widget.estado),
                  labelStyle: GoogleFonts.poppins(fontSize: 16),
                  tabs: [
                    Tab(
                      icon: Icon(Icons.info_outline, size: 28),
                      text: "Información",
                    ),
                    Tab(
                      icon: Icon(Icons.show_chart, size: 28),
                      text: "Producción",
                    ),
                    Tab(icon: Icon(Icons.hive, size: 28), text: "Colmenas"),
                  ],
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTabletInfoTab(),
            _buildTabletProduccionTab(),
            _buildTabletColmenasTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Editar', style: GoogleFonts.poppins(fontSize: 16)),
        icon: Icon(Icons.edit, size: 24),
        backgroundColor: _getStatusColor(widget.estado),
      ).animate().scale(delay: 300.ms),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: _getStatusColor(widget.estado),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Detalles de Inspección',
                  style: GoogleFonts.concertOne(
                    fontSize: 20,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                background: _buildMobileHeader(),
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: _getStatusColor(widget.estado),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: _getStatusColor(widget.estado),
                  tabs: [
                    Tab(icon: Icon(Icons.info_outline), text: "Información"),
                    Tab(icon: Icon(Icons.show_chart), text: "Producción"),
                    Tab(icon: Icon(Icons.hive), text: "Colmenas"),
                  ],
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildInfoTab(),
            _buildProduccionTab(),
            _buildColmenasTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Editar', style: GoogleFonts.poppins()),
        icon: Icon(Icons.edit),
        backgroundColor: _getStatusColor(widget.estado),
      ).animate().scale(delay: 300.ms),
    );
  }

  Widget _buildSidebarContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(widget.estado),
                        size: 20,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        widget.estado,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Text(
              'Inspección',
              style: GoogleFonts.concertOne(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Detalles Completos',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            SizedBox(height: 40),
            _buildSidebarInfoCard('Fecha', widget.fecha, Icons.calendar_today),
            SizedBox(height: 20),
            _buildSidebarInfoCard(
              'Estado',
              widget.estado,
              _getStatusIcon(widget.estado),
            ),
            SizedBox(height: 40),
            Text(
              'Observaciones',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.observaciones,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.edit, color: _getStatusColor(widget.estado)),
                label: Text(
                  'Editar Inspección',
                  style: GoogleFonts.poppins(
                    color: _getStatusColor(widget.estado),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: _getStatusColor(widget.estado),
        unselectedLabelColor: Colors.grey,
        indicatorColor: _getStatusColor(widget.estado),
        labelStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        tabs: [
          Tab(icon: Icon(Icons.info_outline, size: 28), text: "Información"),
          Tab(icon: Icon(Icons.show_chart, size: 28), text: "Producción"),
          Tab(icon: Icon(Icons.hive, size: 28), text: "Colmenas"),
        ],
      ),
    );
  }

  Widget _buildDesktopInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información General',
            style: GoogleFonts.concertOne(
              fontSize: 28,
              color: Colors.brown[800],
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildClimateCard()),
              SizedBox(width: 24),
              Expanded(child: _buildAdditionalInfoCard()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopProduccionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Análisis de Producción',
            style: GoogleFonts.concertOne(
              fontSize: 28,
              color: Colors.brown[800],
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: AnimatedOpacity(
                  opacity: _showingLineChart ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: _buildDesktopLineChart(),
                ),
              ),
              SizedBox(width: 24),
              Expanded(child: _buildProduccionStats()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopColmenasTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estado de las Colmenas',
            style: GoogleFonts.concertOne(
              fontSize: 28,
              color: Colors.brown[800],
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: AnimatedOpacity(
                  opacity: _showingBarChart ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: _buildDesktopBarChart(),
                ),
              ),
              SizedBox(width: 24),
              Expanded(child: _buildColmenasList()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabletHeader() {
    return Hero(
      tag: 'inspeccion_${widget.fecha}',
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _getStatusColor(widget.estado),
                  _getStatusColor(widget.estado).withOpacity(0.7),
                ],
              ),
            ),
          ),
          Positioned(
            right: -80,
            bottom: -80,
            child: Opacity(
              opacity: 0.2,
              child: Icon(
                _getStatusIcon(widget.estado),
                size: 300,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 24,
            bottom: 80,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(widget.estado),
                        size: 20,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        widget.estado,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today, size: 20, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        widget.fecha,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileHeader() {
    return Hero(
      tag: 'inspeccion_${widget.fecha}',
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _getStatusColor(widget.estado),
                  _getStatusColor(widget.estado).withOpacity(0.7),
                ],
              ),
            ),
          ),
          Positioned(
            right: -50,
            bottom: -50,
            child: Opacity(
              opacity: 0.2,
              child: Icon(
                _getStatusIcon(widget.estado),
                size: 200,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 70,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getStatusIcon(widget.estado),
                    size: 16,
                    color: Colors.white,
                  ),
                  SizedBox(width: 4),
                  Text(
                    widget.estado,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
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

  Widget _buildTabletInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child:
                    _buildInfoCard(
                      'Fecha de Inspección',
                      widget.fecha,
                      Icons.calendar_today,
                    ).animate().fadeIn(duration: 300.ms).slideY(),
              ),
              SizedBox(width: 16),
              Expanded(
                child:
                    _buildInfoCard(
                          'Estado General',
                          widget.estado,
                          _getStatusIcon(widget.estado),
                        )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 100.ms)
                        .slideY(),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildObservacionesCard()
              .animate()
              .fadeIn(duration: 500.ms, delay: 200.ms)
              .slideY(),
          SizedBox(height: 20),
          _buildClimateCard()
              .animate()
              .fadeIn(duration: 600.ms, delay: 300.ms)
              .slideY(),
        ],
      ),
    );
  }

  Widget _buildTabletProduccionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Producción de miel en los últimos meses'),
          SizedBox(height: 20),
          AnimatedOpacity(
            opacity: _showingLineChart ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: _buildTabletLineChart(),
          ),
          SizedBox(height: 24),
          _buildProduccionStats(),
        ],
      ),
    );
  }

  Widget _buildTabletColmenasTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Estado de las colmenas'),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: AnimatedOpacity(
                  opacity: _showingBarChart ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: _buildTabletBarChart(),
                ),
              ),
              SizedBox(width: 24),
              Expanded(child: _buildColmenasList()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLineChart() {
    return Container(
      height: 400,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: _buildLineChartContent(),
    );
  }

  Widget _buildTabletLineChart() {
    return Container(
      height: 300,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: _buildLineChartContent(),
    );
  }

  Widget _buildDesktopBarChart() {
    return Container(
      height: 400,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: _buildBarChartContent(),
    );
  }

  Widget _buildTabletBarChart() {
    return Container(
      height: 300,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: _buildBarChartContent(),
    );
  }

  Widget _buildAdditionalInfoCard() {
    return Card(
      elevation: 4,
      shadowColor: Colors.amber.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información Adicional',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            SizedBox(height: 16),
            _buildInfoRow('Inspector', 'Juan Pérez'),
            _buildInfoRow('Duración', '45 minutos'),
            _buildInfoRow('Próxima inspección', '15/06/2025'),
            _buildInfoRow('Colmenas revisadas', '4 de 4'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.brown[800],
            ),
          ),
        ],
      ),
    );
  }

  // Resto de métodos originales con ajustes menores...
  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'Fecha de Inspección',
            widget.fecha,
            Icons.calendar_today,
          ).animate().fadeIn(duration: 300.ms).slideY(),
          SizedBox(height: 16),
          _buildInfoCard(
            'Estado General',
            widget.estado,
            _getStatusIcon(widget.estado),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(),
          SizedBox(height: 16),
          _buildObservacionesCard()
              .animate()
              .fadeIn(duration: 500.ms, delay: 200.ms)
              .slideY(),
          SizedBox(height: 16),
          _buildClimateCard()
              .animate()
              .fadeIn(duration: 600.ms, delay: 300.ms)
              .slideY(),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      shadowColor: Colors.amber.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getStatusColor(widget.estado).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: _getStatusColor(widget.estado),
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[800],
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

  Widget _buildObservacionesCard() {
    return Card(
      elevation: 4,
      shadowColor: Colors.amber.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getStatusColor(widget.estado).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.description,
                    color: _getStatusColor(widget.estado),
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  'Observaciones',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.observaciones,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.brown[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClimateCard() {
    return Card(
      elevation: 4,
      shadowColor: Colors.amber.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.cloud, color: Colors.blue, size: 24),
                ),
                SizedBox(width: 16),
                Text(
                  'Condiciones Climáticas',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildClimateItem('Temperatura', '24°C', Icons.thermostat),
                _buildClimateItem('Humedad', '65%', Icons.water_drop),
                _buildClimateItem('Viento', '5 km/h', Icons.air),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClimateItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 28),
        SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.brown[800],
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildProduccionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Producción de miel en los últimos meses'),
          SizedBox(height: 16),
          AnimatedOpacity(
            opacity: _showingLineChart ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: _buildLineChart(),
          ),
          SizedBox(height: 24),
          _buildProduccionStats(),
        ],
      ),
    );
  }

  Widget _buildColmenasTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Estado de las colmenas'),
          SizedBox(height: 16),
          AnimatedOpacity(
            opacity: _showingBarChart ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: _buildBarChart(),
          ),
          SizedBox(height: 24),
          _buildColmenasList(),
        ],
      ),
    );
  }

  Widget _buildProduccionStats() {
    return Card(
      elevation: 4,
      shadowColor: Colors.amber.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen de Producción',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatColumn('Total', '85 kg', Colors.amber),
                _buildStatColumn('Promedio', '14.2 kg', Colors.orange),
                _buildStatColumn('Tendencia', '+12%', Colors.green),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildColmenasList() {
    return Column(
      children: [
        _buildColmenaItem('Colmena 1', 80, 'Saludable', Colors.green),
        _buildColmenaItem('Colmena 2', 70, 'Saludable', Colors.green),
        _buildColmenaItem('Colmena 3', 50, 'Requiere atención', Colors.orange),
        _buildColmenaItem('Colmena 4', 90, 'Excelente', Colors.green),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }

  Widget _buildColmenaItem(
    String name,
    double health,
    String status,
    Color statusColor,
  ) {
    return GestureDetector(
      onTap: () {
        _showColmenaDetailDialog(name, health, status, statusColor);
      },
      child: Card(
        elevation: 2,
        margin: EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(Icons.hive, color: Colors.amber[800], size: 30),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      status,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    '${health.toInt()}%',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Salud',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  void _showColmenaDetailDialog(
    String name,
    double health,
    String status,
    Color statusColor,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder:
                (_, controller) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  padding: EdgeInsets.all(20),
                  child: ListView(
                    controller: controller,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.hive,
                                  color: Colors.amber[800],
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                name,
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown[800],
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      _buildHealthIndicator(health, status, statusColor),
                      SizedBox(height: 24),
                      _buildDetailSection(
                        'Población',
                        _buildPopulationDetails(),
                      ),
                      SizedBox(height: 16),
                      _buildDetailSection(
                        'Producción',
                        _buildProductionDetails(),
                      ),
                      SizedBox(height: 16),
                      _buildDetailSection(
                        'Actividad Reciente',
                        _buildRecentActivityList(),
                      ),
                      SizedBox(height: 16),
                      _buildDetailSection(
                        'Tratamientos',
                        _buildTreatmentsList(),
                      ),
                      SizedBox(height: 16),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: ElevatedButton.icon(
                      //         icon: Icon(Icons.edit),
                      //         label: Text('Editar'),
                      //         style: ElevatedButton.styleFrom(
                      //           backgroundColor: statusColor,
                      //           foregroundColor: Colors.white,
                      //           padding: EdgeInsets.symmetric(vertical: 12),
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(10),
                      //           ),
                      //         ),
                      //         onPressed: () {
                      //           Navigator.pop(context);
                      //         },
                      //       ),
                      //     ),
                      //     SizedBox(width: 12),
                      //     Expanded(
                      //       child: OutlinedButton.icon(
                      //         icon: Icon(Icons.history),
                      //         label: Text('Historial'),
                      //         style: OutlinedButton.styleFrom(
                      //           foregroundColor: Colors.brown[800],
                      //           side: BorderSide(color: Colors.brown[800]!),
                      //           padding: EdgeInsets.symmetric(vertical: 12),
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(10),
                      //           ),
                      //         ),
                      //         onPressed: () {},
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
          ),
    );
  }

  Widget _buildHealthIndicator(
    double health,
    String status,
    Color statusColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Estado de Salud',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 12),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: CircularProgressIndicator(
                  value: health / 100,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                ),
              ),
              Column(
                children: [
                  Text(
                    '${health.toInt()}%',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  Text(
                    status,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildHealthMetric(
                'Reina',
                'Presente',
                Icons.check_circle,
                Colors.green,
              ),
              _buildHealthMetric(
                'Cría',
                'Normal',
                Icons.child_care,
                Colors.amber,
              ),
              _buildHealthMetric(
                'Plagas',
                'No',
                Icons.bug_report,
                Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetric(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.brown[800],
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildDetailSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.brown[800],
          ),
        ),
        SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildPopulationDetails() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPopulationItem('Obreras', '~15,000', Icons.group),
              _buildPopulationItem('Zánganos', '~500', Icons.person),
              _buildPopulationItem('Edad Reina', '1.5 años', Icons.cake),
            ],
          ),
          SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0.7,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          SizedBox(height: 8),
          Text(
            'Capacidad de población: 70%',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildPopulationItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.amber[800], size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.brown[800],
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildProductionDetails() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProductionItem('Miel', '8.5 kg', Icons.local_drink),
              _buildProductionItem('Polen', '1.2 kg', Icons.grain),
              _buildProductionItem('Cera', '0.5 kg', Icons.hexagon),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Última cosecha:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Text(
                '15/04/2025',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.brown[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Próxima cosecha estimada:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Text(
                '20/06/2025',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.brown[800],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductionItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.amber[800], size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.brown[800],
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildRecentActivityList() {
    final activities = [
      {
        'date': '10/05/2025',
        'action': 'Inspección rutinaria',
        'notes': 'Se observó actividad normal',
        'icon': Icons.search,
        'color': Colors.blue,
      },
      {
        'date': '01/05/2025',
        'action': 'Alimentación suplementaria',
        'notes': '2kg de jarabe de azúcar',
        'icon': Icons.restaurant,
        'color': Colors.amber,
      },
      {
        'date': '20/04/2025',
        'action': 'Tratamiento preventivo',
        'notes': 'Aplicación de ácido oxálico',
        'icon': Icons.healing,
        'color': Colors.green,
      },
    ];

    return Column(
      children:
          activities.map((activity) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (activity['color'] as Color).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        activity['icon'] as IconData,
                        color: activity['color'] as Color,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                activity['action'] as String,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.brown[800],
                                ),
                              ),
                              Text(
                                activity['date'] as String,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            activity['notes'] as String,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildTreatmentsList() {
    final treatments = [
      {
        'name': 'Ácido oxálico',
        'date': '20/04/2025',
        'status': 'Completado',
        'statusColor': Colors.green,
      },
      {
        'name': 'Timol',
        'date': '15/03/2025',
        'status': 'Completado',
        'statusColor': Colors.green,
      },
      {
        'name': 'Ácido fórmico',
        'date': '10/06/2025',
        'status': 'Programado',
        'statusColor': Colors.blue,
      },
    ];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children:
            treatments.map((treatment) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.medical_services,
                      color: Colors.amber[800],
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        treatment['name'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.brown[800],
                        ),
                      ),
                    ),
                    Text(
                      treatment['date'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (treatment['statusColor'] as Color).withOpacity(
                          0.2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        treatment['status'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: treatment['statusColor'] as Color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.concertOne(fontSize: 20, color: Colors.brown[800]),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildLineChart() {
    return Container(
      height: 250,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: _buildLineChartContent(),
    );
  }

  Widget _buildLineChartContent() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()} kg',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    months[value.toInt()],
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 12),
              FlSpot(1, 15),
              FlSpot(2, 8),
              FlSpot(3, 18),
              FlSpot(4, 20),
              FlSpot(5, 25),
            ],
            isCurved: true,
            color: Colors.amber[600],
            barWidth: 4,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.amber.withOpacity(0.2),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                return LineTooltipItem(
                  '${barSpot.y.toInt()} kg',
                  GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return Container(
      height: 250,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: _buildBarChartContent(),
    );
  }

  Widget _buildBarChartContent() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toInt()}%',
                GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const colmenas = [
                  'Colmena 1',
                  'Colmena 2',
                  'Colmena 3',
                  'Colmena 4',
                ];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    colmenas[value.toInt()],
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1);
          },
        ),
        barGroups: [
          _buildBarData(0, 80, Colors.green),
          _buildBarData(1, 70, Colors.green),
          _buildBarData(2, 50, Colors.orange),
          _buildBarData(3, 90, Colors.green),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 20,
          borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: Colors.grey[200],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alerta':
        return Colors.orange;
      case 'normal':
        return const Color.fromARGB(204, 251, 194, 9);
      default:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'alerta':
        return Icons.warning_amber_rounded;
      case 'normal':
        return Icons.check_circle_outline;
      default:
        return Icons.info_outline;
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
