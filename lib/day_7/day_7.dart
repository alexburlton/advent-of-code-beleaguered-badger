import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

void main(List<String> arguments) {
  final input = readFile('day_7/input.txt');
  final crabs = input.split(',').map((numStr) => int.parse(numStr)).toList().toKtList();
  partA(crabs);
  partB(crabs);
}

void partA(KtList<int> crabs) {
  print(calculateOptimalAlignment(crabs, getTotalFuelForAlignment));
}

void partB(KtList<int> crabs) {
  print(calculateOptimalAlignment(crabs, getTotalFuelForAlignmentB));
}

int calculateOptimalAlignment(KtList<int> crabs, int Function(KtList<int>, int) computeFuel) {
  final minAlignment = crabs.min()!;
  final maxAlignment = crabs.max()!;

  final possibleAlignments = makeInclusiveList(minAlignment, maxAlignment);
  final fuelCosts = possibleAlignments.map((alignment) => computeFuel(crabs, alignment));
  return fuelCosts.min()!;
}

int getTotalFuelForAlignment(KtList<int> crabs, int desiredPosition) =>
  crabs.map((crab) => (crab - desiredPosition).abs()).sum();

int getTotalFuelForAlignmentB(KtList<int> crabs, int desiredPosition) =>
  crabs.map((crab) => getNthTriangleNumber((crab - desiredPosition).abs())).sum();

int getNthTriangleNumber(int n) => n * (n + 1) ~/ 2;