import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models.dart';
import '../providers/game_provider.dart';
import 'widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        title: const Text('WORDSE', style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold)),
        backgroundColor: darkBg,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: correctColor, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen())),
              child: const Text('Tek Oyunculu', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white24), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16)),
              onPressed: () {}, // TODO: Online Lobi
              child: const Text('Arkadaşlarla Oyna (Online)', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Oyun bittiğinde tetiklenecek dinleyici (Listener)
    ref.listen<GameState>(gameProvider, (previous, next) {
      if (previous?.status == GameStatus.playing && next.status != GameStatus.playing) {
        _showEndGameDialog(context, ref, next);
      }
    });

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        title: const Text('WORDLE', style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold)),
        backgroundColor: darkBg,
        elevation: 0,
      ),
      // Web/Desktop Fiziksel klavye dinleyicisi
      body: Focus(
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            final char = event.logicalKey.keyLabel.toUpperCase();
            if (char.length == 1 && RegExp(r'[A-ZĞÜŞİÖÇ]').hasMatch(char)) {
              ref.read(gameProvider.notifier).onKeyPress(char);
            } else if (event.logicalKey == LogicalKeyboardKey.enter) {
              ref.read(gameProvider.notifier).onKeyPress('ENTER');
            } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
              ref.read(gameProvider.notifier).onKeyPress('BACKSPACE');
            }
          }
          return KeyEventResult.handled;
        },
        child: const Column(
          children: [
            SizedBox(height: 20),
            Expanded(child: Center(child: WordGrid())),
            VirtualKeyboard(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showEndGameDialog(BuildContext context, WidgetRef ref, GameState state) {
    final isWon = state.status == GameStatus.won;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: darkSurface,
        title: Text(isWon ? 'Tebrikler! 🎉' : 'Bilemedin! 😢', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text('Kelime: ${state.solution}', style: const TextStyle(color: Colors.white70, fontSize: 18)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Ana menüye dön
            },
            child: const Text('Ana Menü', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: correctColor),
            onPressed: () {
              Navigator.pop(context);
              ref.read(gameProvider.notifier).startNewGame(); // Sınırsız Oyna!
            },
            child: const Text('Yeni Kelime', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}
