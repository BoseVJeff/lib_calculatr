import 'package:lib_calculatr/src/ast/num.dart';
import 'package:lib_calculatr/src/ast/subtract.dart';
import 'package:lib_calculatr/src/utils/exceptions.dart';
import 'package:test/test.dart';

void main() {
  checkSubtract();
}

void checkSubtract() {
  group('Check Ast Subtract', () {
    test('Verify Solve', () {
      AstTermSubtract astTermSubtract = AstTermSubtract();
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
      expect(astTermSubtract.solve(), equals(-5));
    });
    test('Verify Implict 0', () {
      AstTermSubtract astTermSubtract = AstTermSubtract();
      expect(
        () => astTermSubtract.solve(),
        throwsA(isA<MissingArgumentException>()),
      );
      astTermSubtract.nextTerm = AstTermNum(10);
      expect(astTermSubtract.solve(), equals(-10));
    });
  });
}
