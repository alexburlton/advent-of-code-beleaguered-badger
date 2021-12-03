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

int calculateGammaRate(KtList<String> input) => _calculatePartARating(input, (p0) => p0.modalValue());
int calculateEpsilonRate(KtList<String> input) => _calculatePartARating(input, (p0) => p0.antiModalValue());
int _calculatePartARating(KtList<String> input, String? Function(KtList<String>) digitPicker) {
  final length = input[0].length;
  var rating = "";
  for (var i=0; i<length; i++) {
    final digits = input.map((str) => str[i]);
    rating += digitPicker(digits)!;
  }

  return int.parse(rating, radix: 2);
}

void partB(KtList<String> input) {
}