import 'package:lib_calculatr/src/lib_calculatr_base.dart';
import 'package:test/test.dart';

void main() {
  checkParenthesis();
  checkNum();
  checkAdd();
  checkSubtract();
  checkMultiply();
  checkDivide();
  checkExpression();
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
  });
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

void checkExpression() {
  group('Check Ast Expression', () {
    test('Verify 5+10', () {
      // Setting up the expression
      AstTermExpression astTermExpression = AstTermExpression.fromList([
        AstTermNum(5),
        AstTermAdd(),
        AstTermNum(10),
      ]);
      // print(astTermExpression);
      expect(astTermExpression.solve(), equals(15));
    });
    test('Verify 5-10', () {
      // Setting up the expression
      AstTermExpression astTermExpression = AstTermExpression.fromList([
        AstTermNum(5),
        AstTermSubtract(),
        AstTermNum(10),
      ]);
      // print(astTermExpression);
      expect(astTermExpression.solve(), equals(-5));
    });
    test('Verify 5*10', () {
      // Setting up the expression
      AstTermExpression astTermExpression = AstTermExpression.fromList([
        AstTermNum(5),
        AstTermMultiply(),
        AstTermNum(10),
      ]);
      // print(astTermExpression);
      expect(astTermExpression.solve(), equals(50));
    });
    test('Verify 5/10', () {
      // Setting up the expression
      AstTermExpression astTermExpression = AstTermExpression.fromList([
        AstTermNum(5),
        AstTermDivide(),
        AstTermNum(10),
      ]);
      // print(astTermExpression);
      expect(astTermExpression.solve(), equals(0.5));
    });
    test('Verify 5+10/10', () {
      // Setting up the expression
      AstTermExpression astTermExpression = AstTermExpression.fromList([
        AstTermNum(5),
        AstTermAdd(),
        AstTermNum(10),
        AstTermDivide(),
        AstTermNum(10),
      ]);
      // print(astTermExpression);
      expect(astTermExpression.solve(), equals(6));
    });
    test('Verify 8+2-9/3*6', () {
      // Setting up the expression
      AstTermExpression astTermExpression = AstTermExpression.fromList([
        AstTermNum(8),
        AstTermAdd(),
        AstTermNum(2),
        AstTermSubtract(),
        AstTermNum(9),
        AstTermDivide(),
        AstTermNum(3),
        AstTermMultiply(),
        AstTermNum(6),
      ]);
      // print(astTermExpression);
      expect(astTermExpression.solve(), equals(((8 + 2) - ((9 / 3) * 6))));
    });
    test('Verify LTR 1/2/4', () {
      AstTermExpression astTermExpression = AstTermExpression.fromList(
        [
          AstTermNum(1),
          AstTermDivide(),
          AstTermNum(2),
          AstTermDivide(),
          AstTermNum(4),
        ],
        operatorPreccedence:
            OperatorPreccedence.bodmas.copyWith(direction: Direction.ltr),
      );
      expect(astTermExpression.solve(), equals(((1 / 2) / 4)));
    });
    test('Verify RTL 1/2/4', () {
      AstTermExpression astTermExpression = AstTermExpression.fromList(
        [
          AstTermNum(1),
          AstTermDivide(),
          AstTermNum(2),
          AstTermDivide(),
          AstTermNum(4),
        ],
        operatorPreccedence:
            OperatorPreccedence.bodmas.copyWith(direction: Direction.rtl),
      );
      expect(astTermExpression.solve(), equals((1 / (2 / 4))));
    });
    test('String Interpretation', () {
      expect(AstTermExpression.fromString('8+2-(9/3)*6').solve(), equals(-8));
      expect(AstTermExpression.fromString('8+(2-{9/3}*6)').solve(), equals(-8));
      expect(AstTermExpression.fromString('8+(2-(9/3)*6)').solve(), equals(-8));
      expect(AstTermExpression.fromString('8+(2-(9/3))*6').solve(), equals(2));
      expect(
        AstTermExpression.fromString('5/10'),
        equals(AstTermExpression.fromList([
          AstTermNum(5),
          AstTermDivide(),
          AstTermNum(10),
        ])),
      );
    });
  });
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
