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
  newMap[8] = hmFishToCount.getOrDefault(0, 0);
  newMap[7] = hmFishToCount.getOrDefault(8, 0);
  newMap[6] = hmFishToCount.getOrDefault(7, 0) + hmFishToCount.getOrDefault(0, 0);
  newMap[5] = hmFishToCount.getOrDefault(6, 0);
  newMap[4] = hmFishToCount.getOrDefault(5, 0);
  newMap[3] = hmFishToCount.getOrDefault(4, 0);
  newMap[2] = hmFishToCount.getOrDefault(3, 0);
  newMap[1] = hmFishToCount.getOrDefault(2, 0);
  newMap[0] = hmFishToCount.getOrDefault(1, 0);
  return newMap.toMap();
}