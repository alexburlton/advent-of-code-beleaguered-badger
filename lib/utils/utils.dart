import 'dart:io';

extension ListUtils on List<num> {
  num sum() => reduce((value, element) => value + element);
  num product() => fold(1, (value, element) => value * element);
}

List<int> readIntegerList(String filename) =>
 readStringList(filename).map((line) => int.parse(line)).toList();

List<String> readStringList(String filename) {
  final input = File('lib/$filename').readAsStringSync();
  return input.split('\n').toList();
}