import 'package:trotter/trotter.dart';

import 'package:beleaguered_badger/utils/utils.dart';

void main(List<String> arguments) {
  final inputLines = readIntegerList('day_1_2020/input.txt');

  print('Part A: ${getExpenseReportProduct(inputLines, 2)}');
  print('Part B: ${getExpenseReportProduct(inputLines, 3)}');
}

num getExpenseReportProduct(List<int> report, int count) {
  final correctCombos = report.combinations(count)().where((combo) => sumsTo2020(combo));
  return correctCombos.first.product();
}

bool sumsTo2020(List<num> list) => list.sum() == 2020;