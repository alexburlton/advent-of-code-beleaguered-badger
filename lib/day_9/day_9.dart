import 'dart:math';

import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

void main(List<String> arguments) {
  final input = readIntegerGrid('day_9/input.txt');
  partA(input);
  partB(input);
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
  var allBasinPoints = _filterToBasinPoints(heightMap.keys, heightMap);
  final basins = mutableListOf<KtSet<Point>>();
  while (allBasinPoints.isNotEmpty()) {
    final pt = allBasinPoints[0];
    final basin = _exploreBasin(pt, heightMap);
    basins.add(basin);
    allBasinPoints = allBasinPoints - basin;
  }

  final basinSizes = basins.map((basin) => basin.size).sortedDescending();
  print(basinSizes[0] * basinSizes[1] * basinSizes[2]);
}

KtList<Point> _filterToBasinPoints(KtSet<Point> points, KtMap<Point, int> heightMap)
  => points.filter((pt) => heightMap[pt] != 9 && heightMap[pt] != null);

KtSet<Point> _exploreBasin(Point startingPt, KtMap<Point, int> heightMap) {
  KtSet<Point> prevNeighbours = emptySet();
  var currentNeighbours = setOf(startingPt);
  while ((currentNeighbours - prevNeighbours).isNotEmpty()) {
    prevNeighbours = currentNeighbours;
    final newNeighbours = prevNeighbours.flatMap((pt) => getNeighbourPoints(pt)).toSet() + prevNeighbours;
    currentNeighbours = _filterToBasinPoints(newNeighbours, heightMap).toSet();
  }

  return currentNeighbours;
}