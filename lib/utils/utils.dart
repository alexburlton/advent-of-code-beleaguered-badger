import 'dart:io';
import 'dart:math';

import 'package:beleaguered_badger/utils/point2d.dart';
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

extension IntKtListUtils on KtList<int> {
  int product() => fold(1, (value, element) => value * element);
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

String _noOp(String original) => original;
KtMap<Point2d, String> readStringGrid(String filename) => parseTextGrid<String>(readStringList(filename), _noOp).mapKeys((entry) => Point2d(entry.key.x.toInt(), entry.key.y.toInt()));

KtMap<Point, int> readIntegerGrid(String filename) => parseIntegerGrid(readStringList(filename));
KtMap<Point, int> parseIntegerGrid(KtList<String> list, [int Function(String) parser=int.parse]) {
  return parseTextGrid<int>(list, parser);
}
KtMap<Point, T> parseTextGrid<T>(KtList<String> list, T Function(String) parser) {
  final rowLength = list[0].length;
  final map = mutableMapFrom<Point, T>();
  for (var x=0; x<rowLength; x++) {
    for (var y=0; y<list.size; y++) {
      final pt = Point(x, y);
      final value = parser(list[y][x]);
      map[pt] = value;
    }
  }

  return map.toMap();
}

extension GridUtils2d<T> on KtMap<Point2d, T> {
  KtList<T> getNeighbourValues(Point2d pt) {
    final neighbourPts = getNeighbourPoints2d(pt);
    return neighbourPts.mapNotNull<T?>((pt) => this[pt]).map((value) => value!);
  }

  num xMin() => keys.map((pt) => pt.x).min()!;
  num xMax() => keys.map((pt) => pt.x).max()!;
  num yMin() => keys.map((pt) => pt.y).min()!;
  num yMax() => keys.map((pt) => pt.y).max()!;

  String getGridString() {
    var str = "";
    final xValues = keys.map((pt) => pt.x);
    final yValues = keys.map((pt) => pt.y);

    for (var y=yValues.min()!; y<=yValues.max()!; y++) {
      if (str.isNotEmpty) {
        str += '\n';
      }

      var line = "";
      for (var x=xValues.min()!; x<=xValues.max()!; x++) {
        line += getValue(Point2d(x, y)).toString();
      }

      str += line;
    }

    return str;
  }
  void printGrid() {
    print(getGridString());
  }
}

extension MoreGridUtils<T> on KtMap<Point, T> {
  KtList<T> getNeighbourValues(Point pt) {
    final neighbourPts = getNeighbourPoints(pt);
    return neighbourPts.mapNotNull<T?>((pt) => this[pt]).map((value) => value!);
  }

  num xMin() => keys.map((pt) => pt.x).min()!;
  num xMax() => keys.map((pt) => pt.x).max()!;
  num yMin() => keys.map((pt) => pt.y).min()!;
  num yMax() => keys.map((pt) => pt.y).max()!;

  String getGridString() {
    var str = "";
    final xValues = keys.map((pt) => pt.x);
    final yValues = keys.map((pt) => pt.y);

    for (var y=yValues.min()!; y<=yValues.max()!; y++) {
      if (str.isNotEmpty) {
        str += '\n';
      }

      var line = "";
      for (var x=xValues.min()!; x<=xValues.max()!; x++) {
        line += getValue(Point(x, y)).toString();
      }

      str += line;
    }

    return str;
  }
  void printGrid() {
    print(getGridString());
  }
}

extension MapUtils<K, V> on KtMutableMap<K, KtList<V>> {
  void putInList(K key, V value) {
    final currentList = getOrDefault(key, emptyList());
    this[key] = currentList + listOf(value);
  }
}

extension CountMapUtils<K, V> on KtMutableMap<K, int> {
  void incrementCountBy(K key, { int amount=1 }) {
    final currentCount = getOrDefault(key, 0);
    this[key] = currentCount + amount;
  }
}

KtList<Point2d> getNeighbourPoints2d(Point2d pt) =>
    [Point2d(pt.x, pt.y-1), Point2d(pt.x, pt.y+1), Point2d(pt.x+1, pt.y), Point2d(pt.x-1, pt.y)].toKtList();

KtList<Point> getNeighbourPoints(Point pt) =>
  [Point(pt.x, pt.y-1), Point(pt.x, pt.y+1), Point(pt.x+1, pt.y), Point(pt.x-1, pt.y)].toKtList();

KtList<Point> getNeighboursPointsWithDiagonals(Point pt) =>
    getNeighbourPoints(pt) + [Point(pt.x+1, pt.y-1), Point(pt.x+1, pt.y+1), Point(pt.x-1, pt.y-1), Point(pt.x-1, pt.y+1)].toKtList();

KtList<Point> getAllNeighboursSorted(Point pt) {
  final neighboursPlusSelf = getNeighboursPointsWithDiagonals(pt) + listOf(pt);
  return neighboursPlusSelf.sortedBy((pt) => (10000 * pt.y) + pt.x);
}

String readFile(String filename) => File('lib/$filename').readAsStringSync();

KtList<int> makeInclusiveList(int min, int max) =>
    List<int>.generate(max - min + 1, (i) => min + i).toKtList();

T? enumFromString<T>(Iterable<T> values, String value) =>
  values.firstWhereOrNull((type) => type.toString().split(".").last == value);

int parseBinaryString(String str) => int.parse(str, radix: 2);