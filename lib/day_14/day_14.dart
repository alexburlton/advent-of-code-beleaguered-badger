import 'dart:core';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

void main(List<String> arguments) {
  final input = readDoubleSpacedList('day_14/example_input.txt');
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

void partA(String polymer, KtMap<String, String> replacements) =>
    _doIterations(polymer, replacements, 10);

void partB(String polymer, KtMap<String, String> replacements) =>
    _doIterations(polymer, replacements, 40);

void _doIterations(String polymer, KtMap<String, String> replacements, int iterations) {
  var pairToCount = _getPairCounts(polymer);
  for (var step=0; step<iterations; step++) {
    pairToCount = _applyStep(pairToCount, replacements);
  }

  final letterCounts = _getLetterCounts(pairToCount).values;
  print(letterCounts.max()! - letterCounts.min()!);
}

KtMap<String, int> _applyStep(KtMap<String, int> pairCounts, KtMap<String, String> replacements) {
  final newMap = mutableMapFrom<String, int>();
  for (var entry in pairCounts.iter) {
    final pairCount = entry.value;
    final pair = entry.key;
    final replacement = replacements[pair];
    if (replacement != null) {
      newMap.incrementCountBy("${pair[0]}$replacement", amount: pairCount);
      newMap.incrementCountBy("$replacement${pair[1]}", amount: pairCount);
    }
  }

  return newMap.toMap();
}

KtMap<String, int> _getPairCounts(String polymer) {
  final windows = polymer.split('').toKtList().windowed(2);
  final pairs = windows.map((pair) => pair.joinToString(separator: ''));
  return pairs.groupBy((pair) => pair).mapValues((entry) => entry.value.size);
}

KtMap<String, int> _getLetterCounts(KtMap<String, int> pairCounts) {
  final letterMap = mutableMapFrom<String, int>();
  for (var entry in pairCounts.iter) {
    final count = entry.value;
    final pair = entry.key;

    letterMap.incrementCountBy(pair[0], amount: count);
    letterMap.incrementCountBy(pair[1], amount: count);
  }

  return letterMap.mapValues((entry) => (entry.value/2).ceil());
}
