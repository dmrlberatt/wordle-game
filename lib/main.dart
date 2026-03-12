import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/models.dart';
import 'ui/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadDictionaries();
  runApp(const ProviderScope(child: GizliKelimeApp()));
}

Future<void> loadDictionaries() async {
  try {
    final trData = await rootBundle.loadString('assets/words_tr.json');
    final enData = await rootBundle.loadString('assets/words_en.json');
    trWords = List<String>.from(json.decode(trData));
    enWords = List<String>.from(json.decode(enData));
  } catch (e) {
    debugPrint("JSON Yükleme Hatası: $e");
    trWords = ["HATA1"]; // Çökmeyi önlemek için
    enWords = ["ERROR"];
  }
}

class GizliKelimeApp extends StatelessWidget {
  const GizliKelimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gizli Kelime',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBg,
      ),
      home: const HomeScreen(),
    );
  }
}
