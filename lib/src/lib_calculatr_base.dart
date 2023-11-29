import 'package:meta/meta.dart';

class MissingArgumentException implements Exception {
  MissingArgumentException([String message = 'Missing Argument']);
}

class MistypedArgumentException implements Exception {
  MistypedArgumentException({
    this.message = 'Mistyped Argument',
    this.actualType,
    this.expectedType,
  });

  final String message;

  final Type? actualType;

  final Type? expectedType;

  @override
  String toString() {
    List<String> messageParts = [];
    if (expectedType != null) {
      messageParts.add('expected $expectedType');
    }
    if (actualType != null) {
      messageParts.add('recieved $actualType');
    }
    return '$message: ${messageParts.join(", ")}';
  }
}

abstract class LinkedListTerm<T extends LinkedListTerm<T>> {
  @mustCallSuper
  LinkedListTerm({
    this.prevTerm,
    this.nextTerm,
  });

  T? prevTerm;

  T? nextTerm;

  LinkedListTerm replaceSelf(T linkedListTerm) {
    prevTerm?.nextTerm = linkedListTerm;
    linkedListTerm.prevTerm = prevTerm;

    nextTerm?.prevTerm = linkedListTerm;
    linkedListTerm.nextTerm = nextTerm;

    return linkedListTerm;
  }

  void removeSelf() {
    prevTerm?.nextTerm = nextTerm;

    nextTerm?.prevTerm = prevTerm;

    return;
  }

  LinkedListTerm<T> getFirstTerm() {
    LinkedListTerm<T>? term = this;
    while (term?.prevTerm != null) {
      term = term?.prevTerm;
    }
    return term!;
  }

  LinkedListTerm<T> getLastTerm() {
    LinkedListTerm<T>? term = this;
    while (term?.nextTerm != null) {
      term = term?.nextTerm;
    }
    return term!;
  }
}

abstract class AstTerm extends LinkedListTerm<AstTerm> {
  AstTerm({
    super.prevTerm,
    super.nextTerm,
  });

  num solve();

  /// This function must resolve the chain at the end of the computation and return a ref to the new term, if the exisiting one has been replaced. Return itself if that is not the case.
  AstTermNum resolve();
}

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

class AstTermAdd extends AstTermBinaryOperator {
  @override
  num solve() {
    if (prevTerm == null) {
      throw MissingArgumentException();
    }
    if (nextTerm == null) {
      throw MissingArgumentException();
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
    return prevTerm!.solve() + nextTerm!.solve();
  }

  @override
  String toString() {
    return '+';
  }
}

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

class AstTermMultiply extends AstTermBinaryOperator {
  @override
  num solve() {
    if (prevTerm == null) {
      throw MissingArgumentException();
    }
    if (nextTerm == null) {
      throw MissingArgumentException();
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
    return prevTerm!.solve() * nextTerm!.solve();
  }

  @override
  String toString() {
    return '*';
  }
}

class AstTermImplicitMultiply extends AstTermBinaryOperator {
  @override
  num solve() {
    if (prevTerm == null) {
      throw MissingArgumentException();
    }
    if (nextTerm == null) {
      throw MissingArgumentException();
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
    return prevTerm!.solve() * nextTerm!.solve();
  }

  @override
  String toString() {
    return 'Impl*';
  }
}

class AstTermDivide extends AstTermBinaryOperator {
  @override
  num solve() {
    if (prevTerm == null) {
      throw MissingArgumentException();
    }
    if (nextTerm == null) {
      throw MissingArgumentException();
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
    return prevTerm!.solve() / nextTerm!.solve();
  }

  @override
  String toString() {
    return '/';
  }
}

class AstTermExpression extends AstTerm {
  AstTermExpression(
    this.startTerm, {
    this.parenType,
    this.operatorPreccedence = OperatorPreccedence.bodmas,
  });

  final AstTerm startTerm;

  final ParenType? parenType;

  final OperatorPreccedence operatorPreccedence;

