import 'dart:io';

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

String readFile(String filename) => File('lib/$filename').readAsStringSync();

T? enumFromString<T>(Iterable<T> values, String value) =>
  values.firstWhereOrNull((type) => type.toString().split(".").last == value);