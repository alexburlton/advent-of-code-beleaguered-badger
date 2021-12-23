import 'dart:core';
import 'package:beleaguered_badger/utils/point2d.dart';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

final _amphipodCosts = {
  'A': 1,
  'B': 10,
  'C': 100,
  'D': 1000
}.toImmutableMap();

class BurrowState {
  final KtList<Amphipod> amphipods;
  final KtMap<Point2d, String> map;
  final KtList<Room> rooms;
  final int energyExpended;
  final Amphipod? movingAmphipod;

  const BurrowState(this.amphipods, this.map, this.rooms, this.energyExpended, [this.movingAmphipod]);

  BurrowState makeMove(Move move) {
    final movingAmphipod = move.amphipod;
    final otherAmphipods = amphipods.filterNot((amphipod) => amphipod == movingAmphipod);
    final updatedAmphipod = Amphipod(movingAmphipod.type, move.newPosition, movingAmphipod.position);

    final newAmphipods = otherAmphipods + listOf(updatedAmphipod);
    final updatedEnergy = energyExpended + _amphipodCosts.getValue(movingAmphipod.type);

    return BurrowState(newAmphipods, map, rooms, updatedEnergy, updatedAmphipod);
  }

  KtList<Move> getPossibleMoves() {
    // Amphipods will never stop on the space immediately outside any room
    if (rooms.any((room) => movingAmphipod?.position == room.outsideSpace)) {
      return getPossibleMovesForAmphipod(movingAmphipod!);
    }

    final movableAmphipods = amphipods.filterNot(shouldStayStill);
    final amphipodInRangeOfRoom = movableAmphipods.firstOrNull((amphipod) => canReachRoom(amphipod));
    if (amphipodInRangeOfRoom != null) {
      return getPossibleMovesForAmphipod(amphipodInRangeOfRoom);
    }

    return movableAmphipods.flatMap(getPossibleMovesForAmphipod);
  }

  KtList<Move> getPossibleMovesForAmphipod(Amphipod amphipod) {
    // Once an amphipod stops moving in the hallway, it will stay in that spot until it can move into a room
    if (amphipod != movingAmphipod && amphipod.position.y == 1 && !canReachRoom(amphipod)) {
      return emptyList();
    }

    final emptySpaces = getNeighbouringEmptySpaces(amphipod.position);

    // Amphipods will never move from the hallway into a room unless that room is their destination room and that room contains no amphipods which do not also have that room as their own destination
    final allowedSpaces = emptySpaces.filterNot((pt) => amphipod.position.y == 1 && isUnenterableRoom(amphipod, pt));

    // Doesn't make sense for the moving amphipod to go back on itself ever
    final sensibleSpaces = allowedSpaces.filterNot((pt) => amphipod == movingAmphipod && pt == amphipod.prevPosition);
    return sensibleSpaces.map((pt) => Move(amphipod, pt));
  }

  KtList<Point2d> getNeighbouringEmptySpaces(Point2d pt) {
    final neighbours = getNeighbourPoints2d(pt);
    final nonWalls = neighbours.filter((pt) => map[pt] == '.');
    final occupiedSpaces = amphipods.map((amphipod) => amphipod.position);
    return nonWalls.filter((pt) => !occupiedSpaces.contains(pt));
  }

  bool isUnenterableRoom(Amphipod amphipod, Point2d pt) {
    final room = rooms.firstOrNull((room) => room.points.contains(pt));
    if (room == null) {
      return false;
    }

    return !canEnterRoom(amphipod, room);
  }

  bool canEnterRoom(Amphipod amphipod, Room room) {
    final occupants = getOccupants(room);
    return room.type == amphipod.type
        && occupants.none((occupant) => occupant.type != amphipod.type);
  }

  KtList<Amphipod> getOccupants(Room room) {
    return room.points.mapNotNull((pt) => amphipods.firstOrNull((a) => a.position == pt)).map((value) => value!);
  }

  bool canReachRoom(Amphipod amphipod) {
    final desiredRoom = getDesiredRoom(amphipod);
    final reachablePoints = getAllReachablePoints(amphipod);
    // print('Trying to get to $desiredRoom, reachable points apparently $reachablePoints');
    return desiredRoom.points.any((roomPt) => reachablePoints.contains(roomPt)) && canEnterRoom(amphipod, desiredRoom);
  }

  KtList<Point2d> getAllReachablePoints(Amphipod amphipod) {
    var points = getNeighbouringEmptySpaces(amphipod.position);
    if (points.isEmpty()) {
      return emptyList();
    }

    var prevPoints = points;
    points = (points + points.flatMap((pt) => getNeighbouringEmptySpaces(pt))).distinct();
    while (points.size > prevPoints.size) {
      prevPoints = points;
      points = (points + points.flatMap((pt) => getNeighbouringEmptySpaces(pt))).distinct();
    }

    return points;
  }

  bool shouldStayStill(Amphipod amphipod) {
    if (!isInDesiredRoom(amphipod)) {
      return false;
    }

    final room = getDesiredRoom(amphipod);
    final allOccupants = getOccupants(room);

    final otherRoomPoints = room.points - listOf(amphipod.position);
    return otherRoomPoints.none((roomSpace) {
      final occupant = allOccupants.firstOrNull((occupant) => occupant.position == roomSpace);
      return roomSpace.y > amphipod.position.y
          && occupant?.type != amphipod.type;
    });
  }

