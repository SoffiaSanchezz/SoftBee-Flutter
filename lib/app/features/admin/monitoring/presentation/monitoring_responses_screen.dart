import 'package:flutter/material.dart';
import '../models/model.dart';

class MonitoringResponsesScreen extends StatefulWidget {
  final List<MonitoreoRespuesta> responses;
  final String apiarioName;
  final int colmenaNumber;

  const MonitoringResponsesScreen({
    Key? key,
    required this.responses,
    required this.apiarioName,
    required this.colmenaNumber,
  }) : super(key: key);

  @override
  _MonitoringResponsesScreenState createState() =>
      _MonitoringResponsesScreenState();
}

class _MonitoringResponsesScreenState extends State<MonitoringResponsesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Color _primaryColor = Color(0xFF4CAF50);
  final Color _accentColor = Color(0xFF81C784);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Resultados del Monitoreo'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(icon: Icon(Icons.list_alt), text: 'Respuestas'),
            Tab(icon: Icon(Icons.analytics), text: 'Resumen'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildResponsesList(), _buildSummaryView()],
      ),
    );
  }

  Widget _buildResponsesList() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: widget.responses.length,
            itemBuilder: (context, index) {
              final response = widget.responses[index];
              return _buildResponseCard(response, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.hive, size: 48, color: Colors.white),
          SizedBox(height: 12),
          Text(
            '${widget.apiarioName}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Colmena #${widget.colmenaNumber}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${widget.responses.length} respuestas registradas',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseCard(MonitoreoRespuesta response, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    response.preguntaTexto,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _accentColor.withOpacity(0.3)),
              ),
              child: Text(
                response.respuesta.toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(),
          SizedBox(height: 20),
          _buildQuickStats(),
          SizedBox(height: 20),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.summarize, color: _primaryColor, size: 28),
                SizedBox(width: 12),
                Text(
                  'Resumen del Monitoreo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildSummaryItem('Fecha', DateTime.now().toString().split(' ')[0]),
            _buildSummaryItem('Hora', TimeOfDay.now().format(context)),
            _buildSummaryItem('Apiario', widget.apiarioName),
            _buildSummaryItem('Colmena', '#${widget.colmenaNumber}'),
            _buildSummaryItem(
              'Preguntas respondidas',
              '${widget.responses.length}',
            ),
            _buildSummaryItem('Estado', 'Completado ✅'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Tiempo Total',
            '~${widget.responses.length * 2} min',
            Icons.access_time,
            Colors.blue,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Eficiencia',
            '100%',
            Icons.check_circle,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // Implementar exportación
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Exportando datos...'),
                  backgroundColor: _primaryColor,
                ),
              );
            },
            icon: Icon(Icons.file_download),
            label: Text('Exportar Datos'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // Implementar compartir
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Compartiendo resultados...'),
                  backgroundColor: _accentColor,
                ),
              );
            },
            icon: Icon(Icons.share),
            label: Text('Compartir Resultados'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
