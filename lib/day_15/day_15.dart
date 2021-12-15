import 'dart:core';
import 'dart:math';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

var map = readIntegerGrid('day_15/input.txt');
final pointToMinimalCost = mutableMapFrom<Point, int>();

void main(List<String> arguments) {
  pointToMinimalCost[Point(0, 0)] = map.getValue(Point(0, 0));
  partA();
  partB();
}

void partA() {
  final startPt = Point(0, 0);
  final endPt = map.keys.maxBy((pt) => pt.x + pt.y)!;

  final paths = _getAllPaths(startPt, endPt);
  print(_getPathCost(paths.first()) - map.getValue((Point(0, 0))));
}

void partB() {
  replicateMap();

  final startPt = Point(0, 0);
  final endPt = map.keys.maxBy((pt) => pt.x + pt.y)!;

  final paths = _getAllPaths(startPt, endPt);
  print('-------');
  print(_getPathCost(paths.first()) - map.getValue((Point(0, 0))));
}

void replicateMap() {
  final endPt = map.keys.maxBy((pt) => pt.x + pt.y)!;
  print(endPt);
  final width = endPt.x + 1;
  final height = endPt.y + 1;

  var newMap = map;
  for (var x=0; x<5; x++) {
    for (var y=0; y<5; y++) {
      final newValues = map
          .mapKeys((entry) => Point(entry.key.x + (x * width), entry.key.y + (y * height)))
          .mapValues((entry) =>
      (entry.value + x + y) % 10 + (entry.value + x + y) ~/ 10);

      newMap = newMap + newValues;
    }
  }

  map = newMap;
}

KtList<KtList<Point>> _getAllPaths(Point startPt, Point endPt) {
  var paths = listOf(listOf(startPt));
  var steps = 0;
  while (!_allFinished(paths, endPt)) {
    final isMajorStep = steps % 50 == 0;
    if (isMajorStep) {
      final maxPt = paths.map((path) => path.last()).maxBy((pt) => pt.x + pt.y)!;
      print("Considering ${paths.size} paths, up to $maxPt");
    }

    paths = _takeAllSteps(paths, endPt, isMajorStep);
    steps++;
  }

  return paths;
}

KtList<KtList<Point>> _takeAllSteps(KtList<KtList<Point>> pathsSoFar, Point endPt, bool isMajorStep) {
  final allNextSteps = pathsSoFar.flatMap((pathSoFar) {
    final lastPoint = pathSoFar.last();
    if (lastPoint == endPt) {
      // Already finished
      return listOf(pathSoFar);
    }

    final potentialNextSteps = getNeighbourPoints(lastPoint);
    final nextSteps = potentialNextSteps.filter((pt) => map.containsKey(pt) && !pathSoFar.contains(pt));
    if (nextSteps.isEmpty()) {
      return emptyList<KtList<Point>>();
    }
    return nextSteps.map((nextStep) => pathSoFar + listOf(nextStep));
  });

  return _removeSuboptimalRoutes(allNextSteps, isMajorStep);
}

KtList<KtList<Point>> _removeSuboptimalRoutes(KtList<KtList<Point>> pathsSoFar, bool isMajorStep) {
  _updateMinimalCostsMemo(pathsSoFar);
  final potentialMinimalPaths = pathsSoFar.filter((path) => _pathCouldBeMinimal(path, isMajorStep));
  return potentialMinimalPaths.distinctBy((p0) => p0.last());
}

bool _pathCouldBeMinimal(KtList<Point> path, bool isMajorStep) {
  final startIndex = isMajorStep ? max(path.size - 50, 0) : max(path.size - 5, 0);
  for (var i=path.size - 1; i>=startIndex; i--) {
    final pt = path[i];
    final subPath = path.subList(0, i+1);
    if (_getPathCost(subPath) != pointToMinimalCost[pt]) {
      return false;
    }
  }

  return true;
}

void _updateMinimalCostsMemo(KtList<KtList<Point>> pathsSoFar) {
  final groupings = pathsSoFar.groupBy((path) => path.last());
  final pointToBestCosts = groupings.mapValues((entry) => entry.value.map(_getPathCost).min()!);

  for (var pt in pointToBestCosts.keys.iter) {
    final currentBest = pointToMinimalCost.getOrDefault(pt, 0x7fffffffffffffff);
    pointToMinimalCost[pt] = min(currentBest, pointToBestCosts.getValue(pt));
  }
}

int _getPathCost(KtList<Point> path) => path.sumBy((pt) => map.getValue(pt));

bool _allFinished(KtList<KtList<Point>> paths, Point endPt) => paths.all((path) => _isFinished(path, endPt));

bool _isFinished(KtList<Point> path, Point endPt) => path.last() == endPt;
