import 'dart:core';
import 'dart:math';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

abstract class SnailfishNumber {}
class PlainNumber extends SnailfishNumber {
  final int value;

  PlainNumber(this.value);

  @override
  String toString() => value.toString();
}

class CompositeNumber extends SnailfishNumber {
  final SnailfishNumber left;
  final SnailfishNumber right;

  CompositeNumber(this.left, this.right);

  @override
  String toString() => "[$left, $right]";
}

final numberRegex = RegExp(r'[0-9]+');

void main(List<String> arguments) {
  explodeSnailfishNumber('[[[[[9,8],1],2],3],4]');

  print('[[[[[9,8],1],2],3],4]'.indexOf(numberRegex));
}

String explodeSnailfishNumber(String inputLine) {
  var depth = 0;
  final elements = inputLine.split('').toList();
  for (var ix=0; ix<elements.length; ix++) {
    final str = elements[ix];
    if (str == '[') {
      depth++;
    } else if (str == ']') {
      depth--;
    } else {
      if (depth == 5) {
        final commaIndex = inputLine.indexOf(',', ix);
        final closeBracket = inputLine.indexOf(']', commaIndex);
        final left = inputLine.substring(ix, commaIndex);
        final right = inputLine.substring(commaIndex+1, closeBracket);
        print('Splitting. Left: $left, Right: $right');
      }
    }
  }

  return '';
}


