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
  T? modalValue() => this.groupBy((item) => item).maxBy((mapEntry) => mapEntry.value.size)?.key;
  T? antiModalValue() => this.groupBy((item) => item).minBy((mapEntry) => mapEntry.value.size)?.key;
}

KtList<int> readIntegerList(String filename) =>
 readStringList(filename).map((line) => int.parse(line)).toList();

KtList<String> readStringList(String filename) {
  final input = File('lib/$filename').readAsStringSync();
  return input.split('\n').toKtList();
}

T? enumFromString<T>(Iterable<T> values, String value) =>
  values.firstWhereOrNull((type) => type.toString().split(".").last == value);