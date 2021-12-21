
import 'composite_number.dart';
import 'snailfish_number.dart';

class PlainNumber extends SnailfishNumber {
  int value;

  PlainNumber(this.value);

  @override
  ExplodeResult? explode(int depth) => null;

  @override
  SplitResult split() {
    if (value >= 10) {
      return SplitResult(true, CompositeNumber(PlainNumber((value/2).floor()), PlainNumber((value/2).ceil())));
    }

    return SplitResult(false, null);
  }

  @override
  int magnitude() => value;

  @override
  void addLeft(int value) {
    this.value += value;
  }

  @override
  void addRight(int value) {
    this.value += value;
  }

  @override
  String toString() => value.toString();
}