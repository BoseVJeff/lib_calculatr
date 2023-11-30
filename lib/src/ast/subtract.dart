import '../utils/exceptions.dart';
import 'binary_ops.dart';
import 'expression.dart';
import 'num.dart';

class AstTermSubtract extends AstTermBinaryOperator {
  @override
  num solve() {
    if (nextTerm == null) {
      throw MissingArgumentException();
    }

    if (prevTerm == null) {
      // Using null check here as this assertion is satisfied by the preceeding conditional blocks.
      return nextTerm!.solve() * (-1);
    }

    if (prevTerm is! AstTermNum && prevTerm is! AstTermExpression) {
      throw MistypedArgumentException(
        expectedType: AstTermNum,
        actualType: prevTerm.runtimeType,
      );
    }
    if (nextTerm is! AstTermNum && nextTerm is! AstTermExpression) {
      throw MistypedArgumentException(
        expectedType: AstTermNum,
        actualType: nextTerm.runtimeType,
      );
    }

    // Using null check here as this assertion is satisfied by the preceeding conditional blocks.
    assert(prevTerm != null && nextTerm != null);
    return prevTerm!.solve() - nextTerm!.solve();
  }

  @override
  String toString() {
    return '-';
  }
}
