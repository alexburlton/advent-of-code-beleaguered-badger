import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

void main(List<String> arguments) {
  final input = readIntegerList('day_1/input.txt');

  partA(input);
  partB(input);
}

void partA(KtList<int> input) {
  print(_countIncrements(input));
}

void partB(KtList<int> input) {
  final windowSums = input.windowed(3).map((window) => window.sum());
  print(_countIncrements(windowSums));
}

int _countIncrements(KtList<int> values) => values.windowed(2).filter((window) => window[1] > window[0]).size;