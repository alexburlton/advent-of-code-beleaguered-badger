import 'package:beleaguered_badger/day_18/plain_number.dart';
import 'package:beleaguered_badger/day_18/snailfish_number.dart';

class CompositeNumber extends SnailfishNumber {
  SnailfishNumber left;
  SnailfishNumber right;

  CompositeNumber(this.left, this.right);

  @override
  void addLeft(int value) {
    left.addLeft(value);
  }

  @override
  void addRight(int value) {
    right.addRight(value);
  }

  @override
  int magnitude() => (3 * left.magnitude()) + (2 * right.magnitude());

  @override
  SplitResult split() {
    final leftResult = left.split();
    if (leftResult.splitHappened) {
      final result = leftResult.splitResult;
      if (result != null) {
        left = result;
      }

      return SplitResult(true, null);
    }

    final rightResult = right.split();
    if (rightResult.splitHappened) {
      final result = rightResult.splitResult;
      if (result != null) {
        right = result;
      }

      return SplitResult(true, null);
    }

    return SplitResult(false, null);
  }

  @override
  ExplodeResult? explode(int depth) {
    if (depth == 4) {
      return ExplodeResult((left as PlainNumber).value, (right as PlainNumber).value);
    }

    final leftResult = left.explode(depth+1);
    if (leftResult != null) {
      right.addLeft(leftResult.right);
      if (depth == 3) {
        left = PlainNumber(0);
      }
      return ExplodeResult(leftResult.left, 0);
    }

    final rightResult = right.explode(depth+1);
    if (rightResult != null) {
      left.addRight(rightResult.left);
      if (depth == 3) {
        right = PlainNumber(0);
      }
      return ExplodeResult(0, rightResult.right);
    }

    return null;
  }

  @override
  String toString() => "[$left,$right]";
}