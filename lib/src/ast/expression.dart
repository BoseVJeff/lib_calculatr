import '../utils/enums.dart';
import '../utils/operator_preccedence.dart';
import 'add.dart';
import 'base.dart';
import 'binary_ops.dart';
import 'divide.dart';
import 'multiply.dart';
import 'multiply_implicit.dart';
import 'num.dart';
import 'subtract.dart';

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
