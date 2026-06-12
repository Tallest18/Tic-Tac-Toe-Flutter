import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/models/game_model.dart';

void main() {
  group('GameModel', () {
    test('initial board is empty', () {
      final game = GameModel();
      expect(game.board.every((cell) => cell == null), isTrue);
      expect(game.currentPlayer, Player.X);
      expect(game.gameState, GameState.playing);
    });

    test('player X goes first', () {
      final game = GameModel();
      final next = game.makeMove(0);
      expect(next?.board[0], Player.X);
      expect(next?.currentPlayer, Player.O);
    });

    test('detects row win', () {
      GameModel game = GameModel();
      game = game.makeMove(0)!; // X
      game = game.makeMove(3)!; // O
      game = game.makeMove(1)!; // X
      game = game.makeMove(4)!; // O
      game = game.makeMove(2)!; // X wins top row
      expect(game.gameState, GameState.xWins);
      expect(game.winningLine, [0, 1, 2]);
    });

    test('detects diagonal win', () {
      GameModel game = GameModel();
      game = game.makeMove(0)!; // X
      game = game.makeMove(1)!; // O
      game = game.makeMove(4)!; // X
      game = game.makeMove(2)!; // O
      game = game.makeMove(8)!; // X wins diagonal
      expect(game.gameState, GameState.xWins);
      expect(game.winningLine, [0, 4, 8]);
    });

    test('detects draw', () {
      // X O X
      // X X O
      // O X O
      GameModel game = GameModel();
      final moves = [0, 1, 2, 5, 3, 6, 7, 8, 4];
      for (final move in moves) {
        game = game.makeMove(move)!;
      }
      expect(game.gameState, GameState.draw);
    });

    test('ignores move on occupied cell', () {
      GameModel game = GameModel();
      game = game.makeMove(0)!;
      final same = game.makeMove(0);
      expect(same, isNull);
    });

    test('score increments on win', () {
      GameModel game = GameModel();
      game = game.makeMove(0)!; // X
      game = game.makeMove(3)!; // O
      game = game.makeMove(1)!; // X
      game = game.makeMove(4)!; // O
      game = game.makeMove(2)!; // X wins
      expect(game.xScore, 1);
      expect(game.oScore, 0);
    });

    test('resetBoard keeps scores', () {
      GameModel game = GameModel(xScore: 3, oScore: 1, drawScore: 2);
      final reset = game.resetBoard();
      expect(reset.xScore, 3);
      expect(reset.oScore, 1);
      expect(reset.drawScore, 2);
      expect(reset.board.every((c) => c == null), isTrue);
    });

    test('resetAll clears everything', () {
      GameModel game = GameModel(xScore: 3, oScore: 1, drawScore: 2);
      final reset = game.resetAll();
      expect(reset.xScore, 0);
      expect(reset.oScore, 0);
      expect(reset.drawScore, 0);
    });
  });
}
