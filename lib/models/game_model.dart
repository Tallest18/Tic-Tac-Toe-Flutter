enum Player { X, O }

enum GameState { playing, xWins, oWins, draw }

class GameModel {
  List<Player?> board;
  Player currentPlayer;
  GameState gameState;
  List<int>? winningLine;
  int xScore;
  int oScore;
  int drawScore;

  GameModel({
    List<Player?>? board,
    this.currentPlayer = Player.X,
    this.gameState = GameState.playing,
    this.winningLine,
    this.xScore = 0,
    this.oScore = 0,
    this.drawScore = 0,
  }) : board = board ?? List.filled(9, null);

  // All possible winning combinations
  static const List<List<int>> _winningCombinations = [
    [0, 1, 2], // top row
    [3, 4, 5], // middle row
    [6, 7, 8], // bottom row
    [0, 3, 6], // left column
    [1, 4, 7], // middle column
    [2, 5, 8], // right column
    [0, 4, 8], // diagonal top-left to bottom-right
    [2, 4, 6], // diagonal top-right to bottom-left
  ];

  bool get isGameOver => gameState != GameState.playing;

  String get statusMessage {
    switch (gameState) {
      case GameState.xWins:
        return 'Player X Wins! 🎉';
      case GameState.oWins:
        return 'Player O Wins! 🎉';
      case GameState.draw:
        return "It's a Draw! 🤝";
      case GameState.playing:
        return 'Player ${currentPlayer == Player.X ? "X" : "O"}\'s Turn';
    }
  }

  /// Returns a new GameModel after making a move at [index].
  /// Returns null if the move is invalid.
  GameModel? makeMove(int index) {
    if (board[index] != null || isGameOver) return null;

    final newBoard = List<Player?>.from(board);
    newBoard[index] = currentPlayer;

    List<int>? winLine = _checkWin(newBoard, currentPlayer);
    GameState newState;
    int newXScore = xScore;
    int newOScore = oScore;
    int newDrawScore = drawScore;

    if (winLine != null) {
      newState = currentPlayer == Player.X ? GameState.xWins : GameState.oWins;
      if (currentPlayer == Player.X) {
        newXScore++;
      } else {
        newOScore++;
      }
    } else if (newBoard.every((cell) => cell != null)) {
      newState = GameState.draw;
      newDrawScore++;
    } else {
      newState = GameState.playing;
    }

    return GameModel(
      board: newBoard,
      currentPlayer: currentPlayer == Player.X ? Player.O : Player.X,
      gameState: newState,
      winningLine: winLine,
      xScore: newXScore,
      oScore: newOScore,
      drawScore: newDrawScore,
    );
  }

  /// Resets the board for a new round, keeping the scores.
  GameModel resetBoard() {
    return GameModel(
      board: List.filled(9, null),
      currentPlayer: Player.X,
      gameState: GameState.playing,
      winningLine: null,
      xScore: xScore,
      oScore: oScore,
      drawScore: drawScore,
    );
  }

  /// Resets everything including scores.
  GameModel resetAll() {
    return GameModel();
  }

  static List<int>? _checkWin(List<Player?> board, Player player) {
    for (final combo in _winningCombinations) {
      if (board[combo[0]] == player &&
          board[combo[1]] == player &&
          board[combo[2]] == player) {
        return combo;
      }
    }
    return null;
  }

  bool isCellInWinningLine(int index) {
    return winningLine?.contains(index) ?? false;
  }
}
