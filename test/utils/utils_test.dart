import 'package:kt_dart/kt.dart';
import 'package:test/test.dart';
import 'package:beleaguered_badger/utils/utils.dart';

void main() {
  test('transpose 2x3', () {
    final matrix = listOf(listOf(1, 2), listOf(3, 4), listOf(5, 6));
    final transposed = matrix.transpose();
    expect(transposed, equals(listOf(listOf(1, 3, 5), listOf(2, 4, 6))));
  });

  test('transpose 3x2', () {
    final matrix = listOf(listOf(1, 3, 5), listOf(2, 4, 6));
    final transposed = matrix.transpose();
    expect(transposed, equals(listOf(listOf(1, 2), listOf(3, 4), listOf(5, 6))));
  });
}