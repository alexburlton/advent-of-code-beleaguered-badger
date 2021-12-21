import 'composite_number.dart';

class ExplodeResult {
  final int left;
  final int right;

  const ExplodeResult(this.left, this.right);
}

class SplitResult {
  final bool splitHappened;
  final SnailfishNumber? splitResult;

  const SplitResult(this.splitHappened, this.splitResult);
}

abstract class SnailfishNumber {
  ExplodeResult? explode(int depth);
  SplitResult split();
  void addLeft(int value);
  void addRight(int value);
  int magnitude();

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
      // print('Exploded to $this');
      return;
    }

    split();
    if (toString() != originalStr) {
      // print('Split to $this');
      return;
    }

    // print('Nothing to reduce');
  }

  SnailfishNumber operator +(SnailfishNumber other) {
    // final leftStr = toString();
    // final rightStr = other.toString();
    final result = CompositeNumber(this, other);
    result.reduce();

    // print('  $leftStr\n+ $rightStr\n= $result\n\n');
    return result;
  }
}