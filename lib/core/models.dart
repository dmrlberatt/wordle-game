import 'package:flutter/material.dart';

enum Language { tr, en }
enum LetterStatus { correct, present, absent, idle }
enum GameMode { single, multi }

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
  final String status; // 'waiting', 'playing'
  final Map<String, Player> players;
  final String solution;
  final Language language;

  Room({required this.id, required this.code, required this.status, required this.players, required this.solution, required this.language});
}

const List<String> trWords = ["KALEM", "KİTAP", "SEVGİ", "DÜNYA", "GÜNEŞ"];
const List<String> enWords = ["APPLE", "BRAIN", "CHAIR", "DANCE", "EAGLE"];

const Color darkBg = Color(0xFF0F172A); // Slate 900
const Color darkSurface = Color(0xFF1E293B); // Slate 800
const Color correctColor = Color(0xFF10B981); // Emerald 500
const Color presentColor = Color(0xFFF59E0B); // Amber 500
const Color absentColor = Color(0xFF334155); // Slate 700
