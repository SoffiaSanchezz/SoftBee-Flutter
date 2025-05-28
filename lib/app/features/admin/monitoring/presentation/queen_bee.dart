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

  // Responsive breakpoints
  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 640;
  bool _isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 640 &&
      MediaQuery.of(context).size.width < 1024;
  bool _isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

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
                child: TabBarView(
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

  // Header mejorado con diseño responsivo
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
          // Header principal
          Padding(
            padding: EdgeInsets.all(
              _isMobile(context)
                  ? 16
                  : _isTablet(context)
                  ? 20
                  : 24,
            ),
            child: Column(
              children: [
                // Título y acciones
                Row(
                  children: [
                    Container(
                          padding: EdgeInsets.all(_isMobile(context) ? 12 : 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            // backdropFilter: ImageFilter.blur(
                            //   sigmaX: 10,
                            //   sigmaY: 10,
                            // ),
                          ),
                          child: Icon(
                            Icons.change_circle,
                            size:
                                _isMobile(context)
                                    ? 32
                                    : _isTablet(context)
                                    ? 36
                                    : 40,
                            color: Colors.white,
                          ),
                        )
                        .animate(
                          onPlay:
                              (controller) => controller.repeat(reverse: true),
                        )
                        .rotate(begin: -0.05, end: 0.05, duration: 2000.ms),
                    SizedBox(width: _isMobile(context) ? 12 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                                widget.colmenaNombre,
                                style: GoogleFonts.poppins(
                                  fontSize:
                                      _isMobile(context)
                                          ? 24
                                          : _isTablet(context)
                                          ? 28
                                          : 32,
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
                                  fontSize: _isMobile(context) ? 14 : 16,
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
                              iconSize: _isMobile(context) ? 24 : 28,
                            )
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .scale(begin: const Offset(0.5, 0.5)),
                        IconButton(
                              icon: const Icon(
                                Icons.share_outlined,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                              iconSize: _isMobile(context) ? 24 : 28,
                            )
                            .animate()
                            .fadeIn(delay: 400.ms)
                            .scale(begin: const Offset(0.5, 0.5)),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: _isMobile(context) ? 20 : 24),

                // Stats grid responsivo
                _buildStatsGrid(),
              ],
            ),
          ),

          // Tab bar
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white24, width: 1)),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelStyle: GoogleFonts.poppins(
                fontSize:
                    _isMobile(context)
                        ? 12
                        : _isTablet(context)
                        ? 14
                        : 16,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontSize:
                    _isMobile(context)
                        ? 12
                        : _isTablet(context)
                        ? 14
                        : 16,
                fontWeight: FontWeight.w500,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.calendar_today,
                    size:
                        _isMobile(context)
                            ? 20
                            : _isTablet(context)
                            ? 22
                            : 24,
                  ),
                  text: _isMobile(context) ? null : 'Calendario',
                ),
                Tab(
                  icon: Icon(
                    Icons.history,
                    size:
                        _isMobile(context)
                            ? 20
                            : _isTablet(context)
                            ? 22
                            : 24,
                  ),
                  text: _isMobile(context) ? null : 'Historial',
                ),
                Tab(
                  icon: Icon(
                    Icons.notifications,
                    size:
                        _isMobile(context)
                            ? 20
                            : _isTablet(context)
                            ? 22
                            : 24,
                  ),
                  text: _isMobile(context) ? null : 'Notificaciones',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Grid de estadísticas responsivo
  Widget _buildStatsGrid() {
    final stats = [
      {
        'icon': Icons.calendar_today_outlined,
        'label': 'Próximo Reemplazo',
        'value':
            _selectedDay != null
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
        children:
            stats.asMap().entries.map((entry) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: entry.key < stats.length - 1 ? 16 : 0,
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
          padding: EdgeInsets.all(_isMobile(context) ? 12 : 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            // backdropFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          ),
          child: Column(
            children: [
              Icon(
                    stat['icon'],
                    size: _isMobile(context) ? 20 : 24,
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
              SizedBox(height: _isMobile(context) ? 4 : 6),
              Text(
                stat['label'],
                style: GoogleFonts.poppins(
                  fontSize: _isMobile(context) ? 10 : 12,
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                stat['value'],
                style: GoogleFonts.poppins(
                  fontSize: _isMobile(context) ? 12 : 14,
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

  // Tab de Calendario mejorado
  Widget _buildCalendarTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        _isMobile(context)
            ? 16
            : _isTablet(context)
            ? 20
            : 24,
      ),
      child:
          _isDesktop(context)
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildCalendarCard()),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 1,
                    child:
                        _showReplacementForm
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

  Widget _buildCalendarCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFFDE68A), width: 1), // amber-200
      ),
      child: Padding(
        padding: EdgeInsets.all(
          _isMobile(context)
              ? 12
              : _isTablet(context)
              ? 16
              : 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seleccionar Fecha',
              style: GoogleFonts.poppins(
                fontSize: _isMobile(context) ? 18 : 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF92400E), // amber-800
              ),
            ),
            const SizedBox(height: 16),
            TableCalendar(
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              enabledDayPredicate:
                  (day) => day.isAfter(
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
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: const Color(0xFFFBBF24).withOpacity(0.5), // amber-400
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Color(0xFFD97706), // amber-600
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: Color(0xFF92400E), // amber-800
                  shape: BoxShape.circle,
                ),
                disabledDecoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                cellMargin: EdgeInsets.all(_isMobile(context) ? 2 : 4),
                defaultTextStyle: GoogleFonts.poppins(
                  fontSize: _isMobile(context) ? 14 : 16,
                ),
                weekendTextStyle: GoogleFonts.poppins(
                  fontSize: _isMobile(context) ? 14 : 16,
                  color: Colors.red[600],
                ),
                disabledTextStyle: GoogleFonts.poppins(
                  fontSize: _isMobile(context) ? 14 : 16,
                  color: Colors.grey[400],
                ),
              ),
              headerStyle: HeaderStyle(
                titleCentered: true,
                titleTextStyle: GoogleFonts.poppins(
                  fontSize: _isMobile(context) ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
                formatButtonDecoration: BoxDecoration(
                  color: const Color(0xFFFBBF24), // amber-400
                  borderRadius: BorderRadius.circular(20),
                ),
                formatButtonTextStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: _isMobile(context) ? 12 : 14,
                  fontWeight: FontWeight.w600,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  size: _isMobile(context) ? 20 : 24,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  size: _isMobile(context) ? 20 : 24,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: GoogleFonts.poppins(
                  fontSize: _isMobile(context) ? 12 : 14,
                  fontWeight: FontWeight.w600,
                ),
                weekendStyle: GoogleFonts.poppins(
                  fontSize: _isMobile(context) ? 12 : 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[600],
                ),
              ),
              eventLoader: (day) {
                return _replacementHistory
                    .where((event) => isSameDay(event['date'], day))
                    .toList();
              },
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0);
  }

  // Formulario de reemplazo mejorado
  Widget _buildReplacementForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFFDE68A), width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFEF3C7), // amber-50
              const Color(0xFFFDE68A).withOpacity(0.3), // amber-200
            ],
          ),
        ),
        padding: EdgeInsets.all(
          _isMobile(context)
              ? 16
              : _isTablet(context)
              ? 18
              : 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Programar Reemplazo',
              style: GoogleFonts.poppins(
                fontSize: _isMobile(context) ? 18 : 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF92400E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Fecha seleccionada: ${DateFormat('dd/MM/yyyy').format(_selectedDay!)}',
              style: GoogleFonts.poppins(
                fontSize: _isMobile(context) ? 14 : 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: _isMobile(context) ? 16 : 20),

            // Tipo de reina
            Text(
              'Tipo de Reina',
              style: GoogleFonts.poppins(
                fontSize: _isMobile(context) ? 14 : 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: _isMobile(context) ? 8 : 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedQueenType,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: _isMobile(context) ? 12 : 16,
                    vertical: _isMobile(context) ? 12 : 16,
                  ),
                ),
                style: GoogleFonts.poppins(
                  fontSize: _isMobile(context) ? 14 : 16,
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
            SizedBox(height: _isMobile(context) ? 16 : 20),

            // Notas
            Text(
              'Notas',
              style: GoogleFonts.poppins(
                fontSize: _isMobile(context) ? 14 : 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: _isMobile(context) ? 8 : 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  hintText: 'Añade notas sobre el reemplazo...',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: _isMobile(context) ? 14 : 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: _isMobile(context) ? 12 : 16,
                    vertical: _isMobile(context) ? 12 : 16,
                  ),
                ),
                style: GoogleFonts.poppins(
                  fontSize: _isMobile(context) ? 14 : 16,
                ),
                maxLines: _isMobile(context) ? 3 : 4,
              ),
            ),
            SizedBox(height: _isMobile(context) ? 16 : 20),

            // Notificaciones
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
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
                            fontSize: _isMobile(context) ? 14 : 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Recibir recordatorios',
                          style: GoogleFonts.poppins(
                            fontSize: _isMobile(context) ? 12 : 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _enableNotifications,
                    onChanged: (value) {
                      setState(() {
                        _enableNotifications = value;
                      });
                    },
                    activeColor: const Color(0xFFD97706),
                  ),
                ],
              ),
            ),
            SizedBox(height: _isMobile(context) ? 20 : 24),

            // Botones
            _isMobile(context) || _isTablet(context)
                ? Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _showReplacementForm = false;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: _isMobile(context) ? 12 : 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
                    SizedBox(width: _isMobile(context) ? 12 : 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveReplacement,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD97706),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: _isMobile(context) ? 12 : 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Programar',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: _isMobile(context) ? 14 : 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                : Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveReplacement,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD97706),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Programar',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _showReplacementForm = false;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(color: Color(0xFFD97706)),
                        ),
                        child: Text(
                          'Cancelar',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF92400E),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
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

  // Prompt para seleccionar fecha mejorado
  Widget _buildCalendarPrompt() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFFDE68A), width: 1),
      ),
      child: Container(
        padding: EdgeInsets.all(
          _isMobile(context)
              ? 20
              : _isTablet(context)
              ? 22
              : 24,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                  padding: EdgeInsets.all(_isMobile(context) ? 12 : 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7), // amber-100
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    size:
                        _isMobile(context)
                            ? 32
                            : _isTablet(context)
                            ? 36
                            : 40,
                    color: const Color(0xFF92400E), // amber-800
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
            SizedBox(height: _isMobile(context) ? 16 : 20),
            Text(
              'Selecciona una Fecha',
              style: GoogleFonts.poppins(
                fontSize:
                    _isMobile(context)
                        ? 16
                        : _isTablet(context)
                        ? 17
                        : 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF92400E),
              ),
            ),
            SizedBox(height: _isMobile(context) ? 8 : 10),
            Text(
              'Toca en una fecha del calendario para programar un reemplazo de abeja reina',
              style: GoogleFonts.poppins(
                fontSize:
                    _isMobile(context)
                        ? 14
                        : _isTablet(context)
                        ? 15
                        : 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Tab de Historial mejorado
  Widget _buildHistoryTab() {
    return Padding(
      padding: EdgeInsets.all(
        _isMobile(context)
            ? 16
            : _isTablet(context)
            ? 20
            : 24,
      ),
      child:
          _isDesktop(context)
              ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.6,
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
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFFDE68A), width: 1),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
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
                  : _isTablet(context)
                  ? 18
                  : 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(_isMobile(context) ? 8 : 10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFEF3C7), // amber-100
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.change_circle,
                        color: const Color(0xFF92400E), // amber-800
                        size:
                            _isMobile(context)
                                ? 24
                                : _isTablet(context)
                                ? 26
                                : 28,
                      ),
                    ),
                    SizedBox(width: _isMobile(context) ? 12 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['colmena'],
                            style: GoogleFonts.poppins(
                              fontSize:
                                  _isMobile(context)
                                      ? 16
                                      : _isTablet(context)
                                      ? 17
                                      : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Reina: ${item['queenType']}',
                            style: GoogleFonts.poppins(
                              fontSize:
                                  _isMobile(context)
                                      ? 14
                                      : _isTablet(context)
                                      ? 15
                                      : 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: _isMobile(context) ? 8 : 12,
                        vertical: _isMobile(context) ? 4 : 6,
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
                            size: _isMobile(context) ? 14 : 16,
                            color: statusColor,
                          ),
                          SizedBox(width: _isMobile(context) ? 4 : 6),
                          Text(
                            statusText,
                            style: GoogleFonts.poppins(
                              fontSize: _isMobile(context) ? 12 : 14,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: _isMobile(context) ? 12 : 16),
                const Divider(),
                SizedBox(height: _isMobile(context) ? 8 : 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: _isMobile(context) ? 14 : 16,
                      color: Colors.black54,
                    ),
                    SizedBox(width: _isMobile(context) ? 4 : 6),
                    Text(
                      'Fecha: $formattedDate',
                      style: GoogleFonts.poppins(
                        fontSize:
                            _isMobile(context)
                                ? 14
                                : _isTablet(context)
                                ? 15
                                : 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: _isMobile(context) ? 8 : 12),
                Text(
                  'Notas:',
                  style: GoogleFonts.poppins(
                    fontSize:
                        _isMobile(context)
                            ? 14
                            : _isTablet(context)
                            ? 15
                            : 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  item['notes'],
                  style: GoogleFonts.poppins(
                    fontSize:
                        _isMobile(context)
                            ? 14
                            : _isTablet(context)
                            ? 15
                            : 16,
                  ),
                  maxLines: _isMobile(context) ? 2 : 3,
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

  // Tab de Notificaciones mejorado
  Widget _buildNotificationsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        _isMobile(context)
            ? 16
            : _isTablet(context)
            ? 20
            : 24,
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFFDE68A), width: 1),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, const Color(0xFFFEF3C7).withOpacity(0.3)],
            ),
          ),
          padding: EdgeInsets.all(
            _isMobile(context)
                ? 16
                : _isTablet(context)
                ? 20
                : 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configuración de Notificaciones',
                style: GoogleFonts.poppins(
                  fontSize:
                      _isMobile(context)
                          ? 18
                          : _isTablet(context)
                          ? 20
                          : 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF92400E),
                ),
              ),
              SizedBox(height: _isMobile(context) ? 8 : 10),
              Text(
                'Personaliza cómo y cuándo quieres recibir notificaciones sobre el reemplazo de abejas reinas',
                style: GoogleFonts.poppins(
                  fontSize:
                      _isMobile(context)
                          ? 14
                          : _isTablet(context)
                          ? 15
                          : 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: _isMobile(context) ? 20 : 24),

              // Activar/desactivar notificaciones principales
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
              const Divider(height: 32),

              // Tipos de recordatorios
              Text(
                'Recordatorios',
                style: GoogleFonts.poppins(
                  fontSize:
                      _isMobile(context)
                          ? 16
                          : _isTablet(context)
                          ? 17
                          : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: _isMobile(context) ? 12 : 16),

              // Grid responsivo para opciones de notificación
              _isDesktop(context)
                  ? Column(
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
                          const SizedBox(width: 16),
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
                      const SizedBox(height: 16),
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
                  : Column(
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

              const Divider(height: 32),

              // Canales de notificación
              Text(
                'Canales de Notificación',
                style: GoogleFonts.poppins(
                  fontSize:
                      _isMobile(context)
                          ? 16
                          : _isTablet(context)
                          ? 17
                          : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: _isMobile(context) ? 12 : 16),
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
              SizedBox(height: _isMobile(context) ? 12 : 16),
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
              SizedBox(height: _isMobile(context) ? 20 : 24),

              // Botón guardar
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
                      vertical:
                          _isMobile(context)
                              ? 12
                              : _isTablet(context)
                              ? 14
                              : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Guardar Configuración',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize:
                          _isMobile(context)
                              ? 14
                              : _isTablet(context)
                              ? 15
                              : 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0),
    );
  }

  // Configuración de notificaciones
  Widget _buildNotificationSetting({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isEnabled,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(_isMobile(context) ? 12 : 16),
      decoration: BoxDecoration(
        color: isEnabled ? const Color(0xFFFEF3C7) : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
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
                    fontSize:
                        _isMobile(context)
                            ? 16
                            : _isTablet(context)
                            ? 17
                            : 18,
                    fontWeight: FontWeight.w600,
                    color: isEnabled ? Colors.black87 : Colors.grey,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize:
                        _isMobile(context)
                            ? 14
                            : _isTablet(context)
                            ? 15
                            : 16,
                    color: isEnabled ? Colors.black54 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onChanged,
            activeColor: const Color(0xFFD97706),
          ),
          SizedBox(width: _isMobile(context) ? 8 : 12),
          Icon(
            icon,
            color: isEnabled ? const Color(0xFFD97706) : Colors.grey,
            size:
                _isMobile(context)
                    ? 24
                    : _isTablet(context)
                    ? 26
                    : 28,
          ),
        ],
      ),
    );
  }

  // Opción de notificación
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
            : _isTablet(context)
            ? 14
            : 16,
      ),
      decoration: BoxDecoration(
        color: isEnabled ? const Color(0xFFFEF3C7) : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isEnabled ? const Color(0xFFFDE68A) : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size:
                _isMobile(context)
                    ? 20
                    : _isTablet(context)
                    ? 22
                    : 24,
            color: isEnabled ? const Color(0xFF92400E) : Colors.grey,
          ),
          SizedBox(width: _isMobile(context) ? 12 : 16),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize:
                    _isMobile(context)
                        ? 14
                        : _isTablet(context)
                        ? 15
                        : 16,
                fontWeight: FontWeight.w500,
                color: isEnabled ? Colors.black87 : Colors.grey,
              ),
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onChanged,
            activeColor: const Color(0xFFD97706),
          ),
        ],
      ),
    );
  }

  // Canal de notificación
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
            : _isTablet(context)
            ? 14
            : 16,
      ),
      decoration: BoxDecoration(
        color: isEnabled ? const Color(0xFFFEF3C7) : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isEnabled ? const Color(0xFFFDE68A) : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(_isMobile(context) ? 8 : 10),
            decoration: BoxDecoration(
              color: isEnabled ? const Color(0xFFFEF3C7) : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size:
                  _isMobile(context)
                      ? 20
                      : _isTablet(context)
                      ? 22
                      : 24,
              color: isEnabled ? const Color(0xFF92400E) : Colors.grey,
            ),
          ),
          SizedBox(width: _isMobile(context) ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize:
                        _isMobile(context)
                            ? 14
                            : _isTablet(context)
                            ? 15
                            : 16,
                    fontWeight: FontWeight.w600,
                    color: isEnabled ? Colors.black87 : Colors.grey,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize:
                        _isMobile(context)
                            ? 12
                            : _isTablet(context)
                            ? 13
                            : 14,
                    color: isEnabled ? Colors.black54 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onChanged,
            activeColor: const Color(0xFFD97706),
          ),
        ],
      ),
    );
  }
}
