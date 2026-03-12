import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/models.dart';
import '../providers/game_provider.dart';

class WordGrid extends ConsumerWidget {
  const WordGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameProvider);

    return Column(
      children: List.generate(6, (rowIndex) {
        bool isCurrentRow = rowIndex == state.guesses.length;
        bool isSubmitted = rowIndex < state.guesses.length;
        String guess = isSubmitted ? state.guesses[rowIndex] : (isCurrentRow ? state.currentGuess : "");
        guess = guess.padRight(5, ' ');

        List<LetterStatus> statuses = isSubmitted 
            ? ref.read(gameProvider.notifier).evaluateGuess(guess) 
            : List.filled(5, LetterStatus.idle);

        Widget rowWidget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (colIndex) {
            String letter = guess[colIndex];
            bool isRevealingThisRow = state.isRevealing && rowIndex == state.guesses.length - 1;

            return _buildCell(letter, statuses[colIndex], isSubmitted, isRevealingThisRow, colIndex);
          }),
        );

        // Shake Animasyonu
        if (isCurrentRow && state.shakeError) {
          rowWidget = rowWidget.animate().shakeX(hz: 4, amount: 5, duration: 400.ms);
        }

        return Padding(padding: const EdgeInsets.only(bottom: 8.0), child: rowWidget);
      }),
    );
  }

  Widget _buildCell(String letter, LetterStatus status, bool isSubmitted, bool isRevealing, int colIndex) {
    Color targetBgColor = Colors.transparent;
    Color targetBorderColor = absentColor;

    if (isSubmitted) {
      if (status == LetterStatus.correct) targetBgColor = correctColor;
      else if (status == LetterStatus.present) targetBgColor = presentColor;
      else targetBgColor = absentColor;
      targetBorderColor = targetBgColor;
    } else if (letter != ' ') {
      targetBorderColor = Colors.grey.shade500;
    }

    // Animasyon sırasında eski rengi tut, flip bitince yeni rengi göster
    Color displayBgColor = isRevealing ? Colors.transparent : targetBgColor;
    Color displayBorderColor = isRevealing ? Colors.grey.shade500 : targetBorderColor;

    Widget cell = Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: displayBgColor,
        border: Border.all(color: displayBorderColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );

    if (!isSubmitted && letter != ' ') {
      cell = cell.animate(key: ValueKey(letter)).scale(duration: 100.ms, begin: const Offset(0.8, 0.8));
    }

    if (isRevealing) {
      cell = cell.animate(delay: (colIndex * 300).ms)
          .flipV(duration: 300.ms, curve: Curves.easeIn)
          .swap(
            // Takla atmanın tam ortasında (150.ms) renklendirilmiş yeni kutuya geçiş yap!
            builder: (_, __) => Container(
              width: 60, height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(color: targetBgColor, border: Border.all(color: targetBorderColor, width: 2), borderRadius: BorderRadius.circular(8)),
              alignment: Alignment.center,
              child: Text(letter, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          );
    }

    return cell;
  }
}

class VirtualKeyboard extends ConsumerWidget {
  const VirtualKeyboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameProvider);
    final rows = state.language == Language.tr 
        ? [['E','R','T','Y','U','I','O','P','Ğ','Ü'], ['A','S','D','F','G','H','J','K','L','Ş','İ'], ['ENTER','Z','X','C','V','B','N','M','Ö','Ç','BACKSPACE']]
        : [['Q','W','E','R','T','Y','U','I','O','P'], ['A','S','D','F','G','H','J','K','L'], ['ENTER','Z','X','C','V','B','N','M','BACKSPACE']];

    final keyboardColors = ref.read(gameProvider.notifier).getKeyboardColors();

    return Column(
      children: rows.map((row) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((key) => _buildKey(key, ref, state, keyboardColors)).toList(),
        ),
      )).toList(),
    );
  }

  Widget _buildKey(String key, WidgetRef ref, GameState state, Map<String, LetterStatus> keyboardColors) {
    bool isSpecial = key == 'ENTER' || key == 'BACKSPACE';
    
    Color bgColor = darkSurface;
    
    // Sadece animasyon bitince klavye renklerini güncelle
    if (!state.isRevealing && !isSpecial) {
      if (keyboardColors[key] == LetterStatus.correct) bgColor = correctColor;
      else if (keyboardColors[key] == LetterStatus.present) bgColor = presentColor;
      else if (keyboardColors[key] == LetterStatus.absent) bgColor = absentColor;
    }

    return GestureDetector(
      onTap: () => ref.read(gameProvider.notifier).onKeyPress(key),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: EdgeInsets.symmetric(horizontal: isSpecial ? 12 : 0),
        width: isSpecial ? null : (MediaQuery.of(context).size.width / 11) - 4, // Ekrana daha iyi sığması için
        height: 50,
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
        alignment: Alignment.center,
        child: Text(
          key == 'BACKSPACE' ? '⌫' : key,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }
}
