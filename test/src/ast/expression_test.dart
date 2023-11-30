import 'package:lib_calculatr/src/ast/add.dart';
import 'package:lib_calculatr/src/ast/divide.dart';
import 'package:lib_calculatr/src/ast/expression.dart';
import 'package:lib_calculatr/src/ast/multiply.dart';
import 'package:lib_calculatr/src/ast/num.dart';
import 'package:lib_calculatr/src/ast/subtract.dart';
import 'package:lib_calculatr/src/utils/enums.dart';
import 'package:lib_calculatr/src/utils/operator_preccedence.dart';
import 'package:test/test.dart';

void main() {
  checkExpression();
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
    test('Verify -5*10', () {
      // Setting up the expression
      AstTermExpression astTermExpression = AstTermExpression.fromList([
        AstTermSubtract(),
        AstTermNum(5),
        AstTermMultiply(),
        AstTermNum(10),
      ]);
      // print(astTermExpression);
      expect(astTermExpression.solve(), equals(-50));
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
