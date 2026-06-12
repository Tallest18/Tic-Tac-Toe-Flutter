# Tic-Tac-Toe — Flutter

A classic two-player Tic-Tac-Toe game built with Flutter.

## Features
- Classic 3×3 Tic-Tac-Toe gameplay
- 2-player local multiplayer (X vs O)
- Win detection with visual highlight of the winning line
- Score tracking across rounds (X wins, O wins, Draws)
- Smooth animations — pieces pop in when placed
- Result dialog after each game (Play Again / Reset Scores)
- Beautiful dark gradient UI with animated turn indicator
- New Round & Reset All buttons

## Project Structure
```
lib/
├── main.dart               # Entry point
├── app.dart                # MaterialApp setup
├── models/
│   └── game_model.dart     # Pure game logic (board, moves, win detection)
├── screens/
│   ├── home_screen.dart    # Title/launch screen
│   └── game_screen.dart    # Main game UI + state
└── widgets/
    ├── game_board.dart     # 3×3 board grid
    ├── cell_widget.dart    # Individual cell with X/O animation
    ├── score_card.dart     # X / Draw / O score display
    └── status_banner.dart  # Turn indicator & result message
```

## Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0.0 — [Install Flutter](https://docs.flutter.dev/get-started/install)
- Android Studio or VS Code with Flutter/Dart extensions

### Run the app

```bash
# Get dependencies
flutter pub get

# Run on a connected device or emulator
flutter run

# Build release APK
flutter build apk --release
```

### Android Setup
Update `android/local.properties` with your SDK paths:
```
flutter.sdk=/path/to/flutter
sdk.dir=/path/to/android/sdk
```

## How to Play
1. Player X always goes first.
2. Tap any empty cell to place your mark.
3. First to get 3 in a row (horizontal, vertical, or diagonal) wins.
4. If all 9 cells fill with no winner — it's a draw.
5. Tap **New Round** to play again keeping scores, or **Reset All** to start fresh.
