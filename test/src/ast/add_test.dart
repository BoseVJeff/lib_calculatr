import 'package:lib_calculatr/src/ast/add.dart';
import 'package:lib_calculatr/src/ast/num.dart';
import 'package:lib_calculatr/src/utils/exceptions.dart';
import 'package:test/test.dart';

void main() {
  checkAdd();
}

void checkAdd() {
  group('Check Ast Add', () {
    test('Verify Solve', () {
      AstTermAdd astTermAdd = AstTermAdd();
      expect(
        () => astTermAdd.solve(),
        throwsA(isA<MissingArgumentException>()),
      );
      astTermAdd.prevTerm = AstTermNum(5);
      expect(
        () => astTermAdd.solve(),
        throwsA(isA<MissingArgumentException>()),
      );
      astTermAdd.nextTerm = AstTermNum(10);
      expect(astTermAdd.solve(), equals(15));
    });
  });
}
