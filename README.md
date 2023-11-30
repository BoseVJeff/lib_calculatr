<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

A Dart library to evaluate mathematical expressions from strings. Can be customised to use custom evaluation order.

## Features

This library lets you evaluate mathematical expressions as a part of your normal Dart program. This hepls you evaluate expressions that are obtained as strings, as a part of user input or as a part of an API.

One possible use case is to combine this library with another tool or function that generates mathematical expression as a string (like another user or a LLM) and then pass the result to this library for evaluation.

## Getting started

If you are using this in a Flutter project:
```sh
flutter pub add lib_calculatr
```

If you are using this in a Dart project:
```sh
dart pub add lib_calculatr
```

## Usage

The library provides a top-level `solve` function that takes a `String` as its input and returns a `num` after solving the result.

```dart
import 'package:lib_calculatr/lib_calculatr.dart';

void main(List<String> args) {
  print(solve('6 * 7'));
}
```

By default, this evaluates expressions using a BODMAS/PEMDAS order. Operators of the same expression are evaluated left-to-right.

### Changing Order of Operations

Order of expressions is determined by the `OperatorPreccedence` passed to the `solve` function. The default value is `OperatorPreccedence.bodmas`, but this can be changed.

To use a custom order, instantiate a new `OperatorPreccedence` class. This can be done as follows:
```dart
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
```

Optionally, this can also be done by using `OperatorPreccedence.custom` as follows:
```dart
static const OperatorPreccedence customPreccedence=OperatorPreccedence.custom(direction: Direction.ltr); // `direction` is optional
customPreccedence.add(AstTermExpression);
```

This can be useful when the operators are meant to be added incrementally, for example as a part of a larger process.

Note that the class includes both, the order and the direction of operations.

The list is a list of types. Each type corresonds to a class that **must** extend `AstTerm`. For convenience, a class `AstTermBinaryOperator` can be extended instead. This can be convenient for binary operators like the `+` operator. Note that using `OperatorPreccedence.add` will enforce this type check while using `OperatorPreccedence` will not.

### Adding Custom Operators

Custom operators can be added by extending the `AstTermBinaryOperator` class.
```dart
import 'package:lib_calculatr/calculatr_base.dart';

class Modulo extends AstTermBinaryOperator {
  // Must be overridden to allow the equality operations to work.
  @override
  String toString() => '%';

  @override
  num solve() {
    // The term immediately before & after can be accessed using prevTerm & nextTerm respectively (type: AstTerm?).
    // For most usecases, you will want to work with numbers instead. In that case, use prevTerm.solve() and nextTerm.solve() to get the numbers.
    // So, for modulo, after implementing all the null checks, you will want to return `prevTerm.solve()%nextTerm.solve()` at the end.
    // For an example implementation, check the implementation of `AstTermAdd` available at `lib\src\ast\add.dart`.
    // Implementation here
    throw UnimplementedError();
  }
}
```

## Additional information

Report any issues on Github.