  factory AstTermExpression.fromString(
    String str, [
    ParenType? parenType,
    OperatorPreccedence operatorPreccedence = OperatorPreccedence.bodmas,
  ]) {
    List<String> buffer = [];
    List<ParenType> activeParens = [];

    List<AstTerm> list = [];

    // Trim whitespace
    str = str.replaceAll(" ", "");

    void flushBufferAsNum() {
      if (buffer.isNotEmpty) {
        list.add(AstTermNum(num.parse(buffer.join())));
      }
      buffer = [];
      return;
    }

    void flushBufferAsExpr(ParenType parenType) {
      if (buffer.isNotEmpty) {
        list.add(AstTermExpression.fromString(buffer.join()));
      }
      buffer = [];
      return;
    }

    for (final int rune in str.runes) {
      String char = String.fromCharCode(rune);

      if (activeParens.isEmpty) {
        switch (char) {
          // Binary Operators
          case '+':
            flushBufferAsNum();
            list.add(AstTermAdd());
            break;
          case '-':
            flushBufferAsNum();
            list.add(AstTermSubtract());
            break;
          case '*':
            flushBufferAsNum();
            list.add(AstTermMultiply());
            break;
          case '/':
            flushBufferAsNum();
            list.add(AstTermDivide());
            break;
          case '(':
            if (buffer.isNotEmpty) {
              flushBufferAsNum();
            }
            activeParens.add(ParenType.round);
            break;
          case '{':
            if (buffer.isNotEmpty) {
              flushBufferAsNum();
            }
            activeParens.add(ParenType.curly);
            break;
          case '[':
            if (buffer.isNotEmpty) {
              flushBufferAsNum();
            }
            activeParens.add(ParenType.square);
            break;
          default:
            buffer.add(char);
            break;
        }
      } else {
        switch (char) {
          case '(':
            activeParens.add(ParenType.round);
            buffer.add(char);
            break;
          case '{':
            activeParens.add(ParenType.curly);
            buffer.add(char);
            break;
          case '[':
            activeParens.add(ParenType.square);
            buffer.add(char);
            break;
          default:
            if (char == activeParens.last.endStr) {
              if (list.isNotEmpty && list.last is! AstTermBinaryOperator) {
                list.add(AstTermImplicitMultiply());
              }
              var lastParen = activeParens.removeLast();
              if (activeParens.isEmpty) {
                flushBufferAsExpr(lastParen);
              }
            } else {
              buffer.add(char);
            }
            break;
        }
      }
    }

    // if (buffer.isNotEmpty) {
    //   if (activeParens.isEmpty) {
    //     flushBufferAsNum();
    //   } else {
    // 		//
    // 	}
    // }

    while (activeParens.isNotEmpty) {
      flushBufferAsExpr(activeParens.removeLast());
    }
    if (buffer.isNotEmpty) {
      flushBufferAsNum();
    }

    return AstTermExpression.fromList(
      list,
      parenType: parenType,
      operatorPreccedence: operatorPreccedence,
    );
  }

  factory AstTermExpression.fromList(
    List<AstTerm> list, {
    ParenType? parenType,
    OperatorPreccedence operatorPreccedence = OperatorPreccedence.bodmas,
  }) {
    AstTerm initTerm = list[0];
    for (int i = 0; i < list.length; i++) {
      if (i != 0) {
        list[i].prevTerm = list[i - 1];
      }
      if (i != list.length - 1) {
        list[i].nextTerm = list[i + 1];
      }
    }
    return AstTermExpression(
      initTerm,
      parenType: parenType,
      operatorPreccedence: operatorPreccedence,
    );
  }

  @override
  String toString() {
    List<String> str = [];
    AstTerm? currentTerm = startTerm;

    while (currentTerm != null) {
      str.add(currentTerm.toString());
      switch (operatorPreccedence.direction) {
        case Direction.ltr:
          currentTerm = currentTerm.nextTerm;
          break;
        case Direction.rtl:
          currentTerm = currentTerm.prevTerm;
          break;
      }
    }

    return '[${str.join(" ")} | ${operatorPreccedence.direction.name}]';
  }

  List<AstTerm> toList() {
    List<AstTerm> list = [];

    AstTerm? currTerm = startTerm;

    while (currTerm != null) {
      currTerm.prevTerm = null;
      currTerm.nextTerm = null;
      list.add(currTerm);
      switch (operatorPreccedence.direction) {
        case Direction.ltr:
          currTerm = currTerm.nextTerm;
          break;
        case Direction.rtl:
          currTerm = currTerm.prevTerm;
          break;
      }
    }

    return list;
  }

