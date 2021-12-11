import 'dart:io';
import 'dart:math';

import 'package:kt_dart/kt.dart';
import 'package:collection/collection.dart';

extension IntListUtils on List<num> {
  num sum() => reduce((value, element) => value + element);
  num product() => fold(1, (value, element) => value * element);
}

extension ListUtils<T> on List<T> {
  KtList<T> toKtList() {
    return KtList.from(this);
  }
}

extension KtListUtils<T> on KtList<T> {
  KtList<T> modalValues() {
    final map = this.groupBy((item) => item);
    final targetCount = map.maxBy((mapEntry) => mapEntry.value.size)?.value.size;
    if (targetCount == null) {
      return emptyList();
    }

    return map.filter((entry) => entry.value.size == targetCount).map((entry) => entry.key);
  }

  KtList<T> antiModalValues() {
    final map = this.groupBy((item) => item);
    final targetCount = map.minBy((mapEntry) => mapEntry.value.size)?.value.size;
    if (targetCount == null) {
      return emptyList();
    }

    return map.filter((entry) => entry.value.size == targetCount).map((entry) => entry.key);
  }
}

extension GridUtils<T> on KtList<KtList<T>> {
  KtList<KtList<T>> transpose() {
    final rowList = List<int>.generate(size, (i) => i).toKtList();
    final columnList = List<int>.generate(this[0].size, (i) => i).toKtList();

    return columnList.map((colIndex) {
        return rowList.map((rowIndex) {
          return this[rowIndex][colIndex];
      });
    });
  }
}

KtList<int> readIntegerList(String filename) =>
 readStringList(filename).map((line) => int.parse(line)).toList();

KtList<String> readStringList(String filename) {
  final input = readFile(filename);
  return input.split('\n').toKtList();
}

KtList<String> readDoubleSpacedList(String filename) {
  final input = readFile(filename);
  return input.split('\n\n').toKtList();
}

KtMap<Point, int> readIntegerGrid(String filename) {
  final list = readStringList(filename);
  final rowLength = list[0].length;
  final map = mutableMapFrom<Point, int>();
  for (var x=0; x<rowLength; x++) {
    for (var y=0; y<list.size; y++) {
      final pt = Point(x, y);
      final value = int.parse(list[y][x]);
      map[pt] = value;
    }
  }

  return map.toMap();
}

extension MoreGridUtils<T> on KtMap<Point, T> {
  KtList<T> getNeighbourValues(Point pt) {
    final neighbourPts = getNeighbourPoints(pt);
    return neighbourPts.mapNotNull<T?>((pt) => this[pt]).map((value) => value!);
  }

  void printGrid() {
    final xValues = keys.map((pt) => pt.x);
    final yValues = keys.map((pt) => pt.y);

    for (var y=yValues.min()!; y<=yValues.max()!; y++) {
      var line = "";
      for (var x=xValues.min()!; x<=xValues.max()!; x++) {
        line += getValue(Point(x, y)).toString();
      }

      print(line);
    }
  }
}

KtList<Point> getNeighbourPoints(Point pt) =>
  [Point(pt.x, pt.y-1), Point(pt.x, pt.y+1), Point(pt.x+1, pt.y), Point(pt.x-1, pt.y)].toKtList();

KtList<Point> getNeighboursPointsWithDiagonals(Point pt) =>
    getNeighbourPoints(pt) + [Point(pt.x+1, pt.y-1), Point(pt.x+1, pt.y+1), Point(pt.x-1, pt.y-1), Point(pt.x-1, pt.y+1)].toKtList();

String readFile(String filename) => File('lib/$filename').readAsStringSync();

KtList<int> makeInclusiveList(int min, int max) =>
    List<int>.generate(max - min + 1, (i) => min + i).toKtList();

T? enumFromString<T>(Iterable<T> values, String value) =>
  values.firstWhereOrNull((type) => type.toString().split(".").last == value);