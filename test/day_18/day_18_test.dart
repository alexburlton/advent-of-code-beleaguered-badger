import 'package:beleaguered_badger/day_18/day_18.dart';
import 'package:test/test.dart';

void main() {
  void _testParsing(String snailfishStr) => expect(parseSnailfishNumber(snailfishStr).toString(), equals(snailfishStr));
  test('parsing', () {
    _testParsing('[[[[[9,8],1],2],3],4]');
    _testParsing('[[1,1],[2,2]]');
    _testParsing('[7,[6,[5,[4,[3,2]]]]]');
  });

  _testSingleExplosion(String startStr, String expectedStr) {
    final snailfish = parseSnailfishNumber(startStr);
    snailfish.explode(0);
    expect(snailfish.toString(), equals(expectedStr));
  }
  test('exploding', () {
    _testSingleExplosion('[[[[[9,8],1],2],3],4]', '[[[[0,9],2],3],4]');
    _testSingleExplosion('[7,[6,[5,[4,[3,2]]]]]', '[7,[6,[5,[7,0]]]]');
    _testSingleExplosion('[[6,[5,[4,[3,2]]]],1]', '[[6,[5,[7,0]]],3]');
    _testSingleExplosion('[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]', '[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]');
    _testSingleExplosion('[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]', '[[3,[2,[8,0]]],[9,[5,[7,0]]]]');
  });


}