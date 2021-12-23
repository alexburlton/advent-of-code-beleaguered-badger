import 'dart:core';
import 'dart:math';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

final input = readStringGrid('day_23/example_input.txt');

final _amphipodCosts = {
  'A': 1,
  'B': 10,
  'C': 100,
  'D': 1000
}.toImmutableMap();

class BurrowState {
  final KtList<Amphipod> amphipods;
  final KtMap<Point, String> map;
  final KtList<Room> rooms;
  final int energyExpended;
  final Amphipod? movingAmphipod;

  const BurrowState(this.amphipods, this.map, this.rooms, this.energyExpended, this.movingAmphipod);

  KtList<Move> getPossibleMoves() {
    return amphipods.flatMap(getPossibleMovesForAmphipod);
  }

  KtList<Move> getPossibleMovesForAmphipod(Amphipod amphipod) {
    final neighbours = getNeighbourPoints(amphipod.position);
    final nonWalls = neighbours.filter((pt) => map[pt] == '.');
    final occupiedSpaces = amphipods.map((amphipod) => amphipod.position);
    final emptySpaces = nonWalls.filter((pt) => !occupiedSpaces.contains(pt));

    // TODO - finish
    return emptyList();
  }

  bool isCompleted() {
    return amphipods.all((amphipod) {
      final desiredRoom = rooms.first((room) => room.type == amphipod.type);
      return desiredRoom.points.contains(amphipod.position);
    });
  }

  void prettyPrint() {
    map.printGrid();
    print(amphipods);
    print(rooms);
  }
}

class Amphipod {
  final Point position;
  final String type;

  const Amphipod(this.position, this.type);

  @override
  String toString() => "Amphipod $type: $position";
}

class Move {
  final Amphipod amphipod;
  final Point newPosition;

  const Move(this.amphipod, this.newPosition);
}

class Room {
  final KtList<Point> points;
  final String type;
  final Point outsideSpace;

  const Room(this.points, this.type, this.outsideSpace);

  @override
  String toString() => "Room $type: $points, outside space $outsideSpace";
}

BurrowState _parseBurrowState(KtMap<Point, String> rawInput) {
  final map = rawInput.mapValues((entry) => entry.value == '#' ? '#' : '.');
  final amphipods = _parseAmphipods(rawInput);
  final rooms = _parseRooms(rawInput);

  return BurrowState(amphipods, map, rooms, 0, null);
}

KtList<Amphipod> _parseAmphipods(KtMap<Point, String> rawInput) {
  final amphipodPoints = rawInput.filterValues((value) => _amphipodCosts.keys.contains(value));
  return amphipodPoints.map((entry) => Amphipod(entry.key, entry.value));
}

KtList<Room> _parseRooms(KtMap<Point, String> rawInput) {
  final amphipodPoints = rawInput.filterValues((value) => _amphipodCosts.keys.contains(value));
  final sortedPoints = amphipodPoints.keys.sortedBy((pt) => pt.x);

  final roomA = _parseRoom(sortedPoints, 0, "A");
  final roomB = _parseRoom(sortedPoints, 2, "B");
  final roomC = _parseRoom(sortedPoints, 4, "C");
  final roomD = _parseRoom(sortedPoints, 6, "D");

  return listOf(roomA, roomB, roomC, roomD);
}
Room _parseRoom(KtList<Point> sortedPoints, int offset, String type) {
  final points = sortedPoints.subList(offset, offset + 2);
  final topPoint = points.minBy((pt) => pt.y)!;
  return Room(points, type, Point(topPoint.x, topPoint.y - 1));
}

void main(List<String> arguments) {
  partA();
  partB();
}

void partA() {
  final burrowState = _parseBurrowState(input);
  burrowState.prettyPrint();
}

void partB() {

}