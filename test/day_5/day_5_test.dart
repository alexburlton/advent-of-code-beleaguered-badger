import 'dart:math';

import 'package:beleaguered_badger/day_5/day_5.dart';
import 'package:kt_dart/kt.dart';
import 'package:test/test.dart';

void main() {
  test('parsing lines', () {
    expect(parseLine("0,9 -> 5,9"), equals(Line(Point(0, 9), Point(5, 9))));
    expect(parseLine("5,9 -> 0,9"), equals(Line(Point(0, 9), Point(5, 9))));
  });

  test('all points on a horizontal line', () {
    final line = Line(Point(0, 9), Point(3, 9));
    expect(line.getAllPoints(), equals(listOf(Point(0, 9), Point(1, 9), Point(2, 9), Point(3, 9))));
  });

  test('all points on a negative vertical line', () {
    final line = Line(Point(0, 9), Point(0, 6));
    expect(line.getAllPoints(), equals(listOf(Point(0, 6), Point(0, 7), Point(0, 8), Point(0, 9))));
  });

  test('all points on a positive vertical line', () {
    final line = Line(Point(0, 6), Point(0, 9));
    expect(line.getAllPoints(), equals(listOf(Point(0, 6), Point(0, 7), Point(0, 8), Point(0, 9))));
  });

  test('all points on a diagonal line', () {
    final line = Line(Point(5, 5), Point(8, 2));
    expect(line.getAllPoints(), equals(listOf(Point(5, 5), Point(6, 4), Point(7, 3), Point(8, 2))));
  });
}