import 'package:flutter/material.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                const Text(
                  'TIC',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFE94560),
                    letterSpacing: 8,
                    height: 1.0,
                  ),
                ),
                const Text(
                  'TAC',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 8,
                    height: 1.0,
                  ),
                ),
                const Text(
                  'TOE',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF4FC3F7),
                    letterSpacing: 8,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 16),
                // Grid icon decoration
                _buildGridDecoration(),
                const SizedBox(height: 60),
                // Play button
                _buildPlayButton(context),
                const SizedBox(height: 24),
                const Text(
                  'Classic 2-Player Game',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridDecoration() {
    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(
        painter: _MiniGridPainter(),
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => const GameScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      },
      child: Container(
        width: 200,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE94560), Color(0xFFB71C1C)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE94560).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'PLAY NOW',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final third = size.width / 3;

    // Vertical lines
    canvas.drawLine(Offset(third, 8), Offset(third, size.height - 8), paint);
    canvas.drawLine(Offset(third * 2, 8), Offset(third * 2, size.height - 8), paint);

    // Horizontal lines
    canvas.drawLine(Offset(8, third), Offset(size.width - 8, third), paint);
    canvas.drawLine(Offset(8, third * 2), Offset(size.width - 8, third * 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
