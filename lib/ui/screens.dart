import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models.dart';
import 'widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        title: const Text('WORDLE', style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold)),
        backgroundColor: darkBg,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.language), onPressed: () {}), // Dil değiştir
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen())),
              child: const Text('Tek Oyunculu', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white24), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16)),
              onPressed: () {}, // Lobi ekranına yönlendir
              child: const Text('Arkadaşlarla Oyna (Online)', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        title: const Text('WORDLE', style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold)),
        backgroundColor: darkBg,
        elevation: 0,
      ),
      body: const Column(
        children: [
          SizedBox(height: 20),
          // MultiplayerBar(), // Online moddaysa gösterilecek
          Expanded(child: Center(child: WordGrid())),
          VirtualKeyboard(),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
