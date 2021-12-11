import 'dart:math';

import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

void main(List<String> arguments) {
  final input = readIntegerGrid('day_11/input.txt');
  input.printGrid();
  partA(input);
  partB(input);
}

void partA(KtMap<Point, int> input) {
  final mutableInput = input.toMutableMap();
  var totalFlashes = 0;
  for (var i=0; i<100; i++) {
    final flashes = doTick(mutableInput);
    totalFlashes += flashes;
  }

  print(totalFlashes);
}

void partB(KtMap<Point, int> input) {
  final mutableInput = input.toMutableMap();
  var steps = 0;
  while (mutableInput.values.any((value) => value > 0)) {
    doTick(mutableInput);
    steps++;
  }

  print(steps);
}

int doTick(KtMutableMap<Point, int> grid) {
  var flashedPoints = setOf<Point>();
  incrementValues(grid.keys.iter, grid);
  var pointsToFlash = grid.filter((entry) => entry.value > 9).keys - flashedPoints;
  while (pointsToFlash.isNotEmpty()) {
    flashPoints(pointsToFlash, grid);
    flashedPoints += pointsToFlash;
    pointsToFlash = grid.filter((entry) => entry.value > 9).keys - flashedPoints;
  }

  resetEnergyToZero(grid);
  return flashedPoints.size;
}

void flashPoints(KtSet<Point> points, KtMutableMap<Point, int> grid) {
  final allNeighbours = points.flatMap(getNeighboursPointsWithDiagonals);
  incrementValues(allNeighbours.iter, grid);
}

void incrementValues(Iterable<Point> points, KtMutableMap<Point, int> grid) {
  points.forEach((pt) {
    final value = grid[pt];
    if (value != null) {
      grid[pt] = value + 1;
    }
  });
}

void resetEnergyToZero(KtMutableMap<Point, int> grid) {
  grid.keys.forEach((pt) {
    final value = grid[pt];
    if (value != null && value > 9) {
      grid[pt] = 0;
    }
  });
}