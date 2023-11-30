import 'package:lib_calculatr/src/ast/num.dart';
import 'package:test/test.dart';

void main() {
  checkNum();
}

void checkNum() {
  group('Check Ast Num', () {
    test('Verify Solve', () {
      expect(AstTermNum(5).solve(), equals(5));
    });
    test('Verify Resolve', () {
      AstTermNum astTermNum = AstTermNum(10);
      expect(astTermNum.resolve(), isA<AstTermNum>());
      expect(astTermNum.resolve(), equals(astTermNum));
    });
    test('Verify Equality', () {
      expect(AstTermNum(5), equals(AstTermNum(5)));
      expect(AstTermNum(5), isNot(equals(AstTermNum(10))));
      expect(
        AstTermNum(5),
        isNot(equals(
          AstTermNum(
            5,
            prevTerm: AstTermNum(10),
          ),
        )),
      );
      expect(
        AstTermNum(5),
        isNot(equals(
          AstTermNum(
            5,
            prevTerm: AstTermNum(10),
            nextTerm: AstTermNum(15),
          ),
        )),
      );
    });
  });
}
