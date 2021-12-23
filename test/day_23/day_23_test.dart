import 'package:beleaguered_badger/day_23/day_23.dart';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  test('completed state', () {
    final input = readStringGrid('day_23/completedState.txt');
    final burrowState = parseBurrowState(input);
    expect(burrowState.isCompleted(), equals(true));
  });
}