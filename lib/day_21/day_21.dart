import 'dart:core';
import 'dart:math';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

class Player {
  int score;
  int position; // 0 - 9, for ease of mod arithmetic

  Player(this.score, this.position);

  makeMove(int diceSum) {
    final newPosition = (position + diceSum) % 10;
    final newScore = score + newPosition + 1;

    position = newPosition;
    score = newScore;
  }
}

class DeterministicDice {
  var nextValue = 1;
  var totalRolls = 0;

  int rollThreeTimes() => makeInclusiveList(1, 3).map((_) => rollDie()).sum();

  int rollDie() {
    final returnValue = nextValue;
    totalRolls++;

    nextValue++;
    if (nextValue == 101) {
      nextValue = 1;
    }

    return returnValue;
  }
}

class DiracDiceGameState {
  final Player playerOne;
  final Player playerTwo;
  final DeterministicDice die;
  final int winScore;

  bool playerOneTurn = true;

  DiracDiceGameState(this.winScore, this.die, int playerOneStart, int playerTwoStart):
        playerOne=Player(0, playerOneStart),
        playerTwo=Player(0, playerTwoStart);

  bool _isFinished() => playerOne.score >= winScore || playerTwo.score >= winScore;

  int playGame() {
    while (!_isFinished()) {
      _takeTurn();
    }

    final loserScore = min(playerOne.score, playerTwo.score);
    return loserScore * die.totalRolls;
  }

  void _takeTurn() {
    final player = playerOneTurn ? playerOne : playerTwo;
    final diceSum = die.rollThreeTimes();
    player.makeMove(diceSum);

    playerOneTurn = !playerOneTurn;
  }
}

final input = readStringList('day_21/input.txt');

void main(List<String> arguments) {
  partA();
}

void partA() {
  final gameState = _makeGameState(input);
  print(gameState.playGame());
}

DiracDiceGameState _makeGameState(KtList<String> input) {
  final playerOneStart = int.parse(input[0].split(': ')[1]) - 1;
  final playerTwoStart = int.parse(input[1].split(': ')[1]) - 1;
  return DiracDiceGameState(1000, DeterministicDice(), playerOneStart, playerTwoStart);
}