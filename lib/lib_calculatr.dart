/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

import "src/ast/expression.dart";
import "src/utils/enums.dart";
import "src/utils/operator_preccedence.dart";

// TODO: Export any libraries intended for clients of this package.
export 'src/utils/operator_preccedence.dart' show OperatorPreccedence;
export 'src/utils/enums.dart' show Direction;

num solve(String expression,
        {OperatorPreccedence operatorPreccedence = OperatorPreccedence.bodmas,
        Direction direction = Direction.ltr}) =>
    AstTermExpression.fromString(
      expression,
      null,
      operatorPreccedence.copyWith(direction: direction),
    ).solve();
