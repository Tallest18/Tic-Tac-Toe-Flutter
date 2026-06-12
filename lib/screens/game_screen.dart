import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../widgets/game_board.dart';
import '../widgets/score_card.dart';
import '../widgets/status_banner.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  GameModel _game = GameModel();
  late AnimationController _boardAnimController;
  late Animation<double> _boardScaleAnim;

  @override
  void initState() {
    super.initState();
    _boardAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _boardScaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _boardAnimController, curve: Curves.elasticOut),
    );
    _boardAnimController.forward();
  }

  @override
  void dispose() {
    _boardAnimController.dispose();
    super.dispose();
  }

  void _onCellTapped(int index) {
    if (_game.isGameOver) return;
    final newGame = _game.makeMove(index);
    if (newGame == null) return;

    setState(() {
      _game = newGame;
    });

    if (newGame.isGameOver) {
      _showResultDialog(newGame);
    }
  }

  void _resetBoard() {
    setState(() {
      _game = _game.resetBoard();
    });
    _boardAnimController.reset();
    _boardAnimController.forward();
  }

  void _resetAll() {
    setState(() {
      _game = _game.resetAll();
    });
    _boardAnimController.reset();
    _boardAnimController.forward();
  }

  void _showResultDialog(GameModel game) {
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _ResultDialog(
          game: game,
          onPlayAgain: () {
            Navigator.of(context).pop();
            _resetBoard();
          },
          onResetAll: () {
            Navigator.of(context).pop();
            _resetAll();
          },
        ),
      );
    });
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
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              _buildAppBar(),
              const SizedBox(height: 12),
              // Score Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ScoreCard(game: _game),
              ),
              const SizedBox(height: 20),
              // Status Banner
              StatusBanner(game: _game),
              const SizedBox(height: 24),
              // Game Board
              Expanded(
                child: Center(
                  child: ScaleTransition(
                    scale: _boardScaleAnim,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GameBoard(
                        game: _game,
                        onCellTapped: _onCellTapped,
                      ),
                    ),
                  ),
                ),
              ),
              // Bottom Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildButton(
                        label: 'New Round',
                        icon: Icons.refresh_rounded,
                        color: const Color(0xFF4FC3F7),
                        onTap: _resetBoard,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildButton(
                        label: 'Reset All',
                        icon: Icons.restart_alt_rounded,
                        color: const Color(0xFFE94560),
                        onTap: _resetAll,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
          ),
          const Expanded(
            child: Text(
              'Tic-Tac-Toe',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 48), // balance back button
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultDialog extends StatelessWidget {
  final GameModel game;
  final VoidCallback onPlayAgain;
  final VoidCallback onResetAll;

  const _ResultDialog({
    required this.game,
    required this.onPlayAgain,
    required this.onResetAll,
  });

  @override
  Widget build(BuildContext context) {
    final isWin = game.gameState == GameState.xWins || game.gameState == GameState.oWins;
    final emoji = isWin ? '🏆' : '🤝';
    final title = isWin
        ? 'Player ${game.gameState == GameState.xWins ? "X" : "O"} Wins!'
        : "It's a Draw!";
    final color = isWin
        ? (game.gameState == GameState.xWins ? const Color(0xFFE94560) : const Color(0xFF4FC3F7))
        : Colors.amber;

    return Dialog(
      backgroundColor: const Color(0xFF16213E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 52)),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Score: X ${game.xScore} — ${game.oScore} O',
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: onPlayAgain,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE94560),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Play Again',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: onResetAll,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white54,
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Reset Scores',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
