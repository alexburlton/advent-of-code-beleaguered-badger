import 'dart:math';

import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

class Point {
  final int x;
  final int y;

  const Point(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Point &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y);

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() {
    return '($x, $y)';
  }
}

class Line {
  final Point start;
  final Point end;

  const Line(this.start, this.end);

  bool isDiagonal() => start.x != end.x && start.y != end.y;

  KtList<Point> getAllPoints() {
    // Vertical line
    if (start.x == end.x) {
        final startY = min(start.y, end.y);
        final endY = max(start.y, end.y);
        final yCoords = makeInclusiveList(startY, endY);
        return yCoords.map((y) => Point(start.x, y));
    }

    final m = (end.y - start.y) ~/ (end.x - start.x);
    final c = start.y - (m * start.x);

    final xCoords = makeInclusiveList(start.x, end.x);

    return xCoords.map((x) => Point(x, (m*x) + c));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Line &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end);

  @override
  int get hashCode => start.hashCode ^ end.hashCode;

  @override
  String toString() {
    return 'Line{ start: $start, end: $end}';
  }
}

void main(List<String> arguments) {
  final input = readStringList('day_5/input.txt');
  final lines = input.map((lineStr) => parseLine(lineStr));
  partA(lines);
  partB(lines);
}

Line parseLine(String lineStr) {
  final points = lineStr.split(" -> ");
  final parsedPoints = listOf(parsePoint(points[0]), parsePoint(points[1])).sortedBy((pt) => pt.x);
  return Line(parsedPoints[0], parsedPoints[1]);
}
Point parsePoint(String pointStr) {
  final xAndY = pointStr.split(",");
  return Point(int.parse(xAndY[0]), int.parse(xAndY[1]));
}

void partA(KtList<Line> lines) {
  final nonDiagonals = lines.filter((line) => !line.isDiagonal());
  final result = findPointsVisitedMoreThanOnce(nonDiagonals);
  print(result);
}

void partB(KtList<Line> lines) {
  final result = findPointsVisitedMoreThanOnce(lines);
  print(result);
}

int findPointsVisitedMoreThanOnce(KtList<Line> lines) {
  final pointsVisitedOnce = mutableSetOf<String>();
  final pointsVisitedMoreThanOnce = mutableSetOf<String>();

  for (var line in lines.iter) {
    final points = line.getAllPoints();
    for (var point in points.iter) {
      final pointStr = point.toString();
      if (pointsVisitedOnce.contains(pointStr)) {
        pointsVisitedMoreThanOnce.add(pointStr);
      }

      pointsVisitedOnce.add(pointStr);
    }
  }

  return pointsVisitedMoreThanOnce.size;
}

