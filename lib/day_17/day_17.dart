import 'dart:core';
import 'dart:math';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

final inputLine = readStringList('day_17/input.txt')[0];
final targetSet = _parseInput(inputLine);
final bottomRight = targetSet.maxBy((pt) => pt.x - pt.y)!;

class Probe {
  final Point<int> position;
  final Point<int> velocity;

  const Probe(this.velocity, [this.position=const Point(0, 0)]);

  Probe doStep() {
    final newPosition = Point(position.x + velocity.x, position.y + velocity.y);
    final newVelocity = Point(velocity.x - velocity.x.sign, velocity.y - 1);
    return Probe(newVelocity, newPosition);
  }
}

void main(List<String> arguments) {
  final peakY = partA();
  partB(peakY);
}

int partA() {
  var yValue = 1;
  Point<int> lastSuccess = Point(0, 0);
  var nullCount = 0;
  while (nullCount < 100) {
    final result = _testYValue(yValue);
    if (result != null) {
      lastSuccess = result;
      nullCount = 0;
    } else {
      nullCount++;
    }

    yValue++;
  }

  print(getYPeak(lastSuccess));
  return lastSuccess.y;
}

Point<int>? _testYValue(int y) {
  for (var x=1; x<bottomRight.x; x++) {
    if (_hitsTargetArea(Point(x, y))) {
      return Point(x, y);
    }
  }

  return null;
}

int getYPeak(Point<int> startingVelocity) {
  final steps = makeInclusiveList(1, startingVelocity.y);
  final endProbe = steps.fold<Probe>(Probe(startingVelocity), (lastProbe, _) {
    return lastProbe.doStep();
  });

  return endProbe.position.y;
}

bool _hitsTargetArea(Point<int> startingVelocity) {
  var journeyingProbe = Probe(startingVelocity);

  while (journeyingProbe.position.x <= bottomRight.x && journeyingProbe.position.y >= bottomRight.y) {
    journeyingProbe = journeyingProbe.doStep();
    if (targetSet.contains(journeyingProbe.position)) {
      return true;
    }
  }

  return false;
}

void partB(int peakY) {
  final xValues = makeInclusiveList(1, bottomRight.x);
  final yValues = makeInclusiveList(bottomRight.y, peakY);

  final velocitiesToTest = xValues.flatMap((x) => yValues.map((y) => Point<int>(x, y)));
  final successVelocities = velocitiesToTest.filter(_hitsTargetArea);
  print(successVelocities.size);
}

KtSet<Point<int>> _parseInput(String input) {
  final xAndY = input.replaceFirst('target area: ', '').split(', ');
  final xMinAndMax = xAndY[0].substring(2).split('..').map((str) => int.parse(str)).toList();
  final yMinAndMax = xAndY[1].substring(2).split('..').map((str) => int.parse(str)).toList();

  final xValues = makeInclusiveList(xMinAndMax[0], xMinAndMax[1]);
  final yValues = makeInclusiveList(yMinAndMax[0], yMinAndMax[1]);
  return xValues.flatMap((x) => yValues.map((y) => Point(x, y))).toSet();
}