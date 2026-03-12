import 'package:flutter/material.dart';

enum Language { tr, en }
enum LetterStatus { correct, present, absent, idle }
enum GameMode { single, multi }
enum GameStatus { playing, won, lost }

class Player {
  final String id;
  final String name;
  final bool isHost;
  final List<List<LetterStatus>> guesses;

  Player({required this.id, required this.name, required this.isHost, required this.guesses});
}

class Room {
  final String id;
  final String code;
  final String status; 
  final Map<String, Player> players;
  final String solution;
  final Language language;

  Room({required this.id, required this.code, required this.status, required this.players, required this.solution, required this.language});
}

// Kelimeler artık JSON'dan yüklenecek
List<String> trWords = [];
List<String> enWords = [];

// 🎨 PREMIUM KOYU TEMA RENKLERİ
const Color darkBg = Color(0xFF0F172A); // Koyu Slate (Gece Laciverti)
const Color darkSurface = Color(0xFF1E293B); // Daha açık Slate (Klavye tuşları)
const Color correctColor = Color(0xFF10B981); // Zümrüt Yeşili (Premium Doğru)
const Color presentColor = Color(0xFFF59E0B); // Kehribar Sarısı (Premium Yanlış Yer)
const Color absentColor = Color(0xFF334155); // Mat Koyu Gri (Olmayan harf)
