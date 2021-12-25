import 'dart:core';
import 'package:beleaguered_badger/utils/point2d.dart';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

final map = readStringGrid('day_25/input.txt');
final eastFacing = map.filterValues((value) => value == '>').keys.toMutableSet();
final southFacing = map.filterValues((value) => value == 'v').keys.toMutableSet();

final gridWidth = map.xMax() + 1;
final gridHeight = map.yMax() + 1;

void main(List<String> arguments) {
  partA();
}

void partA() {
  var turns = 1;
  var oldMapStr = _getStateString();
  _doTick();
  var newMapStr = _getStateString();
  while (newMapStr != oldMapStr) {
    turns++;
    oldMapStr = newMapStr;
    _doTick();
    newMapStr = _getStateString();

    if (turns % 100 == 0) {
      print(turns);
    }
  }

  map.printGrid();
  print(turns);
}

String _getStateString() {
  return eastFacing.getGridString() + southFacing.getGridString();
}

_doTick() {
  final pointsToMoveEast = eastFacing.filter((pt) {
    final newPt = Point2d((pt.x + 1) % gridWidth, pt.y);
    return !eastFacing.contains(newPt) && !southFacing.contains(newPt);
  });

  eastFacing.removeAll(pointsToMoveEast);

  final newEastPts = pointsToMoveEast.map((pt) => Point2d((pt.x + 1) % gridWidth, pt.y));
  eastFacing.addAll(newEastPts);
  //print('moved east');

  final pointsToMoveSouth = southFacing.filter((pt) {
    final newPt = Point2d(pt.x, (pt.y+1) % gridHeight);
    return !eastFacing.contains(newPt) && !southFacing.contains(newPt);
  });

  southFacing.removeAll(pointsToMoveSouth);

  final newSouthPts = pointsToMoveSouth.map((pt) => Point2d(pt.x, (pt.y+1) % gridHeight));
  southFacing.addAll(newSouthPts);

  //print('moved south');
}