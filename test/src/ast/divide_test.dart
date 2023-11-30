import 'package:lib_calculatr/src/ast/divide.dart';
import 'package:lib_calculatr/src/ast/num.dart';
import 'package:lib_calculatr/src/utils/exceptions.dart';
import 'package:test/test.dart';

void main() {
  checkDivide();
}

void checkDivide() {
  group('Check Ast Divide', () {
    test('Verify Solve', () {
      AstTermDivide astTermSubtract = AstTermDivide();
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
      expect(astTermSubtract.solve(), equals(0.5));
    });
  });
}
