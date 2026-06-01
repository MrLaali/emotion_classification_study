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

    final randomPool = allSentences.where((s) => !s.isControl).toList()
      ..shuffle(random);

    final neededRandom = trialCount - controls.length;

    final selectedRandom = randomPool.take(neededRandom).toList();

    final trials = [
      ...controls,
      ...selectedRandom,
    ]..shuffle(random);

    return trials;
  }
}