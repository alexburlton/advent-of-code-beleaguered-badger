import 'package:beleaguered_badger/utils/point2d.dart';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

void main(List<String> arguments) {
  final input = readIntegerGrid('day_9/input.txt');
  partA(input);
  partB(input);
}


void partA(KtMap<Point2d, int> heightMap) {
  final points = heightMap.keys;
  final lowPoints = points.filter((pt) => _isLowerThanNeighbours(pt, heightMap));
  final lowRiskLevels = lowPoints.map((lowPt) => heightMap.getValue(lowPt) + 1);
  print(lowRiskLevels.sum());
}

bool _isLowerThanNeighbours(Point2d pt, KtMap<Point2d, int> heightMap) {
  final neighbourValues = heightMap.getNeighbourValues(pt);
  final myValue = heightMap.getValue(pt);

  return neighbourValues.all((neighbourHeight) => neighbourHeight > myValue);
}

void partB(KtMap<Point2d, int> heightMap) {
  var allBasinPoints = _filterToBasinPoints(heightMap.keys, heightMap);
  final basins = mutableListOf<KtSet<Point2d>>();
  while (allBasinPoints.isNotEmpty()) {
    final pt = allBasinPoints[0];
    final basin = _exploreBasin(pt, heightMap);
    basins.add(basin);
    allBasinPoints = allBasinPoints - basin;
  }

  final basinSizes = basins.map((basin) => basin.size).sortedDescending();
  print(basinSizes[0] * basinSizes[1] * basinSizes[2]);
}

KtList<Point2d> _filterToBasinPoints(KtSet<Point2d> points, KtMap<Point2d, int> heightMap)
  => points.filter((pt) => heightMap[pt] != 9 && heightMap[pt] != null);

KtSet<Point2d> _exploreBasin(Point2d startingPt, KtMap<Point2d, int> heightMap) {
  KtSet<Point2d> prevNeighbours = emptySet();
  var currentNeighbours = setOf(startingPt);
  while ((currentNeighbours - prevNeighbours).isNotEmpty()) {
    prevNeighbours = currentNeighbours;
    final newNeighbours = prevNeighbours.flatMap((pt) => getNeighbourPoints2d(pt)).toSet() + prevNeighbours;
    currentNeighbours = _filterToBasinPoints(newNeighbours, heightMap).toSet();
  }

  return currentNeighbours;
}