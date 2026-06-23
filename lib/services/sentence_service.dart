import 'dart:math';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import '../models/study_sentence.dart';

class SentenceService {
Future<List<StudySentence>> loadSentences() async {
  final rawCsv = await rootBundle.loadString(
    'assets/sentences.csv',
  );

  final rows = Csv().decoder.convert(rawCsv);

  return rows.skip(1).map((row) {
    return StudySentence.fromCsvRow(row);
  }).toList();
}

List<StudySentence> buildTrialList({
  required List<StudySentence> allSentences,
  required int trialCount,
}) {
  final random = Random();

  final controls = allSentences.where((s) => s.isControl).toList();

  final randomNeededTotal = trialCount - controls.length;
  final randomNeededPerEmotion = randomNeededTotal ~/ 4;

  final emotions = ['anger', 'fear', 'happiness', 'sadness'];

  final balancedRandom = <StudySentence>[];

  for (final emotion in emotions) {
    final pool = allSentences
        .where(
          (s) =>
              !s.isControl &&
              s.emotion.toLowerCase().trim() == emotion,
        )
        .toList()
      ..shuffle(random);

    balancedRandom.addAll(pool.take(randomNeededPerEmotion));
  }

  final trials = [
    ...controls,
    ...balancedRandom,
  ]..shuffle(random);

  return trials;
}
}