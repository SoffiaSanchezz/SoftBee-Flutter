import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.orange,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Mi Perfil',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('/image/Abeja.jpeg', fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  // Acción para editar perfil
                },
              ),
              IconButton(
                icon: Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  // Acción para configuraciones
                },
              ),
            ],
          ),
          SliverToBoxAdapter(child: ProfileHeader()),
          SliverToBoxAdapter(child: ProfileStats()),
          SliverToBoxAdapter(child: ApiarySection()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
        onPressed: () {
          // Acción para añadir nuevo apiario
        },
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Indicador de progreso circular
              SizedBox(
                width: 110,
                height: 110,
                child: CircularProgressIndicator(
                  value: 0.75, // 75% de progreso
                  strokeWidth: 3,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              ),
              // Avatar existente
              Hero(
                tag: 'profile-image',
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('/image/userSoftbee.png'),
                  ),
                ),
              ).animate().fadeIn(duration: 600.ms).scale(delay: 300.ms),
            ],
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sofia Sanchez',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
                SizedBox(height: 4),
                Text(
                  'Apicultor desde 2018',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Color(0xFF333333),
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 500.ms),
                SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, color: Colors.orange, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Profesional',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade800,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 600.ms, delay: 600.ms),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.timer, color: Colors.orange, size: 16),
                          SizedBox(width: 4),
                          Text(
                            '5 años',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade800,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 600.ms, delay: 700.ms),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StatItem(
                    title: '12',
                    subtitle: 'Colmenas',
                    icon: Icons.hive,
                    delay: 200,
                    color: Colors.amber,
                  ),
                  _buildVerticalDivider(),
                  StatItem(
                    title: '3',
                    subtitle: 'Apiarios',
                    icon: Icons.location_on,
                    delay: 400,
                    color: Colors.orange,
                  ),
                  _buildVerticalDivider(),
                  StatItem(
                    title: '120kg',
                    subtitle: 'Producción',
                    icon: Icons.local_drink,
                    delay: 600,
                    color: Colors.deepOrange,
                  ),
                ],
              ),
            ),
          )
          .animate()
          .fadeIn(duration: 800.ms, delay: 300.ms)
          .moveY(begin: 20, end: 0),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 50, width: 1, color: Colors.grey.shade300);
  }
}

class StatItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final int delay;
  final Color color;

  StatItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.delay,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            )
            .animate()
            .fadeIn(duration: 600.ms, delay: delay.ms)
            .scale(delay: delay.ms),
        SizedBox(height: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ).animate().fadeIn(duration: 600.ms, delay: (delay + 100).ms),
        SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
        ).animate().fadeIn(duration: 600.ms, delay: (delay + 200).ms),
      ],
    );
  }
}

class ApiarySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mis Apiarios',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ).animate().fadeIn(duration: 600.ms),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add_location_alt, color: Colors.orange),
                label: Text(
                  'Ver todos',
                  style: GoogleFonts.poppins(color: Colors.orange),
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
            ],
          ),
          SizedBox(height: 16),
          Container(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ApiaryCard(
                  name: 'Apiario Norte',
                  location: 'Valle del Sol',
                  hives: 5,
                  lastVisit: '2 días atrás',
                  imageUrl: '/image/Mapa.png',
                  delay: 300,
                  color: Colors.amber,
                  healthStatus: 'Excelente',
                  productionRate: 28.5,
                  temperatureAvg: 24,
                  humidityAvg: 65,
                ),
                SizedBox(width: 16),
                ApiaryCard(
                  name: 'Apiario Central',
                  location: 'Lomas Verdes',
                  hives: 4,
                  lastVisit: '1 semana atrás',
                  imageUrl: '/image/Mapa.png',
                  delay: 500,
                  color: Colors.orange,
                  healthStatus: 'Bueno',
                  productionRate: 22.0,
                  temperatureAvg: 26,
                  humidityAvg: 60,
                ),
                SizedBox(width: 16),
                ApiaryCard(
                  name: 'Apiario Sur',
                  location: 'Campos Floridos',
                  hives: 3,
                  lastVisit: '3 días atrás',
                  imageUrl: '/image/Mapa.png',
                  delay: 700,
                  color: Colors.deepOrange,
                  healthStatus: 'Regular',
                  productionRate: 18.5,
                  temperatureAvg: 28,
                  humidityAvg: 55,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ApiaryCard extends StatelessWidget {
  final String name;
  final String location;
  final int hives;
  final String lastVisit;
  final String imageUrl;
  final int delay;
  final Color color;
  final String healthStatus;
  final double productionRate;
  final int temperatureAvg;
  final int humidityAvg;

  ApiaryCard({
    required this.name,
    required this.location,
    required this.hives,
    required this.lastVisit,
    required this.imageUrl,
    required this.delay,
    required this.color,
    required this.healthStatus,
    required this.productionRate,
    required this.temperatureAvg,
    required this.humidityAvg,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showApiaryDetails(context);
      },
      child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 210,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: SizedBox(
                          height: 100,
                          width: 220,
                          child: Image.asset(imageUrl, fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$hives colmenas',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _getStatusColor(),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getStatusColor().withOpacity(0.4),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: color),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                location,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Última visita: $lastVisit',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .animate()
          .fadeIn(duration: 800.ms, delay: delay.ms)
          .moveY(begin: 20, end: 0),
    );
  }

  Color _getStatusColor() {
    // Determinar el color basado en la última visita
    if (lastVisit.contains('día')) {
      int days = int.tryParse(lastVisit.split(' ')[0]) ?? 0;
      if (days <= 3) return Colors.green;
      if (days <= 7) return Colors.orange;
      return Colors.red;
    }
    return Colors.red; // Si es "semana" o más
  }

  void _showApiaryDetails(BuildContext context) {
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
                      // Encabezado con nombre y botón de cierre
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Imagen más grande en lugar del mapa
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Tarjetas de resumen
                      Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard(
                              'Estado',
                              healthStatus,
                              Icons.favorite,
                              _getHealthStatusColor(healthStatus),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _buildSummaryCard(
                              'Producción',
                              '$productionRate kg/mes',
                              Icons.local_drink,
                              Colors.amber,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard(
                              'Temperatura',
                              '$temperatureAvg°C',
                              Icons.thermostat,
                              Colors.red.shade400,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _buildSummaryCard(
                              'Humedad',
                              '$humidityAvg%',
                              Icons.water_drop,
                              Colors.blue.shade400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Información detallada
                      _buildDetailItem(
                        Icons.location_on,
                        "Ubicación",
                        location,
                        color,
                      ),
                      _buildDetailItem(
                        Icons.hive,
                        "Colmenas",
                        "$hives colmenas activas",
                        color,
                      ),
                      _buildDetailItem(
                        Icons.calendar_today,
                        "Última visita",
                        lastVisit,
                        color,
                      ),

                      SizedBox(height: 20),

                      // Sección de colmenas
                      Text(
                        "Colmenas en este apiario",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),

                      // Lista de colmenas
                      Container(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: hives,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.only(right: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                width: 100,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.hive, color: color, size: 32),
                                    SizedBox(height: 8),
                                    Text(
                                      "Colmena ${index + 1}",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "${(index * 2.5 + 10).toStringAsFixed(1)} kg",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 20),

                      // Botones de acción
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {},
                              icon: Icon(Icons.edit, color: Colors.white),
                              label: Text(
                                "Editar apiario",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: color),
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {},
                              icon: Icon(Icons.add_task, color: color),
                              label: Text(
                                "Registrar visita",
                                style: GoogleFonts.poppins(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 24),
            SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getHealthStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'excelente':
        return Colors.green;
      case 'bueno':
        return Colors.lightGreen;
      case 'regular':
        return Colors.orange;
      case 'malo':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
