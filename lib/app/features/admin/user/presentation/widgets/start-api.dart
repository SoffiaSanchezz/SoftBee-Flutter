import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class StatItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final int delay;
  final Color color;
  final bool isTablet;

  StatItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.delay,
    required this.color,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
              padding: EdgeInsets.all(isTablet ? 12 : 10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: isTablet ? 32 : 28),
            )
            .animate()
            .fadeIn(duration: 600.ms, delay: delay.ms)
            .scale(delay: delay.ms),
        SizedBox(height: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ).animate().fadeIn(duration: 600.ms, delay: (delay + 100).ms),
        SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 16 : 14,
            color: Colors.black54,
          ),
        ).animate().fadeIn(duration: 600.ms, delay: (delay + 200).ms),
      ],
    );
  }
}
