import 'dart:core';

import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

class ExplodeResult {
  final int? left;
  final int? right;

  const ExplodeResult(this.left, this.right);

  bool isInitial() => left != null && right != null;
}

abstract class SnailfishNumber {
  ExplodeResult? explode(int depth);
  CompositeNumber? split();
  void addLeft(int value);
  void addRight(int value);

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

    if (toString() == originalStr) {
      split();
      if (toString() != originalStr) {
        print('Split to $this');
      }
    } else {
      print('Exploded to $this');
    }
  }

  SnailfishNumber operator +(SnailfishNumber other) {
    final leftStr = toString();
    final rightStr = other.toString();
    final result = CompositeNumber(this, other);
    result.reduce();

    print('  $leftStr\n+ $rightStr\n= $result\n\n');
    return result;
  }
}

class PlainNumber extends SnailfishNumber {
  int value;

  PlainNumber(this.value);

  @override
  ExplodeResult? explode(int depth) => null;

  @override
  CompositeNumber? split() {
    if (value >= 10) {
      return CompositeNumber(PlainNumber((value/2).floor()), PlainNumber((value/2).ceil()));
    }

    return null;
  }

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
  CompositeNumber? split() {
    final leftResult = left.split();
    if (leftResult != null) {
      left = leftResult;
      return null;
    }

    final rightResult = right.split();
    if (rightResult != null) {
      right = rightResult;
      return null;
    }

    return null;
  }

  @override
  ExplodeResult? explode(int depth) {
    if (depth == 4) {
      return ExplodeResult((left as PlainNumber).value, (right as PlainNumber).value);
    }

    final leftResult = left.explode(depth+1);
    final rightComponent = leftResult?.right;
    if (leftResult != null && rightComponent != null) {
      right.addLeft(rightComponent);
      if (leftResult.isInitial()) {
        left = PlainNumber(0);
      }
      return ExplodeResult(leftResult.left, null);
    }

    if (leftResult != null) {
      return leftResult;
    }

    final rightResult = right.explode(depth+1);
    final leftComponent = rightResult?.left;
    if (rightResult != null && leftComponent != null) {
      left.addRight(leftComponent);
      if (rightResult.isInitial()) {
        right = PlainNumber(0);
      }
      return ExplodeResult(null, rightResult.right);
    }

    if (rightResult != null) {
      return rightResult;
    }

    return null;
  }

  @override
  String toString() => "[$left,$right]";
}

SnailfishNumber parseSnailfishNumber(String snailfishString) {
  final intValue = int.tryParse(snailfishString);
  if (intValue != null) {
    return PlainNumber(intValue);
  }

  // Composite
  final strippedBrackets = snailfishString.substring(1, snailfishString.length - 1);
  final commaIndex = _findTopLevelCommaIndex(strippedBrackets);
  final leftString = strippedBrackets.substring(0, commaIndex);
  final rightString = strippedBrackets.substring(commaIndex+1, strippedBrackets.length);
  return CompositeNumber(parseSnailfishNumber(leftString.trim()), parseSnailfishNumber(rightString.trim()));
}

int _findTopLevelCommaIndex(String str) {
  var depth = 0;
  for (var i=0; i<str.length; i++) {
    if (str[i] == '[') {
      depth++;
    } else if (str[i] == ']') {
      depth--;
    } else if (str[i] == ',' && depth == 0) {
      return i;
    }
  }

  print("uh-oh");
  return -1;
}

void main(List<String> arguments) {
  final snailfishNumbers = readStringList('day_18/example_input.txt').map(parseSnailfishNumber);
  final result = snailfishNumbers.reduce<SnailfishNumber>((left, right) => left + right);
  print(result.toString());
}


