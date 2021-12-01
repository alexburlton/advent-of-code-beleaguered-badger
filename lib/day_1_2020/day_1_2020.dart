import 'package:kt_dart/kt.dart';
import 'package:trotter/trotter.dart';

import 'package:beleaguered_badger/utils/utils.dart';

void main(List<String> arguments) {
  final inputLines = readIntegerList('day_1_2020/input.txt');

  print('Part A: ${getExpenseReportProduct(inputLines, 2)}');
  print('Part B: ${getExpenseReportProduct(inputLines, 3)}');
}

num getExpenseReportProduct(KtList<int> report, int count) {
  final combos = report.asList().combinations(count)().map((it) => it.map((element) => element.toInt()).toList()).toList();
  final correctCombos = combos.where((combo) => sumsTo2020(combo));
  return correctCombos.first.product();
}

bool sumsTo2020(List<int> list) => list.toKtList().sum() == 2020;