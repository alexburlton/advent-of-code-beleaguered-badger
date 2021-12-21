import 'composite_number.dart';

class ExplodeResult {
  final int left;
  final int right;

  const ExplodeResult(this.left, this.right);
}

abstract class SnailfishNumber {
  ExplodeResult? explode(int depth);
  SnailfishNumber? split();
  void addLeft(int value);
  void addRight(int value);
  int magnitude();
  SnailfishNumber copy();

  void reduce() {
    var oldStr = toString();
    _applySingleReduction();
    var newStr = toString();

    while (newStr != oldStr) {
      oldStr = newStr;
      _applySingleReduction();
      newStr = toString();
    }
  }

  void _applySingleReduction() {
    final originalStr = toString();
    explode(0);

    if (toString() != originalStr) {
      print('Exploded to $this');
      return;
    }

    split();
    if (toString() != originalStr) {
      print('Split to $this');
    }

    print('Nothing to reduce');
  }

  SnailfishNumber operator +(SnailfishNumber other) {
    final leftStr = toString();
    final rightStr = other.toString();
    final result = CompositeNumber(copy(), other.copy());
    result.reduce();

    print('  $leftStr\n+ $rightStr\n= $result\n\n');
    return result;
  }
}