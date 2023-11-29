import 'package:lib_calculatr/lib_calculatr.dart';
import 'package:test/test.dart';

void main() {
  test('solve', () {
    expect(solve('5*4'), equals(20));
    expect(solve('(5)(4)'), equals(20));
    expect(solve('(5)(4)/2'), equals(10));
  });
}
