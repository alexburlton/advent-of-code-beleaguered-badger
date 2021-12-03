import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';


void main(List<String> arguments) {
  final input = readStringList('day_3/input.txt');

  partA(input);
  partB(input);
}

void partA(KtList<String> input) {
  final gammaRate = calculateGammaRate(input);
  final epsilonRate = calculateEpsilonRate(input);

  print(gammaRate * epsilonRate);
}

int calculateGammaRate(KtList<String> input) => _calculatePartARating(input, (p0) => p0.modalValues());
int calculateEpsilonRate(KtList<String> input) => _calculatePartARating(input, (p0) => p0.antiModalValues());
int _calculatePartARating(KtList<String> input, KtList<String> Function(KtList<String>) digitPicker) {
  final length = input[0].length;
  var rating = "";
  for (var i=0; i<length; i++) {
    final digits = input.map((str) => str[i]);
    rating += digitPicker(digits)[0];
  }

  return int.parse(rating, radix: 2);
}

void partB(KtList<String> input) {
    final oxygenRating = calculateOxygenGeneratorRating(input);
    final scrubberRating = calculateC02ScrubberRating(input);

    print(oxygenRating * scrubberRating);
}

int calculateOxygenGeneratorRating(KtList<String> input) => _calculatePartBRating(input, (p0) => p0.modalValues(), "1");
int calculateC02ScrubberRating(KtList<String> input) => _calculatePartBRating(input, (p0) => p0.antiModalValues(), "0");
int _calculatePartBRating(KtList<String> input, KtList<String> Function(KtList<String>) digitPicker, String tieBreaker) {
  final length = input[0].length;
  var candidates = input;
  for (var i=0; i<length; i++) {
    final digits = candidates.map((str) => str[i]);
    final chosenDigits = digitPicker(digits);
    final chosenDigit = (chosenDigits.size == 1) ? chosenDigits[0] : tieBreaker;
    candidates = candidates.filter((candidate) => candidate[i] == chosenDigit);

    if (candidates.size == 1) {
      return int.parse(candidates[0], radix: 2);
    }
  }

  return -1;
}