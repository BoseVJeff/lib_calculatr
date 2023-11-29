/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

import "src/lib_calculatr_base.dart"
    show AstTermExpression, Direction, OperatorPreccedence;

// TODO: Export any libraries intended for clients of this package.
export 'src/lib_calculatr_base.dart' show OperatorPreccedence, Direction;

num solve(String expression,
        {OperatorPreccedence operatorPreccedence = OperatorPreccedence.bodmas,
        Direction direction = Direction.ltr}) =>
    AstTermExpression.fromString(
      expression,
      null,
      operatorPreccedence.copyWith(direction: direction),
    ).solve();
