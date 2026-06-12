import 'package:flutter/material.dart';
import '../models/game_model.dart';
import 'cell_widget.dart';

class GameBoard extends StatelessWidget {
  final GameModel game;
  final void Function(int index) onCellTapped;

  const GameBoard({
    super.key,
    required this.game,
    required this.onCellTapped,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CustomPaint(
            painter: _BoardLinePainter(),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return CellWidget(
                  player: game.board[index],
                  isWinningCell: game.isCellInWinningLine(index),
                  isGameOver: game.isGameOver,
                  onTap: () => onCellTapped(index),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _BoardLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bgPaint = Paint()..color = const Color(0xFF0D1B2A);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final linePaint = Paint()
      ..color = const Color(0xFF2A3F5F)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final third = size.width / 3;
    final padding = 16.0;

    // Vertical lines
    canvas.drawLine(
      Offset(third, padding),
      Offset(third, size.height - padding),
      linePaint,
    );
    canvas.drawLine(
      Offset(third * 2, padding),
      Offset(third * 2, size.height - padding),
      linePaint,
    );

    // Horizontal lines
    canvas.drawLine(
      Offset(padding, third),
      Offset(size.width - padding, third),
      linePaint,
    );
    canvas.drawLine(
      Offset(padding, third * 2),
      Offset(size.width - padding, third * 2),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
