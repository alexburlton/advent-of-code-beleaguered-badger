import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

void main(List<String> arguments) {
  final input = readStringList('day_10/input.txt');
  partA(input);
  partB(input);
}

final _bracketMap = {
  '(': ')',
  '[': ']',
  '<': '>',
  '{': '}'
}.toImmutableMap();

final _bracketScores = {
  ')': 3,
  ']': 57,
  '}': 1197,
  '>': 25137
}.toImmutableMap();

final _bracketIncompleteScores = {
  ')': 1,
  ']': 2,
  '}': 3,
  '>': 4
}.toImmutableMap();

class LineParseResult {
  final KtList<String> unclosedBrackets;
  final int syntaxErrorScore;
  
  const LineParseResult(this.unclosedBrackets, this.syntaxErrorScore);

  int calculateIncompleteScore() {
    var score = 0;
    final pendingBrackets = unclosedBrackets.reversed().map((openBracket) => _bracketMap.getValue(openBracket));
    for (var bracket in pendingBrackets.iter) {
      score = score * 5;
      score += _bracketIncompleteScores.getValue(bracket);
    }

    return score;
  }
}


void partA(KtList<String> input) {
  final errorSum = input.map(parseBracketLine).sumBy((p0) => p0.syntaxErrorScore);
  print(errorSum);
}

LineParseResult parseBracketLine(String inputLine) {
  final openedBrackets = mutableListOf<String>();

  for (var i=0; i<inputLine.length; i++) {
    final lastOpened = openedBrackets.lastOrNull();
    final expectedClose = lastOpened != null ? _bracketMap[lastOpened] : null;
    final char = inputLine[i];
    if (char == expectedClose) {
      openedBrackets.removeAt(openedBrackets.size - 1);
    } else if (_isOpeningBracket(char)) {
      openedBrackets.add(char);
    } else {
      // Syntax error
      return LineParseResult(openedBrackets.toList(), _bracketScores.getValue(char));
    }
  }

  // No syntax error
  return LineParseResult(openedBrackets.toList(), 0);
}

bool _isOpeningBracket(String char) => _bracketMap.containsKey(char);

void partB(KtList<String> input) {
  final incompleteLines = input.map(parseBracketLine).filter((parseResult) => parseResult.syntaxErrorScore == 0);
  final scores = incompleteLines.map((line) => line.calculateIncompleteScore()).sorted();
  print(scores[scores.size ~/ 2]);
}