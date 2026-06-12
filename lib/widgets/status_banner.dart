import 'package:flutter/material.dart';
import '../models/game_model.dart';

class StatusBanner extends StatelessWidget {
  final GameModel game;

  const StatusBanner({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final isX = game.currentPlayer == Player.X;
    final color = game.isGameOver
        ? _resultColor(game.gameState)
        : (isX ? const Color(0xFFE94560) : const Color(0xFF4FC3F7));

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(game.statusMessage),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!game.isGameOver) ...[
              _TurnIndicator(
                player: game.currentPlayer,
                color: color,
              ),
              const SizedBox(width: 10),
            ],
            Text(
              game.statusMessage,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _resultColor(GameState state) {
    switch (state) {
      case GameState.xWins:
        return const Color(0xFFE94560);
      case GameState.oWins:
        return const Color(0xFF4FC3F7);
      case GameState.draw:
        return Colors.amber;
      case GameState.playing:
        return Colors.white;
    }
  }
}

class _TurnIndicator extends StatefulWidget {
  final Player player;
  final Color color;

  const _TurnIndicator({required this.player, required this.color});

  @override
  State<_TurnIndicator> createState() => _TurnIndicatorState();
}

class _TurnIndicatorState extends State<_TurnIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.4, end: 1.0).animate(_controller),
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
