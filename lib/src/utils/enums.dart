enum Direction {
  ltr,
  rtl,
}

enum ParenType {
  round(startStr: '(', endStr: ')'),
  square(startStr: '[', endStr: ']'),
  curly(startStr: '{', endStr: '}');

  const ParenType({
    required this.startStr,
    required this.endStr,
  });

  final String startStr;
  final String endStr;

  int get startRune => startStr.runes.first;
  int get endRune => endStr.runes.first;
}
