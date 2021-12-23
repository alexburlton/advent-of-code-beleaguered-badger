import 'dart:core';
import 'package:beleaguered_badger/utils/point2d.dart';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

final input = readDoubleSpacedList('day_20/input.txt');
final enhancementAlgorithm = input[0];
final startingGrid = parseIntegerGrid(input[1].split('\n').toKtList(), _parsePixel);

void main(List<String> arguments) {
  partA();
  partB();
}

void partA() => _enhanceNTimes(2);
void partB() => _enhanceNTimes(50);

void _enhanceNTimes(int n) {
  final startTime = DateTime.now().millisecondsSinceEpoch;
  var grid = startingGrid;
  for (var i=0; i<n; i++) {
    grid = _enhanceImage(grid, i);
  }

  final timeTaken = DateTime.now().millisecondsSinceEpoch - startTime;
  print('$n: ${grid.values.filter((value) => value == 1).size} in $timeTaken ms');
}

KtMap<Point2d, int> _enhanceImage(KtMap<Point2d, int> grid, int iteration) {
  final defaultVal = _computeBoundaryPixels(iteration);

  final mappedInternals = grid.mapValues((entry) => _getNewValue(entry.key, grid, defaultVal));

  final result = mutableMapFrom<Point2d, int>(mappedInternals.asMap());
  final newXValues = makeInclusiveList(grid.xMin().toInt() - 1, grid.xMax().toInt() + 1);
  final newYValues = makeInclusiveList(grid.yMin().toInt() - 1, grid.yMax().toInt() + 1);

  final leftCol = newYValues.map((y) => Point2d(newXValues.min()!, y));
  final rightCol = newYValues.map((y) => Point2d(newXValues.max()!, y));
  final topRow = newXValues.map((x) => Point2d(x, newYValues.min()!));
  final bottomRow = newXValues.map((x) => Point2d(x, newYValues.max()!));
  final allNewPoints = (leftCol + rightCol + topRow + bottomRow).distinct();

  for (var newPt in allNewPoints.iter) {
    result[newPt] = _getNewValue(newPt, grid, defaultVal);
  }

  return result.toMap();
}

int _getNewValue(Point2d pt, KtMap<Point2d, int> grid, int defaultVal) {
  final neighbours = getAllNeighboursSorted(pt);
  final binaryStr = neighbours.map((pt) => grid.getOrDefault(pt, defaultVal)).joinToString(separator: '');
  final algorithmValue = enhancementAlgorithm[parseBinaryString(binaryStr)];
  return _parsePixel(algorithmValue);
}

int _computeBoundaryPixels(int iteration) {
  if (iteration == 0) {
    // They start off unlit
    return 0;
  }

  final parity = iteration % 2;
  if (parity == 1) {
    return _parsePixel(enhancementAlgorithm[0]);
  } else {
    return 0;
  }
}

int _parsePixel(String pixel) => pixel == '#' ? 1 : 0;
