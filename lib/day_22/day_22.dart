import 'dart:core';
import 'package:beleaguered_badger/utils/point3d.dart';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

class ReactorState {
  KtMap<Point3d, bool> cubeStates;

  ReactorState(this.cubeStates);

  void applyInstruction(ReactorInstruction instruction) {
    print('Processing $instruction');
    final pointsToApply = instruction.getPoints().filter(_withinTargetRegion).toSet();
    print('Filtered to ${pointsToApply.size} points');
    cubeStates = cubeStates.mapValues((entry) {
      if (pointsToApply.contains(entry.key)) {
        return instruction.on;
      }

      return entry.value;
    });


    print('Mapped values');
  }

  int getOnCount() => cubeStates.values.count((value) => value);
}

class ReactorInstruction {
  final bool on;

  final int xMin;
  final int xMax;
  final int yMin;
  final int yMax;
  final int zMin;
  final int zMax;

  const ReactorInstruction(this.on, this.xMin, this.xMax, this.yMin, this.yMax, this.zMin, this.zMax);

  KtSet<Point3d> getPoints() {
    final xValues = makeInclusiveList(xMin, xMax);
    final yValues = makeInclusiveList(yMin, yMax);
    final zValues = makeInclusiveList(zMin, zMax);

    return xValues.flatMap((x) => yValues.flatMap((y) => zValues.map((z) => Point3d(x, y, z)))).toSet();
  }

  @override
  String toString() {
    return "$xMin<=x<=$xMax  $yMin<=y<=$yMax  $zMin<=z<=$zMax";
  }

  bool withinTargetRegion() {
    return xMin <= 50 && xMax >= -50 && yMin <= 50 && yMax >= -50 && zMin <= 50 && zMax >= -50;
  }
}

final input = readStringList('day_22/input.txt').map(_parseInput);

ReactorInstruction _parseInput(String input) {
  final instructionAndCoords = input.split(' ');
  final on = instructionAndCoords[0] == 'on';

  final coords = instructionAndCoords[1].split(',');
  final xMinAndMax = coords[0].substring(2).split('..').map((str) => int.parse(str)).toList();
  final yMinAndMax = coords[1].substring(2).split('..').map((str) => int.parse(str)).toList();
  final zMinAndMax = coords[2].substring(2).split('..').map((str) => int.parse(str)).toList();

  return ReactorInstruction(on, xMinAndMax[0], xMinAndMax[1], yMinAndMax[0], yMinAndMax[1], zMinAndMax[0], zMinAndMax[1]);
}

bool _withinTargetRegion(Point3d point) {
  return point.x <= 50 && point.x >= -50 && point.y <= 50 && point.y >= -50 && point.z <= 50 && point.z >= -50;
}

void main(List<String> arguments) {
  print('parsed input');
  partA();
  partB();
}

void partA() {
  final filteredInstructions = input.filter((instruction) => instruction.withinTargetRegion());
  final allPoints = filteredInstructions.flatMap((instruction) => instruction.getPoints()).distinct();
  final pointMap = allPoints.associateWith((p0) => false);
  print(pointMap.size);
  final state = ReactorState(pointMap);

  for (var instruction in filteredInstructions.iter) {
    state.applyInstruction(instruction);
  }

  print(state.getOnCount());
}

void partB() {
}