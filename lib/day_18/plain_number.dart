
import 'composite_number.dart';
import 'snailfish_number.dart';

class PlainNumber extends SnailfishNumber {
  int value;

  PlainNumber(this.value);

  @override
  ExplodeResult? explode(int depth) => null;

  @override
  SnailfishNumber copy() => PlainNumber(value);

  @override
  SnailfishNumber? split() {
    if (value >= 10) {
      return CompositeNumber(PlainNumber((value/2).floor()), PlainNumber((value/2).ceil()));
    }

    return null;
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