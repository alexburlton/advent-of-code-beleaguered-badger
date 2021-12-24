import 'package:beleaguered_badger/day_24/day_24.dart';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';
import 'package:test/test.dart';

void main() {
  void _verifySimplifiedSameAsActual(int number) {
    final input = readStringList('day_24/input.txt');
    final simpleInput = readStringList('day_24/simplified_input.txt');

    final computerA = AluComputer(input);
    final computerB = AluComputer(simpleInput);

    final inputs = number.toString().split('').map((digitStr) => int.parse(digitStr)).toImmutableList();
    computerA.processInstructions(inputs);
    computerB.processInstructions(inputs);

    expect(computerA.getResultStr(), equals(computerB.getResultStr()));
  }
  test('example program', () {
    _verifySimplifiedSameAsActual(99999999999999);
    _verifySimplifiedSameAsActual(88888888888888);
    _verifySimplifiedSameAsActual(77777777777777);
    _verifySimplifiedSameAsActual(66666666666666);
    _verifySimplifiedSameAsActual(55555555555555);
    _verifySimplifiedSameAsActual(44444444444444);
    _verifySimplifiedSameAsActual(33333333333333);
    _verifySimplifiedSameAsActual(22222222222222);
    _verifySimplifiedSameAsActual(11111111111111);
    _verifySimplifiedSameAsActual(29989297949519);
    _verifySimplifiedSameAsActual(19518121316118);
  });
}