  // startTerm, parenType, operatorPreceedence

  @override
  int get hashCode =>
      startTerm.hashCode * 1 +
      ((parenType?.index ?? -1) + 1) * 15 +
      (operatorPreccedence.hashCode) * 255;

  @override
  bool operator ==(Object other) {
    return (other is AstTermExpression) && (other.toString() == toString());
    //     (other.toList() == toList()) &&
    //     (other.parenType == parenType) &&
    //     (other.operatorPreccedence == operatorPreccedence);
  }

  @override
  AstTermNum resolve() {
    return replaceSelf(AstTermNum(solve())) as AstTermNum;
  }

  @override
  num solve() {
    AstTerm currentTerm;
    currentTerm = startTerm;
    switch (operatorPreccedence.direction) {
      case Direction.ltr:
        for (final Type op in operatorPreccedence.order) {
          // print('Restarting from the begining to check for instances of $op');
          currentTerm = currentTerm.getFirstTerm() as AstTerm;
          while (currentTerm.nextTerm != null) {
            // print('Checking if $currentTerm is $op');
            if (currentTerm.runtimeType != op) {
              // print('${currentTerm.runtimeType} is not $op. Skipping for now');
            } else {
              // print('$currentTerm is $op. Solving');
              currentTerm = currentTerm.resolve();
            }
            if (currentTerm.nextTerm != null) {
              // print('Term exists after. Moving to it');
              currentTerm = currentTerm.nextTerm!;
            } else {
              // print('No term exists after. Terminating');
              break;
            }
          }
        }
        // print('At the end of the evaluation: $currentTerm remains');
        assert(currentTerm.prevTerm == null && currentTerm.nextTerm == null);
        return (currentTerm.getFirstTerm() as AstTerm).solve();
      case Direction.rtl:
        for (final Type op in operatorPreccedence.order) {
          // print('Restarting from the begining to check for instances of $op');
          currentTerm = currentTerm.getLastTerm() as AstTerm;
          while (currentTerm.prevTerm != null) {
            // print('Checking if $currentTerm is $op');
            if (currentTerm.runtimeType != op) {
              // print('${currentTerm.runtimeType} is not $op. Skipping for now');
            } else {
              // print('$currentTerm is $op. Solving');
              currentTerm = currentTerm.resolve();
            }
            if (currentTerm.prevTerm != null) {
              // print('Term exists after. Moving to it');
              currentTerm = currentTerm.prevTerm!;
            } else {
              // print('No term exists after. Terminating');
              break;
            }
          }
        }
        // print('At the end of the evaluation: $currentTerm remains');
        assert(currentTerm.prevTerm == null && currentTerm.nextTerm == null);
        return (currentTerm.getLastTerm() as AstTerm).solve();
    }
  }

  // RegExp get regExp => RegExp(r'(?:(?=.*\()\(.*\)|(?=.*\{)\{.*\}|(?=.*\[)\[.*\]|(?=![\(\{\[]).*)');
}

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

enum Direction {
  ltr,
  rtl,
}

enum ParenType {
  round(startStr: '(', endStr: ')'),
  square(startStr: '[', endStr: ']'),
  curly(startStr: '{', endStr: '}');

  const ParenType({
    required this.startStr,
    required this.endStr,
  });

  final String startStr;
  final String endStr;

  int get startRune => startStr.runes.first;
  int get endRune => endStr.runes.first;
}

enum Operator {
  add,
  sub,
  mul,
  implMul,
  div;

  static List<String> _validOperators = [
    '+',
    '-',
    '*',
    '',
    '/',
  ];

  factory Operator.fromString(String str) {
    switch (str) {
      case '+':
        return Operator.add;
      case '-':
        return Operator.sub;
      case '*':
        return Operator.mul;
      case '/':
        return Operator.div;
      case '':
        return Operator.implMul;
      default:
        throw UnimplementedError('Operator $str has not been implemented yet.');
    }
  }

  static bool isValid(String str) => Operator._validOperators.contains(str);
}
