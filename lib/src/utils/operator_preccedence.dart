import 'package:lib_calculatr/src/ast/base.dart';
import 'package:lib_calculatr/src/utils/exceptions.dart';

import '../ast/add.dart';
import '../ast/divide.dart';
import '../ast/expression.dart';
import '../ast/multiply.dart';
import '../ast/multiply_implicit.dart';
import '../ast/subtract.dart';
import 'enums.dart';

class OperatorPreccedence {
  const OperatorPreccedence(
    this.order, {
    this.direction = Direction.ltr,
  });

  final List<Type> order;

  final Direction direction;

  static const OperatorPreccedence bodmas = OperatorPreccedence(
    [
      AstTermExpression,
      AstTermImplicitMultiply,
      AstTermDivide,
      AstTermMultiply,
      AstTermAdd,
      AstTermSubtract,
    ],
    direction: Direction.ltr,
  );

  static const OperatorPreccedence bodmasReverse = OperatorPreccedence(
    [
      AstTermSubtract,
      AstTermAdd,
      AstTermMultiply,
      AstTermDivide,
      AstTermImplicitMultiply,
      AstTermExpression,
    ],
    direction: Direction.ltr,
  );

  factory OperatorPreccedence.custom() => OperatorPreccedence([]);

  void addOperator(Type operatorType) {
    if (operatorType is! AstTerm) {
      throw MistypedArgumentException(
        message: 'Type must extend `AstTerm`',
        actualType: operatorType,
      );
    }

    assert(operatorType is AstTerm);
    order.add(operatorType);
  }

  OperatorPreccedence copyWith({
    List<Type>? order,
    Direction? direction,
  }) {
    return OperatorPreccedence(
      order ?? this.order,
      direction: direction ?? this.direction,
    );
  }
}
