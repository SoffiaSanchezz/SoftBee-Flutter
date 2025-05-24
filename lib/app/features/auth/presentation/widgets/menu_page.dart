import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:soft_bee/app/features/admin/user/presentation/page/user_config_page.dart';
import 'package:soft_bee/main.dart';


class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<MenuItemData> _menuItems = [
    MenuItemData(
      title: 'Monitoreo',
      icon: Icons.monitor,
      color: Color(0xFFFBC209),
      route: MyApp(),
      // MonitoreoColmenas(),
    ),
    MenuItemData(
      title: 'Inventario',
      icon: Icons.inventory,
      color: Color(0xFFFFA500),
      route: MyApp(),
      // InventarioApiario(),
    ),
    MenuItemData(
      title: 'Informes',
      icon: Icons.insert_chart,
      color: Color(0xFFFFB700),
      route: MyApp(),
      // InformesHistorial(),
    ),
    MenuItemData(
      title: 'Historial',
      icon: Icons.history,
      color: Color(0xFFFF9800),
      route: MyApp(),
      // HistorialInspeccionesScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFFFF8E1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [_buildHeader(), Expanded(child: _buildResponsiveMenu())],
          ),
        ),
      ),
    );
  }

  // HEADER
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                        Icons.hexagon_outlined,
                        color: Color(0xFFFBC209),
                        size: 40,
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .rotate(duration: 3.seconds, curve: Curves.easeInOut),
                  SizedBox(width: 12),
                  Text(
                        'SoftBee',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .slideX(
                        begin: -0.2,
                        end: 0,
                        duration: 800.ms,
                        curve: Curves.easeOutQuad,
                      ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserConfigPage()),
                  );
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('/images/userSoftbee.png'),
                ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
              ),
            ],
          ),
          SizedBox(height: 50),
          Text(
                'Menú Principal',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFBC209),
                ),
              )
              .animate()
              .fadeIn(duration: 800.ms, delay: 300.ms)
              .slideY(begin: 0.2, end: 0, duration: 800.ms, delay: 300.ms),
          SizedBox(height: 8),
          Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: Color(0xFFFBC209),
                  borderRadius: BorderRadius.circular(2),
                ),
              )
              .animate()
              .fadeIn(duration: 800.ms, delay: 500.ms)
              .slideX(begin: 0.2, end: 0, duration: 800.ms, delay: 500.ms)
              .then(delay: 200.ms)
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scaleX(begin: 1, end: 1.2, duration: 1.5.seconds),
        ],
      ),
    );
  }

  // RESPONSIVE MENU
  Widget _buildResponsiveMenu() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determinar el número de columnas según el ancho de la pantalla
        int crossAxisCount;
        double childAspectRatio;

        if (constraints.maxWidth < 600) {
          // Móvil: 2 columnas
          crossAxisCount = 2;
          childAspectRatio = 1.1;
        } else if (constraints.maxWidth < 900) {
          // Tablet: 4 columnas (todos los elementos en una fila)
          crossAxisCount = 2;
          childAspectRatio = 1.9;
        } else {
          // Pantalla grande: 4 columnas con proporción ajustada
          crossAxisCount = 4;
          childAspectRatio = 1.2;
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: _menuItems.length,
            itemBuilder: (context, index) {
              final item = _menuItems[index];
              return AnimatedMenuButton(
                    title: item.title,
                    icon: item.icon,
                    color: item.color,
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => item.route,
                          transitionsBuilder: (_, animation, __, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                    begin: Offset(1.0, 0.0),
                                    end: Offset.zero,
                                  )
                                  .chain(
                                    CurveTween(curve: Curves.easeInOutQuart),
                                  )
                                  .animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: (200 * index).ms)
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    duration: 600.ms,
                    delay: (200 * index).ms,
                    curve: Curves.easeOutQuint,
                  )
                  .then(delay: 200.ms)
                  .shimmer(duration: 1.seconds, delay: (200 * index).ms);
            },
          ),
        );
      },
    );
  }
}

class MenuItemData {
  final String title;
  final IconData icon;
  final Color color;
  final Widget route;

  MenuItemData({
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
  });
}

class AnimatedMenuButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  AnimatedMenuButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  _AnimatedMenuButtonState createState() => _AnimatedMenuButtonState();
}

class _AnimatedMenuButtonState extends State<AnimatedMenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();
  void _onTapUp(TapUpDetails details) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedBuilder(
          animation: _controller,
          builder:
              (context, child) =>
                  Transform.scale(scale: _scaleAnimation.value, child: child),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [widget.color.withOpacity(0.8), widget.color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(_isHovered ? 0.4 : 0.2),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Opacity(
                      opacity: 0.2,
                      child: Icon(widget.icon, size: 120, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        Text(
                          widget.title,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
