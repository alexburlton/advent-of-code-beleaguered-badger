import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

enum Movement {
  forward,
  up,
  down
}

class Position {
  final int position;
  final int depth;
  final int aim;

  const Position({
    this.position=0,
    this.depth=0,
    this.aim=0,
  });

  Position applyInstructionA(Movement movement, int amount) {
    switch (movement) {
      case Movement.forward:
        return copyWith(position: position + amount);
      case Movement.up:
        return copyWith(depth: depth - amount);
      case Movement.down:
        return copyWith(depth: depth + amount);
    }
  }

  Position applyInstructionB(Movement movement, int amount) {
    switch (movement) {
      case Movement.forward:
        return copyWith(position: position + amount, depth: depth + (aim * amount));
      case Movement.up:
        return copyWith(aim: aim - amount);
      case Movement.down:
        return copyWith(aim: aim + amount);
    }
  }

  int computeFinalResult() => position * depth;

  Position copyWith({
    int? position,
    int? depth,
    int? aim,
  }) {
    return Position(
      position: position ?? this.position,
      depth: depth ?? this.depth,
      aim: aim ?? this.aim,
    );
  }
}

void main(List<String> arguments) {
  final input = readStringList('day_2/input.txt');
  final instructions = input.map((inputLine) => parseInstruction(inputLine));

  partA(instructions);
  partB(instructions);
}

void partA(KtList<KtPair<Movement, int>> input) {
  final position = input.fold<Position>(const Position(), (currentPosition, instruction) {
    return currentPosition.applyInstructionA(instruction.first, instruction.second);
  });

  print(position.computeFinalResult());
}

void partB(KtList<KtPair<Movement, int>> input) {
  final position = input.fold<Position>(const Position(), (currentPosition, instruction) {
    return currentPosition.applyInstructionB(instruction.first, instruction.second);
  });

  print(position.computeFinalResult());
}

KtPair<Movement, int> parseInstruction(String instructionLine) {
  final movementAndAmount = instructionLine.split(" ");
  final movement = enumFromString(Movement.values, movementAndAmount[0]);
  if (movement == null) {
    throw Exception("Couldn't parse movement $movement");
  }

  final amount = int.parse(movementAndAmount[1]);
  return KtPair(movement, amount);
}