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

enum Operator {
  add,
  sub,
  mul,
  implMul,
  div;

  static List<String> _validOperators = [
    '+',
    '-',
    '*',
    '',
    '/',
  ];

  factory Operator.fromString(String str) {
    switch (str) {
      case '+':
        return Operator.add;
      case '-':
        return Operator.sub;
      case '*':
        return Operator.mul;
      case '/':
        return Operator.div;
      case '':
        return Operator.implMul;
      default:
        throw UnimplementedError('Operator $str has not been implemented yet.');
    }
  }

  static bool isValid(String str) => Operator._validOperators.contains(str);
}
