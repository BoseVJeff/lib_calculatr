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
