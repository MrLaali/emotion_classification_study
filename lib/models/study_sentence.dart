class StudySentence {
  final int id;
  final String emotion;
  final String sentence;
  final int emotionIndex;
  final bool isControl;

  const StudySentence({
    required this.id,
    required this.emotion,
    required this.sentence,
    required this.emotionIndex,
    required this.isControl,
  });

  factory StudySentence.fromCsvRow(List<dynamic> row) {
    return StudySentence(
      id: int.parse(row[0].toString()),
      emotion: row[1].toString(),
      sentence: row[2].toString(),
      emotionIndex: int.parse(row[3].toString()),
      isControl: row[4].toString().toLowerCase() == 'true',
    );
  }
}