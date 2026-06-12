import 'package:flutter/material.dart';
import '../models/game_model.dart';

class CellWidget extends StatefulWidget {
  final Player? player;
  final bool isWinningCell;
  final bool isGameOver;
  final VoidCallback onTap;

  const CellWidget({
    super.key,
    required this.player,
    required this.isWinningCell,
    required this.isGameOver,
    required this.onTap,
  });

  @override
  State<CellWidget> createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    if (widget.player != null) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant CellWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.player == null && widget.player != null) {
      _controller.forward(from: 0.0);
    } else if (widget.player == null) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = widget.player == null;
    final isX = widget.player == Player.X;

    return GestureDetector(
      onTap: isEmpty && !widget.isGameOver ? widget.onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: widget.isWinningCell
              ? (isX
                  ? const Color(0xFFE94560).withOpacity(0.2)
                  : const Color(0xFF4FC3F7).withOpacity(0.2))
              : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isWinningCell
                ? (isX ? const Color(0xFFE94560) : const Color(0xFF4FC3F7))
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: isEmpty
            ? _buildHoverIndicator()
            : FadeTransition(
                opacity: _fadeAnim,
                child: ScaleTransition(
                  scale: _scaleAnim,
                  child: Center(
                    child: isX ? _buildX() : _buildO(),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildHoverIndicator() {
    if (widget.isGameOver) return const SizedBox.shrink();
    return Container(); // empty clickable area
  }

  Widget _buildX() {
    return CustomPaint(
      size: const Size(56, 56),
      painter: _XPainter(
        color: widget.isWinningCell
            ? const Color(0xFFFF6B8A)
            : const Color(0xFFE94560),
        strokeWidth: widget.isWinningCell ? 6 : 5,
      ),
    );
  }

  Widget _buildO() {
    return CustomPaint(
      size: const Size(56, 56),
      painter: _OPainter(
        color: widget.isWinningCell
            ? const Color(0xFF80D8FF)
            : const Color(0xFF4FC3F7),
        strokeWidth: widget.isWinningCell ? 6 : 5,
      ),
    );
  }
}

class _XPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _XPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final padding = strokeWidth;
    canvas.drawLine(
      Offset(padding, padding),
      Offset(size.width - padding, size.height - padding),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - padding, padding),
      Offset(padding, size.height - padding),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _XPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

class _OPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _OPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final padding = strokeWidth / 2 + 2;
    canvas.drawOval(
      Rect.fromLTRB(padding, padding, size.width - padding, size.height - padding),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _OPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}
