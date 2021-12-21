import 'dart:core';
import 'dart:math';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

class Player {
  int score;
  int position; // 0 - 9, for ease of mod arithmetic

  Player(this.score, this.position);

  Player makeMove(int diceSum) {
    final newPosition = (position + diceSum) % 10;
    final newScore = score + newPosition + 1;

    return Player(newScore, newPosition);
  }
}

class RollResult {
  final int totalScore;
  final int totalPermutations;

  const RollResult(this.totalScore, this.totalPermutations);
}

abstract class Dice {
  KtList<RollResult> rollThreeTimes();
}

class DeterministicDice extends Dice {
  var nextValue = 1;
  var totalRolls = 0;

  @override
  KtList<RollResult> rollThreeTimes() {
    final result = makeInclusiveList(1, 3).map((_) => _rollDie()).sum();
    return listOf(RollResult(result, 1));
  }

  int _rollDie() {
    final returnValue = nextValue;
    totalRolls++;

    nextValue++;
    if (nextValue == 101) {
      nextValue = 1;
    }

    return returnValue;
  }
}

class DiracDice extends Dice {

  /// 3: 1 universe (1,1,1)
  /// 4: 3 universes (2,1,1 | 1,2,1 | 1,1,2)
  /// 5: 6 universes (3,1,1 | 1,3,1 | 1,1,3 | 1,2,2 | 2,1,2 | 2,2,1)
  /// 6: 7 universes (1,2,3 | 1,3,2 | 2,1,3 | 2,3,1 | 3,1,2 | 3,2,1 | 2,2,2)
  /// 7: 6 universes (3,3,1 | 3,1,3 | 1,3,3 | 2,2,3 | 2,3,2 | 3,2,2)
  /// 8: 3 universes (3,3,2 | 3,2,3 | 2,3,3)
  /// 9: 1 universe (3,3,3)
  @override
  KtList<RollResult> rollThreeTimes() {
    return listOf(RollResult(3, 1), RollResult(4, 3), RollResult(5, 6), RollResult(6, 7), RollResult(7, 6), RollResult(8, 3), RollResult(9, 1));
  }
}

class DiracDiceGameState {
  final int winThreshold;
  final Player playerOne;
  final Player playerTwo;
  final Dice die;
  final int universes;
  final bool playerOneTurn;

  DiracDiceGameState(
      this.winThreshold,
      this.die,
      this.playerOne,
      this.playerTwo,
      {this.universes=1, this.playerOneTurn=true});

  bool isFinished() => playerOne.score >= winThreshold || playerTwo.score >= winThreshold;
  bool playerOneWon() => playerOne.score >= winThreshold;

  KtList<DiracDiceGameState> takeTurn() {
    if (isFinished()) {
      return listOf(this);
    }

    final player = playerOneTurn ? playerOne : playerTwo;
    final diceSums = die.rollThreeTimes();
    final newStates = diceSums.map((diceResult) {
      final newPlayer = player.makeMove(diceResult.totalScore);
      final newPlayerOne = playerOneTurn ? newPlayer : playerOne;
      final newPlayerTwo = !playerOneTurn ? newPlayer : playerTwo;

      return DiracDiceGameState(winThreshold, die, newPlayerOne, newPlayerTwo,
          universes: universes * diceResult.totalPermutations,
          playerOneTurn: !playerOneTurn);
    });

    return newStates;
  }
}

final input = readStringList('day_21/input.txt');

void main(List<String> arguments) {
  partA();
  partB();
}

void partA() {
  final die = DeterministicDice();
  final gameState = _makeGameState(input, 1000, die);
  var gameStates = listOf(gameState);

  while (!_allGamesFinished(gameStates)) {
    gameStates = gameStates.flatMap((game) => game.takeTurn());
  }

  final resultingGame = gameStates[0];
  final loserScore = min(resultingGame.playerOne.score, resultingGame.playerTwo.score);
  final result = loserScore * die.totalRolls;
  print(result);
}

void partB() {
  final die = DiracDice();
  final gameState = _makeGameState(input, 21, die);
  var pendingGameStates = listOf(gameState);

  var playerOneWins = 0;
  var playerTwoWins = 0;

  while (!pendingGameStates.isEmpty()) {
    final nextGames = pendingGameStates.flatMap((game) => game.takeTurn());
    final finishedGames = nextGames.filter((game) => game.isFinished());

    for (var game in finishedGames.iter) {
      if (game.playerOneWon()) {
        playerOneWins += game.universes;
      } else {
        playerTwoWins += game.universes;
      }
    }

    pendingGameStates = nextGames.filter((game) => !game.isFinished());
    print('Finished ${finishedGames.size} this loop, now got ${pendingGameStates.size} pending');
  }

  print(max(playerOneWins, playerTwoWins));
}

bool _allGamesFinished(KtList<DiracDiceGameState> games) => games.all((game) => game.isFinished());

DiracDiceGameState _makeGameState(KtList<String> input, int winThreshold, Dice die) {
  final playerOneStart = int.parse(input[0].split(': ')[1]) - 1;
  final playerTwoStart = int.parse(input[1].split(': ')[1]) - 1;
  return DiracDiceGameState(winThreshold, die, Player(0, playerOneStart), Player(0, playerTwoStart));
}