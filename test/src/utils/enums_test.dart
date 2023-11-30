import 'package:lib_calculatr/src/utils/enums.dart';
import 'package:test/test.dart';

void main() {
  checkParenthesis();
}

void checkParenthesis() {
  group('Parenthesis Correctness', () {
    group('Round Brackets', () {
      test('Start Character', () {
        expect(ParenType.round.startStr, equals('('));
      });
      test('End Character', () {
        expect(ParenType.round.endStr, equals(')'));
      });
    });
    group('Square Brackets', () {
      test('Start Character', () {
        expect(ParenType.square.startStr, equals('['));
      });
      test('End Character', () {
        expect(ParenType.square.endStr, equals(']'));
      });
    });
    group('Curly Brackets', () {
      test('Start Character', () {
        expect(ParenType.curly.startStr, equals('{'));
      });
      test('End Character', () {
        expect(ParenType.curly.endStr, equals('}'));
      });
    });
  });
}
