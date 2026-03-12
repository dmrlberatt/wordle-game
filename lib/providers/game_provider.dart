import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models.dart';

class GameState {
  final String solution;
  final List<String> guesses;
  final String currentGuess;
  final bool isRevealing;
  final bool shakeError;
  final Language language;

  GameState({
    this.solution = '',
    this.guesses = const [],
    this.currentGuess = '',
    this.isRevealing = false,
    this.shakeError = false,
    this.language = Language.tr,
  });

  GameState copyWith({String? solution, List<String>? guesses, String? currentGuess, bool? isRevealing, bool? shakeError, Language? language}) {
    return GameState(
      solution: solution ?? this.solution,
      guesses: guesses ?? this.guesses,
      currentGuess: currentGuess ?? this.currentGuess,
      isRevealing: isRevealing ?? this.isRevealing,
      shakeError: shakeError ?? this.shakeError,
      language: language ?? this.language,
    );
  }
}

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(GameState()) {
    startNewGame();
  }

  void startNewGame() {
    final words = state.language == Language.tr ? trWords : enWords;
    final solution = words[0]; // Rastgele seçilecek
    state = state.copyWith(solution: solution, guesses: [], currentGuess: '', isRevealing: false, shakeError: false);
  }

  void setLanguage(Language lang) {
    state = state.copyWith(language: lang);
    startNewGame();
  }

  void onKeyPress(String key) async {
    if (state.isRevealing || state.guesses.length >= 6) return;

    if (key == 'ENTER') {
      if (state.currentGuess.length != 5) {
        _triggerShake();
        return;
      }
      
      final words = state.language == Language.tr ? trWords : enWords;
      if (!words.contains(state.currentGuess)) {
        _triggerShake();
        return;
      }

      state = state.copyWith(
        guesses: [...state.guesses, state.currentGuess],
        currentGuess: '',
        isRevealing: true,
      );

      // 5 harf * 300ms = 1500ms animasyon süresi
      await Future.delayed(const Duration(milliseconds: 1500));
      state = state.copyWith(isRevealing: false);

    } else if (key == 'BACKSPACE') {
      if (state.currentGuess.isNotEmpty) {
        state = state.copyWith(currentGuess: state.currentGuess.substring(0, state.currentGuess.length - 1));
      }
    } else if (state.currentGuess.length < 5) {
      state = state.copyWith(currentGuess: state.currentGuess + key);
    }
  }

  void _triggerShake() async {
    state = state.copyWith(shakeError: true);
    await Future.delayed(const Duration(milliseconds: 400));
    state = state.copyWith(shakeError: false);
  }

  List<LetterStatus> evaluateGuess(String guess) {
    List<LetterStatus> result = List.filled(5, LetterStatus.absent);
    List<String> solutionChars = state.solution.split('');

    for (int i = 0; i < 5; i++) {
      if (guess[i] == solutionChars[i]) {
        result[i] = LetterStatus.correct;
        solutionChars[i] = '';
      }
    }
    for (int i = 0; i < 5; i++) {
      if (result[i] != LetterStatus.correct && solutionChars.contains(guess[i])) {
        result[i] = LetterStatus.present;
        solutionChars[solutionChars.indexOf(guess[i])] = '';
      }
    }
    return result;
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) => GameNotifier());
