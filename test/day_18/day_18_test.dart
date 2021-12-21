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

    // no-op (already reduced)
    _testSingleExplosion('[[[[0,7],4],[[7,8],[6,0]]],[8,1]]', '[[[[0,7],4],[[7,8],[6,0]]],[8,1]]');
  });

  _testSingleSplit(String startStr, String expectedStr) {
    final snailfish = parseSnailfishNumber(startStr);
    snailfish.split();
    expect(snailfish.toString(), equals(expectedStr));
  }
  test('splitting', () {
    _testSingleSplit('[[[[0,7],4],[15,[0,13]]],[1,1]]', '[[[[0,7],4],[[7,8],[0,13]]],[1,1]]');
    _testSingleSplit('[[[[0,7],4],[[7,8],[0,13]]],[1,1]]', '[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]');

    // no-op (already reduced)
    _testSingleSplit('[[[[0,7],4],[[7,8],[6,0]]],[8,1]]', '[[[[0,7],4],[[7,8],[6,0]]],[8,1]]');
  });

  _testReduction(String startStr, String expectedStr) {
    final snailfish = parseSnailfishNumber(startStr);
    snailfish.reduce();
    expect(snailfish.toString(), equals(expectedStr));
  }
  test('reducing', () {
    //_testReduction('[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]', '[[[[0,7],4],[[7,8],[6,0]]],[8,1]]');
    //_testReduction('[[[[0,7],4],[7,[[8,4],9]]],[1,1]]', '[[[[0,7],4],[[7,8],[6,0]]],[8,1]]');
    //_testReduction('[[[[0,7],4],[15,[0,13]]],[1,1]]', '[[[[0,7],4],[[7,8],[6,0]]],[8,1]]');
    //_testReduction('[[[[0,7],4],[[7,8],[0,13]]],[1,1]]', '[[[[0,7],4],[[7,8],[6,0]]],[8,1]]');
    //_testReduction('[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]', '[[[[0,7],4],[[7,8],[6,0]]],[8,1]]');
    _testReduction('[[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]],[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]]', '[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]');

    // no-op (already reduced)
    //_testReduction('[[[[0,7],4],[[7,8],[6,0]]],[8,1]]', '[[[[0,7],4],[[7,8],[6,0]]],[8,1]]');
  });

  test('adding', () {
    final left = parseSnailfishNumber('[[[[4,3],4],4],[7,[[8,4],9]]]');
    final right = parseSnailfishNumber('[1,1]');

    expect((left+right).toString(), equals('[[[[0,7],4],[[7,8],[6,0]]],[8,1]]'));
  });

  int _getMagnitude(String snailStr) => parseSnailfishNumber(snailStr).magnitude();
  test('magnitude', () {
    expect(_getMagnitude('[[1,2],[[3,4],5]]'), equals(143));
    expect(_getMagnitude('[[[[0,7],4],[[7,8],[6,0]]],[8,1]]'), equals(1384));
    expect(_getMagnitude('[[[[1,1],[2,2]],[3,3]],[4,4]]'), equals(445));
    expect(_getMagnitude('[[[[3,0],[5,3]],[4,4]],[5,5]]'), equals(791));
  });
}