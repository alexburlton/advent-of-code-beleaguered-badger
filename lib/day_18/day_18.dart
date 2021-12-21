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
  partA();
  partB();
}

void partA() {
  final snailfishNumbers = readStringList('day_18/input.txt').map(parseSnailfishNumber).asList();
  final result = _sumSnailfishNumbers(snailfishNumbers);
  // print(result.toString());
  print(result.magnitude());
}

void partB() {
  final snailfishStrings = readStringList('day_18/input.txt');

  if (snailfishStrings.distinct().size != snailfishStrings.size) {
    print('This isnt gonna work!');
  }

  var largestMagnitude = 0;
  for (var snailfishOne in snailfishStrings.iter) {
    for (var snailfishTwo in snailfishStrings.iter) {
       if (snailfishOne == snailfishTwo) {
         continue;
       }

       final resultOne = parseSnailfishNumber(snailfishOne) + parseSnailfishNumber(snailfishTwo);
       final resultTwo = parseSnailfishNumber(snailfishTwo) + parseSnailfishNumber(snailfishOne);
       largestMagnitude = listOf(largestMagnitude, resultOne.magnitude(), resultTwo.magnitude()).max()!;
    }
  }

  print(largestMagnitude);
}

SnailfishNumber _sumSnailfishNumbers(List<SnailfishNumber> numbers) {
  return numbers.reduce((left, right) => left + right);
}

