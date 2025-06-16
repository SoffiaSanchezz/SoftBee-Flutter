import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsSettingsPage extends StatefulWidget {
  @override
  _NotificationsSettingsPageState createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _apiaryAlerts = true;
  bool _productionReports = true;
  bool _weatherAlerts = false;
  bool _maintenanceReminders = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notificaciones',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildNotificationSection('Generales', [
            _buildSwitchTile(
              'Notificaciones push',
              'Recibir notificaciones en el dispositivo',
              _pushNotifications,
              (value) => setState(() => _pushNotifications = value),
            ),
            _buildSwitchTile(
              'Notificaciones por email',
              'Recibir notificaciones por correo electrónico',
              _emailNotifications,
              (value) => setState(() => _emailNotifications = value),
            ),
          ]),
          SizedBox(height: 20),
          _buildNotificationSection('Apiarios', [
            _buildSwitchTile(
              'Alertas de apiarios',
              'Notificaciones sobre el estado de los apiarios',
              _apiaryAlerts,
              (value) => setState(() => _apiaryAlerts = value),
            ),
            _buildSwitchTile(
              'Reportes de producción',
              'Informes periódicos de producción',
              _productionReports,
              (value) => setState(() => _productionReports = value),
            ),
            _buildSwitchTile(
              'Alertas meteorológicas',
              'Notificaciones sobre condiciones climáticas',
              _weatherAlerts,
              (value) => setState(() => _weatherAlerts = value),
            ),
            _buildSwitchTile(
              'Recordatorios de mantenimiento',
              'Recordatorios para visitas y mantenimiento',
              _maintenanceReminders,
              (value) => setState(() => _maintenanceReminders = value),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildNotificationSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 10),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.orange,
    );
  }
}
