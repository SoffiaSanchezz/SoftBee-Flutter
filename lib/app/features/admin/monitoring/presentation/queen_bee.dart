import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class QueenReplacementScreen extends StatefulWidget {
  final String colmenaNombre;

  const QueenReplacementScreen({super.key, required this.colmenaNombre});

  @override
  State<QueenReplacementScreen> createState() => _QueenReplacementScreenState();
}

class _QueenReplacementScreenState extends State<QueenReplacementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _showReplacementForm = false;

  // Datos de ejemplo para el historial
  final List<Map<String, dynamic>> _replacementHistory = [
    {
      'id': '1',
      'date': DateTime(2024, 3, 15),
      'colmena': 'Colmena #1',
      'queenType': 'Italiana',
      'status': 'completed',
      'notes':
          'Reemplazo exitoso. La colonia aceptó a la nueva reina sin problemas.',
    },
    {
      'id': '2',
      'date': DateTime(2024, 1, 20),
      'colmena': 'Colmena #3',
      'queenType': 'Carniola',
      'status': 'completed',
      'notes':
          'Reina anterior estaba envejeciendo. Buena aceptación de la nueva reina.',
    },
    {
      'id': '3',
      'date': DateTime(2023, 10, 5),
      'colmena': 'Colmena #2',
      'queenType': 'Buckfast',
      'status': 'failed',
      'notes':
          'La colonia rechazó a la reina. Se intentará nuevamente en 2 semanas.',
    },
    {
      'id': '4',
      'date': DateTime(2024, 6, 15),
      'colmena': 'Colmena #4',
      'queenType': 'Italiana',
      'status': 'scheduled',
      'notes': 'Programado para mejorar la genética de la colonia.',
    },
  ];

  // Controladores para el formulario
  final TextEditingController _notesController = TextEditingController();
  String _selectedQueenType = 'Italiana';
  bool _enableNotifications = true;
  bool _reminderDayBefore = true;
  bool _reminderDayOf = true;
  bool _reminderWeekBefore = false;
  bool _pushNotifications = true;
  bool _emailNotifications = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Breakpoints mejorados y más específicos
  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;
  bool _isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;
  bool _isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;
  bool _isLargeDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1600;

  // Obtener el ancho máximo del contenido
  double _getMaxContentWidth(BuildContext context) {
    if (_isLargeDesktop(context)) return 1400;
    if (_isDesktop(context)) return 1200;
    return double.infinity;
  }

  // Obtener la proporción del calendario vs formulario
  List<int> _getCalendarFormFlex(BuildContext context) {
    if (_isLargeDesktop(context)) return [3, 2]; // Más espacio para calendario
    if (_isDesktop(context)) return [5, 3]; // Proporción mejorada
    return [1, 1]; // Igual en tablet/móvil
  }

  // Inicializar el plugin de notificaciones
  Future<void> _initNotifications() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Programar una notificación
  Future<void> _scheduleNotification(
    DateTime scheduledDate,
    String title,
    String body,
  ) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'queen_replacement_channel',
          'Reemplazo de Reina',
          channelDescription: 'Notificaciones para reemplazo de abeja reina',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
  }

  // Guardar un nuevo reemplazo programado
  void _saveReplacement() {
    if (_selectedDay == null) return;

    setState(() {
      _replacementHistory.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'date': _selectedDay,
        'colmena': widget.colmenaNombre,
        'queenType': _selectedQueenType,
        'status': 'scheduled',
        'notes': _notesController.text,
      });

      _showReplacementForm = false;
      _notesController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Reemplazo programado para ${DateFormat('dd/MM/yyyy').format(_selectedDay!)}',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    if (_enableNotifications) {
      if (_reminderDayBefore) {
        DateTime reminderDate = _selectedDay!.subtract(const Duration(days: 1));
        _scheduleNotification(
          reminderDate,
          'Recordatorio de Reemplazo',
          'Mañana está programado el reemplazo de reina en ${widget.colmenaNombre}',
        );
      }

      if (_reminderDayOf) {
        _scheduleNotification(
          _selectedDay!,
          'Reemplazo de Reina Hoy',
          'Hoy está programado el reemplazo de reina en ${widget.colmenaNombre}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFEF7E0), // amber-50
              Color(0xFFFED7AA), // orange-50
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _isDesktop(context)
                    ? Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: _getMaxContentWidth(context),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildCalendarTab(),
                                _buildHistoryTab(),
                                _buildNotificationsTab(),
                              ],
                            ),
                          ),
                        ),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildCalendarTab(),
                          _buildHistoryTab(),
                          _buildNotificationsTab(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header mejorado con mejor espaciado
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFF59E0B), // amber-500
            Color(0xFFD97706), // amber-600
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x4DF59E0B),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header principal con contenedor centrado para desktop
          Container(
            width: double.infinity,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: _isDesktop(context)
                      ? _getMaxContentWidth(context)
                      : double.infinity,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _isMobile(context)
                        ? 16
                        : _isTablet(context)
                            ? 24
                            : 32,
                    vertical: _isMobile(context)
                        ? 16
                        : _isTablet(context)
                            ? 20
                            : 24,
                  ),
                  child: Column(
                    children: [
                      // Título y acciones con mejor espaciado
                      Row(
                        children: [
                          Container(
                                padding: EdgeInsets.all(
                                  _isMobile(context)
                                      ? 12
                                      : _isDesktop(context)
                                          ? 16
                                          : 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                    _isDesktop(context) ? 16 : 12,
                                  ),
                                ),
                                child: Icon(
                                  Icons.change_circle,
                                  size: _isMobile(context)
                                      ? 28
                                      : _isDesktop(context)
                                          ? 36
                                          : 32,
                                  color: Colors.white,
                                ),
                              )
                              .animate(
                                onPlay: (controller) =>
                                    controller.repeat(reverse: true),
                              )
                              .rotate(
                                begin: -0.05,
                                end: 0.05,
                                duration: 2000.ms,
                              ),
                          SizedBox(
                            width: _isMobile(context)
                                ? 12
                                : _isDesktop(context)
                                    ? 20
                                    : 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                      widget.colmenaNombre,
                                      style: GoogleFonts.poppins(
                                        fontSize: _isMobile(context)
                                            ? 20
                                            : _isDesktop(context)
                                                ? 28
                                                : 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(delay: 200.ms)
                                    .slideX(begin: 0.2, end: 0),
                                Text(
                                      'Reemplazo de Abeja Reina',
                                      style: GoogleFonts.poppins(
                                        fontSize: _isMobile(context)
                                            ? 12
                                            : _isDesktop(context)
                                                ? 16
                                                : 14,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(delay: 300.ms)
                                    .slideX(begin: 0.2, end: 0),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                    icon: const Icon(
                                      Icons.notifications_outlined,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => _tabController.animateTo(2),
                                    iconSize: _isMobile(context)
                                        ? 22
                                        : _isDesktop(context)
                                            ? 26
                                            : 24,
                                  )
                                  .animate()
                                  .fadeIn(delay: 200.ms)
                                  .scale(begin: const Offset(0.5, 0.5)),
                              if (_isDesktop(context)) const SizedBox(width: 8),
                              IconButton(
                                    icon: const Icon(
                                      Icons.share_outlined,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {},
                                    iconSize: _isMobile(context)
                                        ? 22
                                        : _isDesktop(context)
                                            ? 26
                                            : 24,
                                  )
                                  .animate()
                                  .fadeIn(delay: 400.ms)
                                  .scale(begin: const Offset(0.5, 0.5)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _isMobile(context)
                            ? 16
                            : _isDesktop(context)
                                ? 24
                                : 20,
                      ),
                      // Stats grid optimizado
                      _buildStatsGrid(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Tab bar centrado para desktop
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white24, width: 1)),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: _isDesktop(context)
                      ? _getMaxContentWidth(context)
                      : double.infinity,
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: _isDesktop(context) ? 4 : 3,
                  labelStyle: GoogleFonts.poppins(
                    fontSize: _isMobile(context)
                        ? 12
                        : _isDesktop(context)
                            ? 15
                            : 13,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: GoogleFonts.poppins(
                    fontSize: _isMobile(context)
                        ? 12
                        : _isDesktop(context)
                            ? 15
                            : 13,
                    fontWeight: FontWeight.w500,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.calendar_today,
                        size: _isMobile(context)
                            ? 18
                            : _isDesktop(context)
                                ? 22
                                : 20,
                      ),
                      text: _isMobile(context) ? null : 'Calendario',
                    ),
                    Tab(
                      icon: Icon(
                        Icons.history,
                        size: _isMobile(context)
                            ? 18
                            : _isDesktop(context)
                                ? 22
                                : 20,
                      ),
                      text: _isMobile(context) ? null : 'Historial',
                    ),
                    Tab(
                      icon: Icon(
                        Icons.notifications,
                        size: _isMobile(context)
                            ? 18
                            : _isDesktop(context)
                                ? 22
                                : 20,
                      ),
                      text: _isMobile(context) ? null : 'Notificaciones',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Grid de estadísticas optimizado
  Widget _buildStatsGrid() {
    final stats = [
      {
        'icon': Icons.calendar_today_outlined,
        'label': 'Próximo Reemplazo',
        'value': _selectedDay != null
            ? DateFormat('dd/MM/yyyy').format(_selectedDay!)
            : 'No programado',
      },
      {
        'icon': Icons.change_circle_outlined,
        'label': 'Edad de Reina',
        'value': '8 meses',
      },
      {
        'icon': Icons.check_circle_outline,
        'label': 'Estado',
        'value': 'Saludable',
      },
    ];

    if (_isMobile(context)) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildStatCard(stats[0], 0)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(stats[1], 1)),
            ],
          ),
          const SizedBox(height: 12),
          _buildStatCard(stats[2], 2),
        ],
      );
    } else {
      return Row(
        children: stats.asMap().entries.map((entry) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: entry.key < stats.length - 1
                    ? (_isDesktop(context) ? 16 : 12)
                    : 0,
              ),
              child: _buildStatCard(entry.value, entry.key),
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildStatCard(Map<String, dynamic> stat, int index) {
    return Container(
          padding: EdgeInsets.all(
            _isMobile(context)
                ? 12
                : _isDesktop(context)
                    ? 16
                    : 14,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(_isDesktop(context) ? 12 : 8),
          ),
          child: Column(
            children: [
              Icon(
                    stat['icon'],
                    size: _isMobile(context)
                        ? 18
                        : _isDesktop(context)
                            ? 24
                            : 20,
                    color: Colors.white,
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.2, 1.2),
                    duration: 1500.ms,
                  ),
              SizedBox(
                height: _isMobile(context)
                    ? 4
                    : _isDesktop(context)
                        ? 8
                        : 6,
              ),
              Text(
                stat['label'],
                style: GoogleFonts.poppins(
                  fontSize: _isMobile(context)
                      ? 9
                      : _isDesktop(context)
                          ? 12
                          : 10,
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                stat['value'],
                style: GoogleFonts.poppins(
                  fontSize: _isMobile(context)
                      ? 11
                      : _isDesktop(context)
                          ? 14
                          : 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 400 + (index * 100)))
        .slideY(begin: 0.2, end: 0);
  }

  // Tab de Calendario MEJORADO con mejor distribución del espacio
  Widget _buildCalendarTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        _isMobile(context)
            ? 16
            : _isTablet(context)
                ? 20
                : 32,
      ),
      child: _isDesktop(context)
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Calendario con más espacio
                Expanded(
                  flex: _getCalendarFormFlex(context)[0],
                  child: _buildCalendarCard(),
                ),
                SizedBox(width: _isLargeDesktop(context) ? 32 : 24),
                // Formulario/Prompt con menos espacio
                Expanded(
                  flex: _getCalendarFormFlex(context)[1],
                  child: _showReplacementForm
                      ? _buildReplacementForm()
                      : _buildCalendarPrompt(),
                ),
              ],
            )
          : Column(
              children: [
                _buildCalendarCard(),
                SizedBox(height: _isMobile(context) ? 16 : 20),
                _showReplacementForm
                    ? _buildReplacementForm()
                    : _buildCalendarPrompt(),
              ],
            ),
    );
  }

  // Calendario mejorado con animaciones de abeja espectaculares
  Widget _buildCalendarCard() {
    return Card(
      elevation: _isDesktop(context) ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_isDesktop(context) ? 20 : 16),
        side: const BorderSide(color: Color(0xFFFDE68A), width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_isDesktop(context) ? 20 : 16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, const Color(0xFFFEF3C7).withOpacity(0.1)],
          ),
        ),
        padding: EdgeInsets.all(
          _isMobile(context)
              ? 16
              : _isDesktop(context)
                  ? 28
                  : 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seleccionar Fecha',
              style: GoogleFonts.poppins(
                fontSize: _isMobile(context)
                    ? 18
                    : _isDesktop(context)
                        ? 24
                        : 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF92400E),
              ),
            ),
            SizedBox(height: _isDesktop(context) ? 20 : 16),
            // Calendario con animaciones mejoradas
            TableCalendar(
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              enabledDayPredicate: (day) => day.isAfter(
                DateTime.now().subtract(const Duration(days: 1)),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _showReplacementForm = true;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              rowHeight: _isMobile(context)
                  ? 48
                  : _isDesktop(context)
                      ? 64
                      : 56,
              calendarStyle: CalendarStyle(
                cellMargin: EdgeInsets.all(
                  _isMobile(context)
                      ? 4
                      : _isDesktop(context)
                          ? 8
                          : 6,
                ),
                cellPadding: EdgeInsets.all(
                  _isMobile(context)
                      ? 8
                      : _isDesktop(context)
                          ? 12
                          : 10,
                ),
                defaultTextStyle: GoogleFonts.poppins(
                  fontSize: _isMobile(context)
                      ? 14
                      : _isDesktop(context)
                          ? 18
                          : 16,
                  fontWeight: FontWeight.w500,
                ),
                weekendTextStyle: GoogleFonts.poppins(
                  fontSize: _isMobile(context)
                      ? 14
                      : _isDesktop(context)
                          ? 18
                          : 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.red[600],
                ),
                selectedTextStyle: GoogleFonts.poppins(
                  fontSize: _isMobile(context)
                      ? 14
                      : _isDesktop(context)
                          ? 18
                          : 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                todayTextStyle: GoogleFonts.poppins(
                  fontSize: _isMobile(context)
                      ? 14
                      : _isDesktop(context)
                          ? 18
                          : 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                todayDecoration: BoxDecoration(
                  color: const Color(0xFFFBBF24).withOpacity(0.7),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD97706), width: 2),
                ),
                selectedDecoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFD97706), Color(0xFFB45309)],
                  ),
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: Color(0xFF92400E),
                  shape: BoxShape.circle,
                ),
                disabledDecoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                titleCentered: true,
                titleTextStyle: GoogleFonts.poppins(
                  fontSize: _isMobile(context)
                      ? 16
                      : _isDesktop(context)
                          ? 22
                          : 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF92400E),
                ),
                formatButtonDecoration: BoxDecoration(
                  color: const Color(0xFFFBBF24),
                  borderRadius: BorderRadius.circular(20),
                ),
                formatButtonTextStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: _isMobile(context)
                      ? 12
                      : _isDesktop(context)
                          ? 14
                          : 13,
                  fontWeight: FontWeight.w600,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  size: _isMobile(context)
                      ? 20
                      : _isDesktop(context)
                          ? 28
                          : 24,
                  color: const Color(0xFF92400E),
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  size: _isMobile(context)
                      ? 20
                      : _isDesktop(context)
                          ? 28
                          : 24,
                  color: const Color(0xFF92400E),
                ),
                headerPadding: EdgeInsets.symmetric(
                  vertical: _isMobile(context)
                      ? 8
                      : _isDesktop(context)
                          ? 16
                          : 12,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: GoogleFonts.poppins(
                  fontSize: _isMobile(context)
                      ? 12
                      : _isDesktop(context)
                          ? 16
                          : 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF92400E),
                ),
                weekendStyle: GoogleFonts.poppins(
                  fontSize: _isMobile(context)
                      ? 12
                      : _isDesktop(context)
                          ? 16
                          : 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[600],
                ),
              ),
              eventLoader: (day) {
                return _replacementHistory
                    .where((event) => isSameDay(event['date'], day))
                    .toList();
              },
              calendarBuilders: CalendarBuilders(
                // ANIMACIÓN MEJORADA DE LA ABEJITA
                selectedBuilder: (context, day, focusedDay) {
                  return Container(
                    margin: EdgeInsets.all(
                      _isMobile(context)
                          ? 4
                          : _isDesktop(context)
                              ? 8
                              : 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFD97706), Color(0xFFB45309)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD97706).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                        // Sombra adicional para más profundidad
                        BoxShadow(
                          color: const Color(0xFFD97706).withOpacity(0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Número del día
                        Text(
                          '${day.day}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: _isMobile(context)
                                ? 14
                                : _isDesktop(context)
                                    ? 18
                                    : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Abejita mejorada con múltiples animaciones
                        Positioned(
                          top: _isMobile(context)
                              ? -2
                              : _isDesktop(context)
                                  ? -4
                                  : -3,
                          right: _isMobile(context)
                              ? -2
                              : _isDesktop(context)
                                  ? -4
                                  : -3,
                          child: Container(
                            padding: EdgeInsets.all(
                              _isMobile(context)
                                  ? 3
                                  : _isDesktop(context)
                                      ? 5
                                      : 4,
                            ),
                            decoration: BoxDecoration(
                              // Usar el mismo estilo que la fecha actual
                              color: const Color(0xFFFBBF24).withOpacity(0.7),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                                // Sombra dorada para efecto de brillo
                                BoxShadow(
                                  color: const Color(0xFFFBBF24).withOpacity(0.5),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                              // Borde dorado similar al de la fecha actual
                              border: Border.all(
                                color: const Color(0xFFD97706),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              '🐝',
                              style: TextStyle(
                                fontSize: _isMobile(context)
                                    ? 12
                                    : _isDesktop(context)
                                        ? 16
                                        : 14,
                              ),
                            )
                                // Animación de entrada con rebote
                                .animate()
                                .scale(
                                  begin: const Offset(0, 0),
                                  end: const Offset(1, 1),
                                  duration: 600.ms,
                                  curve: Curves.elasticOut,
                                )
                                .then()
                                // Animación continua de pulsación
                                .animate(
                                  onPlay: (controller) =>
                                      controller.repeat(reverse: true),
                                )
                                .scale(
                                  begin: const Offset(1, 1),
                                  end: const Offset(1.2, 1.2),
                                  duration: 1500.ms,
                                  curve: Curves.easeInOut,
                                )
                                // Rotación sutil para simular vuelo
                                .animate(
                                  onPlay: (controller) =>
                                      controller.repeat(reverse: true),
                                )
                                .rotate(
                                  begin: -0.1,
                                  end: 0.1,
                                  duration: 2000.ms,
                                  curve: Curves.easeInOut,
                                )
                                // Efecto de brillo ocasional
                                .animate(
                                  onPlay: (controller) => controller.repeat(),
                                )
                                .shimmer(
                                  duration: 3000.ms,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                          ),
                        ),
                        // Partículas de polen
                        ...List.generate(3, (index) {
                          return Positioned(
                            top: 10 + (index * 8.0),
                            right: 8 + (index * 6.0),
                            child: Container(
                              width: 2,
                              height: 2,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBBF24).withOpacity(0.7),
                                shape: BoxShape.circle,
                              ),
                            )
                                .animate(
                                  onPlay: (controller) => controller.repeat(),
                                )
                                .fadeIn(
                                  delay: Duration(milliseconds: 500 + (index * 200)),
                                  duration: 1000.ms,
                                )
                                .then()
                                .fadeOut(duration: 1000.ms),
                          );
                        }),
                      ],
                    ),
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                  return Container(
                    margin: EdgeInsets.all(
                      _isMobile(context)
                          ? 4
                          : _isDesktop(context)
                              ? 8
                              : 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBBF24).withOpacity(0.7),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD97706),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: _isMobile(context)
                              ? 14
                              : _isDesktop(context)
                                  ? 18
                                  : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
                // Marcadores mejorados con animación
                markerBuilder: (context, day, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF92400E), Color(0xFFFBBF24)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF92400E).withOpacity(0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        width: _isMobile(context)
                            ? 8
                            : _isDesktop(context)
                                ? 12
                                : 10,
                        height: _isMobile(context)
                            ? 8
                            : _isDesktop(context)
                                ? 12
                                : 10,
                      )
                          .animate(
                            onPlay: (controller) => controller.repeat(reverse: true),
                          )
                          .scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1.2, 1.2),
                            duration: 1000.ms,
                          ),
                    );
                  }
                  return null;
                },
              ),
            )
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0);
  }

  // Formulario de reemplazo optimizado
  Widget _buildReplacementForm() {
    return Card(
      elevation: _isDesktop(context) ? 6 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_isDesktop(context) ? 20 : 16),
        side: const BorderSide(color: Color(0xFFFDE68A), width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_isDesktop(context) ? 20 : 16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFEF3C7),
              const Color(0xFFFDE68A).withOpacity(0.3),
            ],
          ),
        ),
        padding: EdgeInsets.all(
          _isMobile(context)
              ? 16
              : _isDesktop(context)
                  ? 24
                  : 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                      '🐝',
                      style: TextStyle(fontSize: _isDesktop(context) ? 20 : 18),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .rotate(begin: -0.1, end: 0.1, duration: 1000.ms),
                SizedBox(width: _isDesktop(context) ? 12 : 8),
                Expanded(
                  child: Text(
                    'Programar Reemplazo',
                    style: GoogleFonts.poppins(
                      fontSize: _isMobile(context)
                          ? 16
                          : _isDesktop(context)
                              ? 18
                              : 17,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF92400E),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (_selectedDay != null)
              Text(
                'Fecha: ${DateFormat('dd/MM/yyyy').format(_selectedDay!)}',
                style: GoogleFonts.poppins(
                  fontSize: _isMobile(context)
                      ? 12
                      : _isDesktop(context)
                          ? 14
                          : 13,
                  color: Colors.black87,
                ),
              ),
            SizedBox(
              height: _isMobile(context)
                  ? 12
                  : _isDesktop(context)
                      ? 16
                      : 14,
            ),

            // Tipo de reina
            Text(
              'Tipo de Reina',
              style: GoogleFonts.poppins(
                fontSize: _isMobile(context)
                    ? 14
                    : _isDesktop(context)
                        ? 16
                        : 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: _isMobile(context)
                  ? 6
                  : _isDesktop(context)
                      ? 10
                      : 8,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  _isDesktop(context) ? 12 : 8,
                ),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedQueenType,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: _isMobile(context)
                        ? 12
                        : _isDesktop(context)
                            ? 16
                            : 14,
                    vertical: _isMobile(context)
                        ? 10
                        : _isDesktop(context)
                            ? 14
                            : 12,
                  ),
                ),
                style: GoogleFonts.poppins(
                  fontSize: _isMobile(context)
                      ? 14
                      : _isDesktop(context)
                          ? 16
                          : 15,
                ),
                items: const [
                  DropdownMenuItem(value: 'Italiana', child: Text('Italiana')),
                  DropdownMenuItem(value: 'Carniola', child: Text('Carniola')),
                  DropdownMenuItem(value: 'Buckfast', child: Text('Buckfast')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedQueenType = value!;
                  });
                },
              ),
            ),
            SizedBox(
              height: _isMobile(context)
                  ? 12
                  : _isDesktop(context)
                      ? 16
                      : 14,
            ),

            // Notas
            Text(
              'Notas',
              style: GoogleFonts.poppins(
                fontSize: _isMobile(context)
                    ? 14
                    : _isDesktop(context)
                        ? 16
                        : 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: _isMobile(context)
                  ? 6
                  : _isDesktop(context)
                      ? 10
                      : 8,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  _isDesktop(context) ? 12 : 8,
                ),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  hintText: 'Añade notas sobre el reemplazo...',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: _isMobile(context)
                        ? 14
                        : _isDesktop(context)
                            ? 16
                            : 15,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: _isMobile(context)
                        ? 12
                        : _isDesktop(context)
                            ? 16
                            : 14,
                    vertical: _isMobile(context)
                        ? 10
                        : _isDesktop(context)
                            ? 14
                            : 12,
                  ),
                ),
                style: GoogleFonts.poppins(
                  fontSize: _isMobile(context)
                      ? 14
                      : _isDesktop(context)
                          ? 16
                          : 15,
                ),
                maxLines: _isMobile(context)
                    ? 3
                    : _isDesktop(context)
                        ? 4
                        : 3,
              ),
            ),
            SizedBox(
              height: _isMobile(context)
                  ? 12
                  : _isDesktop(context)
                      ? 16
                      : 14,
            ),

            // Notificaciones
            Container(
              padding: EdgeInsets.all(_isDesktop(context) ? 16 : 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(
                  _isDesktop(context) ? 12 : 8,
                ),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notificaciones',
                          style: GoogleFonts.poppins(
                            fontSize: _isMobile(context)
                                ? 14
                                : _isDesktop(context)
                                    ? 16
                                    : 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Recibir recordatorios',
                          style: GoogleFonts.poppins(
                            fontSize: _isMobile(context)
                                ? 12
                                : _isDesktop(context)
                                    ? 14
                                    : 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.scale(
                    scale: _isDesktop(context) ? 1.1 : 1.0,
                    child: Switch(
                      value: _enableNotifications,
                      onChanged: (value) {
                        setState(() {
                          _enableNotifications = value;
                        });
                      },
                      activeColor: const Color(0xFFD97706),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _isMobile(context)
                  ? 16
                  : _isDesktop(context)
                      ? 20
                      : 18,
            ),

            // Botones de acción
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveReplacement,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD97706),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: _isMobile(context) ? 12 : 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          _isDesktop(context) ? 12 : 8,
                        ),
                      ),
                      elevation: _isDesktop(context) ? 4 : 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '🐝',
                          style: TextStyle(
                            fontSize: _isDesktop(context) ? 16 : 14,
                          ),
                        ),
                        SizedBox(width: _isDesktop(context) ? 10 : 8),
                        Text(
                          'Programar Reemplazo',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: _isMobile(context) ? 14 : 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: _isDesktop(context) ? 12 : 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => setState(() => _showReplacementForm = false),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: _isMobile(context) ? 12 : 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          _isDesktop(context) ? 12 : 8,
                        ),
                      ),
                      side: const BorderSide(color: Color(0xFFD97706)),
                    ),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF92400E),
                        fontWeight: FontWeight.w600,
                        fontSize: _isMobile(context) ? 14 : 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  // Prompt para seleccionar fecha optimizado
  Widget _buildCalendarPrompt() {
    return Card(
      elevation: _isDesktop(context) ? 6 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_isDesktop(context) ? 20 : 16),
        side: const BorderSide(color: Color(0xFFFDE68A), width: 1),
      ),
      child: Container(
        padding: EdgeInsets.all(
          _isMobile(context)
              ? 20
              : _isDesktop(context)
                  ? 32
                  : 24,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_isDesktop(context) ? 20 : 16),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                  padding: EdgeInsets.all(
                    _isMobile(context)
                        ? 12
                        : _isDesktop(context)
                            ? 16
                            : 14,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEF3C7),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '🐝',
                    style: TextStyle(
                      fontSize: _isMobile(context)
                          ? 28
                          : _isDesktop(context)
                              ? 36
                              : 32,
                    ),
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 1500.ms,
                ),
            SizedBox(
              height: _isMobile(context)
                  ? 12
                  : _isDesktop(context)
                      ? 20
                      : 16,
            ),
            Text(
              'Selecciona una Fecha',
              style: GoogleFonts.poppins(
                fontSize: _isMobile(context)
                    ? 16
                    : _isDesktop(context)
                        ? 18
                        : 17,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF92400E),
              ),
            ),
            SizedBox(
              height: _isMobile(context)
                  ? 8
                  : _isDesktop(context)
                      ? 12
                      : 10,
            ),
            Text(
              'Toca en una fecha del calendario para programar un reemplazo de abeja reina',
              style: GoogleFonts.poppins(
                fontSize: _isMobile(context)
                    ? 12
                    : _isDesktop(context)
                        ? 14
                        : 13,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Tab de Historial optimizado
  Widget _buildHistoryTab() {
    return Padding(
      padding: EdgeInsets.all(
        _isMobile(context)
            ? 16
            : _isTablet(context)
                ? 20
                : 32,
      ),
      child: _isDesktop(context)
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _isLargeDesktop(context) ? 3 : 2,
                crossAxisSpacing: _isLargeDesktop(context) ? 24 : 20,
                mainAxisSpacing: _isLargeDesktop(context) ? 24 : 20,
                childAspectRatio: _isLargeDesktop(context) ? 1.3 : 1.4,
              ),
              itemCount: _replacementHistory.length,
              itemBuilder: (context, index) {
                return _buildHistoryCard(_replacementHistory[index], index);
              },
            )
          : ListView.builder(
              itemCount: _replacementHistory.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: _isMobile(context) ? 16 : 20,
                  ),
                  child: _buildHistoryCard(_replacementHistory[index], index),
                );
              },
            ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item, int index) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(item['date']);

    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (item['status']) {
      case 'completed':
        statusColor = Colors.green[700]!;
        statusIcon = Icons.check_circle;
        statusText = 'Completado';
        break;
      case 'scheduled':
        statusColor = Colors.amber[700]!;
        statusIcon = Icons.schedule;
        statusText = 'Programado';
        break;
      case 'failed':
        statusColor = Colors.red[700]!;
        statusIcon = Icons.cancel;
        statusText = 'Fallido';
        break;
      default:
        statusColor = Colors.grey[700]!;
        statusIcon = Icons.help;
        statusText = 'Desconocido';
    }

    return Card(
          elevation: _isDesktop(context) ? 6 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_isDesktop(context) ? 16 : 12),
            side: const BorderSide(color: Color(0xFFFDE68A), width: 1),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                _isDesktop(context) ? 16 : 12,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  const Color(0xFFFEF3C7).withOpacity(0.3),
                ],
              ),
            ),
            padding: EdgeInsets.all(
              _isMobile(context)
                  ? 16
                  : _isDesktop(context)
                      ? 20
                      : 18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(
                        _isMobile(context)
                            ? 8
                            : _isDesktop(context)
                                ? 12
                                : 10,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFEF3C7),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '🐝',
                        style: TextStyle(
                          fontSize: _isMobile(context)
                              ? 18
                              : _isDesktop(context)
                                  ? 22
                                  : 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: _isMobile(context)
                          ? 12
                          : _isDesktop(context)
                              ? 16
                              : 14,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['colmena'],
                            style: GoogleFonts.poppins(
                              fontSize: _isMobile(context)
                                  ? 16
                                  : _isDesktop(context)
                                      ? 18
                                      : 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Reina: ${item['queenType']}',
                            style: GoogleFonts.poppins(
                              fontSize: _isMobile(context)
                                  ? 14
                                  : _isDesktop(context)
                                      ? 16
                                      : 15,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: _isMobile(context)
                            ? 8
                            : _isDesktop(context)
                                ? 12
                                : 10,
                        vertical: _isMobile(context)
                            ? 4
                            : _isDesktop(context)
                                ? 6
                                : 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            statusIcon,
                            size: _isMobile(context)
                                ? 14
                                : _isDesktop(context)
                                    ? 16
                                    : 15,
                            color: statusColor,
                          ),
                          SizedBox(
                            width: _isMobile(context)
                                ? 4
                                : _isDesktop(context)
                                    ? 6
                                    : 5,
                          ),
                          Text(
                            statusText,
                            style: GoogleFonts.poppins(
                              fontSize: _isMobile(context)
                                  ? 12
                                  : _isDesktop(context)
                                      ? 14
                                      : 13,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: _isMobile(context)
                      ? 12
                      : _isDesktop(context)
                          ? 16
                          : 14,
                ),
                const Divider(),
                SizedBox(
                  height: _isMobile(context)
                      ? 8
                      : _isDesktop(context)
                          ? 12
                          : 10,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: _isMobile(context)
                          ? 14
                          : _isDesktop(context)
                                  ? 16
                                  : 15,
                      color: Colors.black54,
                    ),
                    SizedBox(
                      width: _isMobile(context)
                          ? 4
                          : _isDesktop(context)
                                  ? 6
                                  : 5,
                    ),
                    Text(
                      'Fecha: $formattedDate',
                      style: GoogleFonts.poppins(
                        fontSize: _isMobile(context)
                            ? 14
                            : _isDesktop(context)
                                  ? 16
                                  : 15,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: _isMobile(context)
                      ? 8
                      : _isDesktop(context)
                          ? 12
                          : 10,
                ),
                Text(
                  'Notas:',
                  style: GoogleFonts.poppins(
                    fontSize: _isMobile(context)
                        ? 14
                        : _isDesktop(context)
                            ? 16
                            : 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  item['notes'],
                  style: GoogleFonts.poppins(
                    fontSize: _isMobile(context)
                        ? 14
                        : _isDesktop(context)
                            ? 16
                            : 15,
                  ),
                  maxLines: _isMobile(context)
                      ? 2
                      : _isDesktop(context)
                          ? 3
                          : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 100 * index), duration: 400.ms)
        .slideY(begin: 0.1, end: 0);
  }

  // Tab de Notificaciones optimizado
  Widget _buildNotificationsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        _isMobile(context)
            ? 16
            : _isTablet(context)
                ? 20
                : 32,
      ),
      child: Card(
        elevation: _isDesktop(context) ? 6 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_isDesktop(context) ? 20 : 16),
          side: const BorderSide(color: Color(0xFFFDE68A), width: 1),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_isDesktop(context) ? 20 : 16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, const Color(0xFFFEF3C7).withOpacity(0.3)],
            ),
          ),
          padding: EdgeInsets.all(
            _isMobile(context)
                ? 16
                : _isDesktop(context)
                    ? 32
                    : 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '🔔',
                    style: TextStyle(fontSize: _isDesktop(context) ? 24 : 20),
                  ),
                  SizedBox(width: _isDesktop(context) ? 16 : 12),
                  Expanded(
                    child: Text(
                      'Configuración de Notificaciones',
                      style: GoogleFonts.poppins(
                        fontSize: _isMobile(context)
                            ? 18
                            : _isDesktop(context)
                                ? 22
                                : 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF92400E),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: _isMobile(context)
                    ? 8
                    : _isDesktop(context)
                        ? 12
                        : 10,
              ),
              Text(
                'Personaliza cómo y cuándo quieres recibir notificaciones sobre el reemplazo de abejas reinas',
                style: GoogleFonts.poppins(
                  fontSize: _isMobile(context)
                      ? 14
                      : _isDesktop(context)
                          ? 16
                          : 15,
                  color: Colors.black54,
                ),
              ),
              SizedBox(
                height: _isMobile(context)
                    ? 20
                    : _isDesktop(context)
                        ? 28
                        : 24,
              ),

              // Configuración principal de notificaciones
              _buildNotificationSetting(
                title: 'Notificaciones',
                subtitle: 'Activa o desactiva todas las notificaciones',
                icon: Icons.notifications,
                isEnabled: _enableNotifications,
                onChanged: (value) {
                  setState(() {
                    _enableNotifications = value;
                  });
                },
              ),
              SizedBox(height: _isDesktop(context) ? 24 : 20),

              Text(
                'Recordatorios',
                style: GoogleFonts.poppins(
                  fontSize: _isMobile(context)
                      ? 16
                      : _isDesktop(context)
                          ? 18
                          : 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: _isMobile(context)
                    ? 12
                    : _isDesktop(context)
                        ? 16
                        : 14,
              ),

              // Grid responsivo para recordatorios
              if (_isDesktop(context))
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildNotificationOption(
                            title: 'Un día antes',
                            icon: Icons.today,
                            isEnabled: _reminderDayBefore,
                            onChanged: (value) {
                              setState(() {
                                _reminderDayBefore = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildNotificationOption(
                            title: 'Día del reemplazo',
                            icon: Icons.event,
                            isEnabled: _reminderDayOf,
                            onChanged: (value) {
                              setState(() {
                                _reminderDayOf = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNotificationOption(
                            title: 'Una semana antes',
                            icon: Icons.date_range,
                            isEnabled: _reminderWeekBefore,
                            onChanged: (value) {
                              setState(() {
                                _reminderWeekBefore = value;
                              });
                            },
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    _buildNotificationOption(
                      title: 'Un día antes',
                      icon: Icons.today,
                      isEnabled: _reminderDayBefore,
                      onChanged: (value) {
                        setState(() {
                          _reminderDayBefore = value;
                        });
                      },
                    ),
                    SizedBox(height: _isMobile(context) ? 12 : 16),
                    _buildNotificationOption(
                      title: 'Día del reemplazo',
                      icon: Icons.event,
                      isEnabled: _reminderDayOf,
                      onChanged: (value) {
                        setState(() {
                          _reminderDayOf = value;
                        });
                      },
                    ),
                    SizedBox(height: _isMobile(context) ? 12 : 16),
                    _buildNotificationOption(
                      title: 'Una semana antes',
                      icon: Icons.date_range,
                      isEnabled: _reminderWeekBefore,
                      onChanged: (value) {
                        setState(() {
                          _reminderWeekBefore = value;
                        });
                      },
                    ),
                  ],
                ),

              SizedBox(height: _isDesktop(context) ? 24 : 20),

              Text(
                'Canales de Notificación',
                style: GoogleFonts.poppins(
                  fontSize: _isMobile(context)
                      ? 16
                      : _isDesktop(context)
                          ? 18
                          : 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: _isMobile(context)
                    ? 12
                    : _isDesktop(context)
                        ? 16
                        : 14,
              ),
              _buildNotificationChannel(
                title: 'Notificaciones Push',
                subtitle: 'En tu dispositivo',
                icon: Icons.smartphone,
                isEnabled: _pushNotifications,
                onChanged: (value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                },
              ),
              SizedBox(
                height: _isMobile(context)
                    ? 12
                    : _isDesktop(context)
                        ? 16
                        : 14,
              ),
              _buildNotificationChannel(
                title: 'Correo Electrónico',
                subtitle: 'usuario@ejemplo.com',
                icon: Icons.email,
                isEnabled: _emailNotifications,
                onChanged: (value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                },
              ),
              SizedBox(
                height: _isMobile(context)
                    ? 20
                    : _isDesktop(context)
                        ? 28
                        : 24,
              ),

              // Botón guardar mejorado para desktop
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Configuración de notificaciones guardada',
                          style: GoogleFonts.poppins(),
                        ),
                        backgroundColor: Colors.green[700],
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD97706),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: _isMobile(context)
                          ? 12
                          : _isDesktop(context)
                              ? 16
                              : 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        _isDesktop(context) ? 12 : 8,
                      ),
                    ),
                    elevation: _isDesktop(context) ? 4 : 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '💾',
                        style: TextStyle(
                          fontSize: _isDesktop(context) ? 16 : 14,
                        ),
                      ),
                      SizedBox(width: _isDesktop(context) ? 10 : 8),
                      Text(
                        'Guardar Configuración',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: _isMobile(context)
                              ? 14
                              : _isDesktop(context)
                                  ? 16
                                  : 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0),
    );
  }

  // Configuración de notificaciones con mejor diseño para desktop
  Widget _buildNotificationSetting({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isEnabled,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(
        _isMobile(context)
            ? 12
            : _isDesktop(context)
                ? 18
                : 15,
      ),
      decoration: BoxDecoration(
        color: isEnabled ? const Color(0xFFFEF3C7) : Colors.grey[100],
        borderRadius: BorderRadius.circular(_isDesktop(context) ? 12 : 8),
        border: Border.all(
          color: isEnabled ? const Color(0xFFFDE68A) : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: _isMobile(context)
                        ? 16
                        : _isDesktop(context)
                            ? 18
                            : 17,
                    fontWeight: FontWeight.w600,
                    color: isEnabled ? Colors.black87 : Colors.grey,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: _isMobile(context)
                        ? 14
                        : _isDesktop(context)
                            ? 16
                            : 15,
                    color: isEnabled ? Colors.black54 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: _isDesktop(context) ? 1.2 : 1.0,
            child: Switch(
              value: isEnabled,
              onChanged: onChanged,
              activeColor: const Color(0xFFD97706),
            ),
          ),
          SizedBox(
            width: _isMobile(context)
                ? 8
                : _isDesktop(context)
                    ? 12
                    : 10,
          ),
          Icon(
            icon,
            color: isEnabled ? const Color(0xFFD97706) : Colors.grey,
            size: _isMobile(context)
                ? 24
                : _isDesktop(context)
                    ? 28
                    : 26,
          ),
        ],
      ),
    );
  }

  // Opción de notificación con mejor diseño para desktop
  Widget _buildNotificationOption({
    required String title,
    required IconData icon,
    required bool isEnabled,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(
        _isMobile(context)
            ? 12
            : _isDesktop(context)
                ? 16
                : 14,
      ),
      decoration: BoxDecoration(
        color: isEnabled ? const Color(0xFFFEF3C7) : Colors.grey[100],
        borderRadius: BorderRadius.circular(_isDesktop(context) ? 12 : 8),
        border: Border.all(
          color: isEnabled ? const Color(0xFFFDE68A) : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: _isMobile(context)
                ? 20
                : _isDesktop(context)
                    ? 24
                    : 22,
            color: isEnabled ? const Color(0xFF92400E) : Colors.grey,
          ),
          SizedBox(
            width: _isMobile(context)
                ? 12
                : _isDesktop(context)
                    ? 16
                    : 14,
          ),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: _isMobile(context)
                    ? 14
                    : _isDesktop(context)
                        ? 16
                        : 15,
                fontWeight: FontWeight.w500,
                color: isEnabled ? Colors.black87 : Colors.grey,
              ),
            ),
          ),
          Transform.scale(
            scale: _isDesktop(context) ? 1.1 : 1.0,
            child: Switch(
              value: isEnabled,
              onChanged: onChanged,
              activeColor: const Color(0xFFD97706),
            ),
          ),
        ],
      ),
    );
  }

  // Canal de notificación con mejor diseño para desktop
  Widget _buildNotificationChannel({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isEnabled,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(
        _isMobile(context)
            ? 12
            : _isDesktop(context)
                ? 16
                : 14,
      ),
      decoration: BoxDecoration(
        color: isEnabled ? const Color(0xFFFEF3C7) : Colors.grey[100],
        borderRadius: BorderRadius.circular(_isDesktop(context) ? 12 : 8),
        border: Border.all(
          color: isEnabled ? const Color(0xFFFDE68A) : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
              _isMobile(context)
                  ? 8
                  : _isDesktop(context)
                      ? 12
                      : 10,
            ),
            decoration: BoxDecoration(
              color: isEnabled ? const Color(0xFFFEF3C7) : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: _isMobile(context)
                  ? 20
                  : _isDesktop(context)
                      ? 24
                      : 22,
              color: isEnabled ? const Color(0xFF92400E) : Colors.grey,
            ),
          ),
          SizedBox(
            width: _isMobile(context)
                ? 12
                : _isDesktop(context)
                    ? 16
                    : 14,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: _isMobile(context)
                        ? 14
                        : _isDesktop(context)
                            ? 16
                            : 15,
                    fontWeight: FontWeight.w600,
                    color: isEnabled ? Colors.black87 : Colors.grey,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: _isMobile(context)
                        ? 12
                        : _isDesktop(context)
                            ? 14
                            : 13,
                    color: isEnabled ? Colors.black54 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: _isDesktop(context) ? 1.1 : 1.0,
            child: Switch(
              value: isEnabled,
              onChanged: onChanged,
              activeColor: const Color(0xFFD97706),
            ),
          ),
        ],
      ),
    );
  }
}