import 'dart:math';

import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';
import 'package:basic_utils/basic_utils.dart';

void main(List<String> arguments) {
  final input = readDoubleSpacedList('day_14/input.txt');
  final polymerStr = input[0];
  final replacements = input[1].split('\n').toKtList();
  final replacementsMap = _getReplacementsMap(replacements);

  partA(polymerStr, replacementsMap);
  partB(polymerStr, replacementsMap);
}

KtMap<String, String> _getReplacementsMap(KtList<String> replacements) {
  final map = mutableMapFrom<String, String>();
  replacements.forEach((replacementStr) {
    final elementsAndReplacement = replacementStr.split(' -> ');
    map[elementsAndReplacement[0]] = elementsAndReplacement[1];
  });

  return map.toMap();
}

void partA(String polymer, KtMap<String, String> replacements) {
  var newPolymer = polymer;
  for (var i=0; i<10; i++) {
    newPolymer = applyStep(newPolymer, replacements);
  }

  final elementCounts = newPolymer.split('').toKtList().groupBy((str) => str);
  final maxCount = elementCounts.maxBy((entry) => entry.value.size)!.value.size;
  final minCount = elementCounts.minBy((entry) => entry.value.size)!.value.size;

  print(maxCount - minCount);
}

void partB(String polymer, KtMap<String, String> replacements) {
  // Hmm...
}

String applyStep(String polymer, KtMap<String, String> replacements) {
  var newPolymer = polymer;
  for (var ix=polymer.length-2; ix>=0; ix--) {
    final pair = "${polymer[ix]}${polymer[ix + 1]}";
    final elementToInsert = replacements[pair];
    if (elementToInsert != null) {
      newPolymer = StringUtils.addCharAtPosition(newPolymer, elementToInsert, ix+1);
    }

    // print('Considered $pair, found $elementToInsert, new polymer is $newPolymer');
  }

  return newPolymer;
}
