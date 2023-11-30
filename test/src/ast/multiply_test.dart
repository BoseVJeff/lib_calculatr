import 'package:lib_calculatr/src/ast/multiply.dart';
import 'package:lib_calculatr/src/ast/num.dart';
import 'package:lib_calculatr/src/utils/exceptions.dart';
import 'package:test/test.dart';

void main() {
  checkMultiply();
}

void checkMultiply() {
  group('Check Ast Multiply', () {
    test('Verify Solve', () {
      AstTermMultiply astTermSubtract = AstTermMultiply();
      expect(
        () => astTermSubtract.solve(),
        throwsA(isA<MissingArgumentException>()),
      );
      astTermSubtract.prevTerm = AstTermNum(5);
      expect(
        () => astTermSubtract.solve(),
        throwsA(isA<MissingArgumentException>()),
      );
      astTermSubtract.nextTerm = AstTermNum(10);
      expect(astTermSubtract.solve(), equals(50));
    });
  });
}
