import 'dart:core';
import 'dart:math';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

class ReactorState {
  KtMutableList<Cube> regions = KtMutableList.empty();

  void applyInstruction(Cube region) {
    // Cancel out all existing overlaps to a total volume of 0.
    final cubesToAdd = regions.mapNotNull((existingRegion) => existingRegion.intersect(region)).map((value) => value!);
    regions.addAll(cubesToAdd);

    // Add our full cube if the instruction was "ON"
    if (region.on) {
      regions.add(region);
    }
  }

  int getOnCount() => regions.fold(0, (total, region) => total + region.getSignedVolume());
}


final targetRegion = Cube(false, -50, 50, -50, 50, -50, 50);

class Cube {
  final bool on;
  final int xMin;
  final int xMax;
  final int yMin;
  final int yMax;
  final int zMin;
  final int zMax;

  const Cube(this.on, this.xMin, this.xMax, this.yMin, this.yMax, this.zMin, this.zMax);

  @override
  String toString() {
    return "$xMin<=x<=$xMax  $yMin<=y<=$yMax  $zMin<=z<=$zMax";
  }

  int getSignedVolume() => on ? getVolume() : -getVolume();
  int getVolume() => (xMax-xMin + 1).abs() * (yMax-yMin + 1).abs() * (zMax - zMin + 1).abs();

  bool isSane() => xMin <= xMax && yMin <= yMax && zMin <= zMax;

  Cube? intersect(Cube other) {
    final newRegion = Cube(!on,
        max(xMin, other.xMin), min(xMax, other.xMax),
        max(yMin, other.yMin), min(yMax, other.yMax),
        max(zMin, other.zMin), min(zMax, other.zMax));

    return newRegion.isSane() ? newRegion : null;
  }

  bool withinTargetRegion() => intersect(targetRegion) != null;
}

final input = readStringList('day_22/input.txt').map(parseRegion);

Cube parseRegion(String input) {
  final instructionAndCoords = input.split(' ');
  final on = instructionAndCoords[0] == 'on';

  final coords = instructionAndCoords[1].split(',');
  final xMinAndMax = coords[0].substring(2).split('..').map((str) => int.parse(str)).toList();
  final yMinAndMax = coords[1].substring(2).split('..').map((str) => int.parse(str)).toList();
  final zMinAndMax = coords[2].substring(2).split('..').map((str) => int.parse(str)).toList();

  return Cube(on, xMinAndMax[0], xMinAndMax[1], yMinAndMax[0], yMinAndMax[1], zMinAndMax[0], zMinAndMax[1]);
}

void main(List<String> arguments) {
  partA();
  partB();
}

void partA() {
  final filteredInstructions = input.filter((instruction) => instruction.withinTargetRegion());
  _applyInstructions(filteredInstructions);
}

void partB() {
  _applyInstructions(input);
}

void _applyInstructions(KtList<Cube> instructions) {
  final state = ReactorState();
  instructions.forEach(state.applyInstruction);

  print(state.getOnCount());
}