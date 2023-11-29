/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

import "src/lib_calculatr_base.dart"
    show AstTermExpression, Direction, OperatorPreccedence;

num solve(String expression, [Direction direction = Direction.ltr]) =>
    AstTermExpression.fromString(
      expression,
      null,
      OperatorPreccedence.bodmas.copyWith(direction: direction),
    ).solve();

// TODO: Export any libraries intended for clients of this package.
