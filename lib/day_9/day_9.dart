import 'dart:math';

import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

void main(List<String> arguments) {
  final input = readIntegerGrid('day_9/input.txt');
  partA(input);
}


void partA(KtMap<Point, int> heightMap) {
  final points = heightMap.keys;
  final lowPoints = points.filter((pt) => _isLowerThanNeighbours(pt, heightMap));
  final lowRiskLevels = lowPoints.map((lowPt) => heightMap.getValue(lowPt) + 1);
  print(lowRiskLevels.sum());
}

bool _isLowerThanNeighbours(Point pt, KtMap<Point, int> heightMap) {
  final neighbourValues = heightMap.getNeighbourValues(pt);
  final myValue = heightMap.getValue(pt);

  return neighbourValues.all((neighbourHeight) => neighbourHeight > myValue);
}

void partB(KtMap<Point, int> heightMap) {
  final points = heightMap.keys;
  final lowPoints = points.filter((pt) => _isLowerThanNeighbours(pt, heightMap));
  final lowRiskLevels = lowPoints.map((lowPt) => heightMap.getValue(lowPt) + 1);
  print(lowRiskLevels.sum());
}