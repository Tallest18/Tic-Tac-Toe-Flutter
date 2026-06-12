import 'package:flutter/material.dart';
import '../models/game_model.dart';

class ScoreCard extends StatelessWidget {
  final GameModel game;

  const ScoreCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final isXTurn = game.currentPlayer == Player.X && !game.isGameOver;
    final isOTurn = game.currentPlayer == Player.O && !game.isGameOver;

    return Row(
      children: [
        Expanded(
          child: _ScoreBox(
            label: 'Player X',
            score: game.xScore,
            color: const Color(0xFFE94560),
            isActive: isXTurn,
            symbol: 'X',
          ),
        ),
        const SizedBox(width: 10),
        _DrawBox(score: game.drawScore),
        const SizedBox(width: 10),
        Expanded(
          child: _ScoreBox(
            label: 'Player O',
            score: game.oScore,
            color: const Color(0xFF4FC3F7),
            isActive: isOTurn,
            symbol: 'O',
          ),
        ),
      ],
    );
  }
}

class _ScoreBox extends StatelessWidget {
  final String label;
  final int score;
  final Color color;
  final bool isActive;
  final String symbol;

  const _ScoreBox({
    required this.label,
    required this.score,
    required this.color,
    required this.isActive,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.15) : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? color : Colors.white12,
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                symbol,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (isActive) ...[
                const SizedBox(width: 4),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$score',
            style: TextStyle(
              color: isActive ? color : Colors.white70,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: isActive ? color.withOpacity(0.8) : Colors.white38,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawBox extends StatelessWidget {
  final int score;

  const _DrawBox({required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12, width: 1),
      ),
      child: Column(
        children: [
          const Text(
            '—',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$score',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Text(
            'Draws',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
