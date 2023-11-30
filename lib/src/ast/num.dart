import 'base.dart';

class AstTermNum extends AstTerm {
  AstTermNum(
    this.value, {
    super.prevTerm,
    super.nextTerm,
  });

  final num value;

  @override
  num solve() {
    return value;
  }

  @override
  AstTermNum resolve() {
    return this;
  }

  @override
  String toString() {
    return value.toString();
  }

  @override
  int get hashCode =>
      (prevTerm != null ? prevTerm.hashCode : 0) * 1 +
      value.floor() * 15 +
      (nextTerm != null ? nextTerm.hashCode : 0) * 255;

  @override
  bool operator ==(Object other) {
    return (other is AstTermNum) &&
        (other.value == value) &&
        (other.prevTerm == prevTerm) &&
        (other.nextTerm == nextTerm);
  }
}
