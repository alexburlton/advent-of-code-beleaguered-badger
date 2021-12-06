import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

void main(List<String> arguments) {
  final input = readFile('day_6/input.txt');
  final fish = input.split(',').map((numStr) => int.parse(numStr)).toList().toKtList();
  final hmFishStageToCount = fish.groupBy((fish) => fish).mapValues((entry) => entry.value.size);
  partA(hmFishStageToCount);
  partB(hmFishStageToCount);
}

void partA(KtMap<int, int> hmFishToCount) {
  print(_countFishAfterDays(hmFishToCount, 80));
}

void partB(KtMap<int, int> hmFishToCount) {
  print(_countFishAfterDays(hmFishToCount, 256));
}

int _countFishAfterDays(KtMap<int, int> hmFishToCount, int days) {
  var currentFish = hmFishToCount;
  for (var i=0; i<days; i++) {
    currentFish = _doTick(currentFish);
  }

  return currentFish.values.sum();
}

KtMap<int, int> _doTick(KtMap<int, int> hmFishToCount) {
  var newMap = mutableMapFrom<int, int>();
  for (var newStage=0; newStage<=8; newStage++) {
    final prevStage = (newStage + 1) % 9;
    newMap[newStage] = hmFishToCount.getOrDefault(prevStage, 0);
  }

  // Add in new fish
  newMap[6] = newMap.getValue(6) + hmFishToCount.getOrDefault(0, 0);
  return newMap.toMap();
}