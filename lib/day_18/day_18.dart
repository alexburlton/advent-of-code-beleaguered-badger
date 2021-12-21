import 'dart:core';

import 'package:beleaguered_badger/day_18/snailfish_number.dart';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

import 'composite_number.dart';
import 'plain_number.dart';


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
  print(result.magnitude());
}


