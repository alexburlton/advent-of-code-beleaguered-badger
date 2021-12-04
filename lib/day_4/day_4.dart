import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

class BingoTile {
  final int number;
  bool checked = false;

  BingoTile(String number): number = int.parse(number);

  void update(int chosenNumber) {
    if (number == chosenNumber) {
      checked = true;
    }
  }
}

class BingoBoard {
  final KtList<KtList<BingoTile>> grid;

  const BingoBoard(this.grid);

  void updateBoard(int chosenNumber) {
    final allTiles = grid.flatten();
    allTiles.forEach((tile) => tile.update(chosenNumber));
  }

  KtList<KtList<BingoTile>> getColumns() => grid.transpose();

  bool isComplete() {
    final completedRow = grid.any((row) => row.all((tile) => tile.checked));
    final completedColumn = getColumns().any((col) => col.all((tile) => tile.checked));

    return completedRow || completedColumn;
  }

  int computeScore(int lastNumber) {
    final allTiles = grid.flatten();
    final unmarkedSum = allTiles.filter((tile) => !tile.checked).sumBy((tile) => tile.number);
    return unmarkedSum * lastNumber;
  }
}

void main(List<String> arguments) {
  final input = readDoubleSpacedList('day_4/input.txt');
  final bingoNumbers = input[0].split(",").map((numStr) => int.parse(numStr));
  final gridStrings = input.subList(1, input.size);
  final grids = gridStrings.map((gridStr) => gridStr.split('\n').toKtList().map((line) => parseGridLine(line)));
  final bingoBoards = grids.map((grid) => BingoBoard(grid));

  partA(bingoNumbers, bingoBoards);
  partB(bingoNumbers, bingoBoards);
}

KtList<BingoTile> parseGridLine(String rawGridLine) {
  final commaSeparated = rawGridLine.trimLeft().replaceAll(RegExp(r'( +)'), ',');
  return commaSeparated.split(',').toKtList().map((number) => BingoTile(number));
}

void partA(Iterable<int> bingoNumbers, KtList<BingoBoard> bingoBoards) {
  final score = getWinningScore(bingoNumbers, bingoBoards);
  print(score);
}

void partB(Iterable<int> bingoNumbers, KtList<BingoBoard> bingoBoards) {
  final score = getLosingScore(bingoNumbers, bingoBoards);
  print(score);
}

int getWinningScore(Iterable<int> bingoNumbers, KtList<BingoBoard> bingoBoards) {
  for (var number in bingoNumbers) {
    bingoBoards.forEach((board) => board.updateBoard(number));

    final finishedBoard = bingoBoards.find((board) => board.isComplete());
    if (finishedBoard != null) {
      return finishedBoard.computeScore(number);
    }
  }

  print('butterfingers');
  return -1;
}

int getLosingScore(Iterable<int> bingoNumbers, KtList<BingoBoard> bingoBoards) {
  final losingBoard = getLosingBoard(bingoNumbers, bingoBoards);
  if (losingBoard == null) {
    print('butterfingers');
    return -1;
  }

  return getWinningScore(bingoNumbers, listOf(losingBoard));
}

BingoBoard? getLosingBoard(Iterable<int> bingoNumbers, KtList<BingoBoard> bingoBoards) {
  for (var number in bingoNumbers) {
    bingoBoards.forEach((board) => board.updateBoard(number));

    final unfinishedBoards = bingoBoards.filter((board) => !board.isComplete());
    if (unfinishedBoards.size == 1) {
      return unfinishedBoards[0];
    }
  }

  return null;
}