  bool isCompleted() {
    return amphipods.all(isInDesiredRoom);
  }

  bool isInDesiredRoom(Amphipod amphipod) {
    final desiredRoom = getDesiredRoom(amphipod);
    return desiredRoom.points.contains(amphipod.position);
  }

  Room getDesiredRoom(Amphipod amphipod) {
    return rooms.first((room) => room.type == amphipod.type);
  }

  String hashString() {
    final newMap = map.toMutableMap();
    for (var amphipod in amphipods.iter) {
      newMap[amphipod.position] = amphipod.type;
    }

    return newMap.getGridString();
  }

  void prettyPrint() {
    print('\n');
    print('Energy: $energyExpended');
    print(hashString());
    print('\n');
  }
}

class Amphipod {
  final Point2d position;
  final String type;
  final Point2d? prevPosition;

  const Amphipod(this.type, this.position, this.prevPosition);

  @override
  String toString() => "Amphipod $type: $position";
}

class Move {
  final Amphipod amphipod;
  final Point2d newPosition;

  const Move(this.amphipod, this.newPosition);

  @override
  String toString() => "Move $amphipod to $newPosition";
}

class Room {
  final KtList<Point2d> points;
  final String type;
  final Point2d outsideSpace;

  const Room(this.points, this.type, this.outsideSpace);

  @override
  String toString() => "Room $type: $points, outside space $outsideSpace";
}

BurrowState parseBurrowState(KtMap<Point2d, String> rawInput) {
  final map = rawInput.mapValues((entry) => entry.value == '#' ? '#' : '.');
  final amphipods = _parseAmphipods(rawInput);
  final rooms = _makeRooms(rawInput.yMax() - rawInput.yMin());

  return BurrowState(amphipods, map, rooms, 0, null);
}

KtList<Amphipod> _parseAmphipods(KtMap<Point2d, String> rawInput) {
  final amphipodPoints = rawInput.filterValues((value) => _amphipodCosts.keys.contains(value));
  return amphipodPoints.map((entry) => Amphipod(entry.value, entry.key, null));
}

KtList<Room> _makeRooms(int burrowHeight) {
  final roomA = _parseRoom(0, burrowHeight, "A");
  final roomB = _parseRoom(2, burrowHeight, "B");
  final roomC = _parseRoom(4, burrowHeight, "C");
  final roomD = _parseRoom(6, burrowHeight, "D");

  return listOf(roomA, roomB, roomC, roomD);
}
Room _parseRoom(int offset, int burrowHeight, String type) {
  final yValues = makeInclusiveList(2, burrowHeight-1);
  final points = yValues.map((y) => Point2d(3+offset, y));
  final topPoint = Point2d(3+offset, 1);
  return Room(points, type, topPoint);
}

void main(List<String> arguments) {
  partA();
  partB();
}

final inputFile = 'example_input';
void partA() {
  final memo = mutableMapFrom<String, int>();
  final input = readStringGrid('day_23/$inputFile.txt');
  final burrowState = parseBurrowState(input);
  print(burrowState.rooms);
  _solveBurrowState(burrowState, memo);
}

void partB() {
  final memo = mutableMapFrom<String, int>();
  final input = readStringGrid('day_23/${inputFile}_b.txt');
  final burrowState = parseBurrowState(input);
  print(burrowState.rooms);
  _solveBurrowState(burrowState, memo);
}

void _solveBurrowState(BurrowState burrowState, KtMutableMap<String, int> memoToUse) {
  int currentBest = 0x7fffffffffffffff;
  KtList<BurrowState> states = burrowState.getPossibleMoves().map((move) => burrowState.makeMove(move));

  while (!states.isEmpty()) {
    final finished = states.filter((state) => state.isCompleted());
    if (!finished.isEmpty()) {
      currentBest = finished.minBy((state) => state.energyExpended)!.energyExpended;
      print('Found a solution, new best is $currentBest');
    }

    final pendingStates = states.filter((state) => !state.isCompleted());
    final newStates = pendingStates.flatMap((state) => state.getPossibleMoves().map((move) => state.makeMove(move)));
    states = newStates.filterNot((state) => state.energyExpended > currentBest);
    states = _collapseStates(states, memoToUse);
  }

  print(currentBest);
}

KtList<BurrowState> _collapseStates(KtList<BurrowState> states, KtMutableMap<String, int> memoToUse) {
  final grouped = states.groupBy((state) => state.hashString());
  final bestForSituation = grouped.mapValues((entry) => entry.value.minBy((state) => state.energyExpended)!);
  final filteredBests = bestForSituation.filterNot((entry) => memoToUse[entry.key] != null && memoToUse[entry.key]! < entry.value.energyExpended);
  _updateMemo(filteredBests, memoToUse);

  print('Collapsed ${states.size} to ${filteredBests.size}');
  return filteredBests.values.toList();
}

void _updateMemo(KtMap<String, BurrowState> bestsSoFar, KtMutableMap<String, int> memoToUse) {
  final bestEnergies = bestsSoFar.mapValues((entry) => entry.value.energyExpended);
  memoToUse.putAll(bestEnergies);
}