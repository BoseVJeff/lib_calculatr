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
