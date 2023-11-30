import 'base.dart';
import 'num.dart';

abstract class AstTermBinaryOperator extends AstTerm {
  @override
  AstTermNum resolve() {
    AstTermNum newTerm = AstTermNum(solve());
    // Remove the precc/succ operands and replace self with result i.e. replace 5 + 4 with 9
    prevTerm?.removeSelf();
    nextTerm?.removeSelf();
    replaceSelf(newTerm);
    return newTerm;
  }

  int get operatorHash => toString().codeUnits.first;

  @override
  int get hashCode =>
      (prevTerm != null ? prevTerm.hashCode : 0) * 1 +
      operatorHash * 15 +
      (nextTerm != null ? nextTerm.hashCode : 0) * 255;

  @override
  bool operator ==(Object other) {
    return (other is AstTermBinaryOperator) &&
        (other.operatorHash == operatorHash) &&
        (other.prevTerm == prevTerm) &&
        (other.nextTerm == nextTerm);
  }
}
