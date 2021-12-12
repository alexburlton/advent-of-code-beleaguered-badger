import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

class CaveNetwork {
  final KtMap<String, KtList<String>> connections;

  const CaveNetwork(this.connections);

  KtList<KtList<String>> findAllPathsFromStart(bool Function(KtList<String>) pathValidator) {
    return findAllPaths("start", listOf(listOf("start")), pathValidator);
  }
  KtList<KtList<String>> findAllPaths(String startingPoint, KtList<KtList<String>> pathsSoFar, bool Function(KtList<String>) pathValidator) {
    final filteredPaths = pathsSoFar.filter(pathValidator);
    final completePaths = filteredPaths.filter(_isCompletePath);
    final incompletePaths = filteredPaths - completePaths;
    if (incompletePaths.isEmpty()) {
      return completePaths;
    }

    final nextSteps = connections.getOrDefault(startingPoint, emptyList());
    final KtList<KtList<String>> newPaths = completePaths + nextSteps.flatMap((cave) => findAllPaths(cave, _addToAllPaths(cave, incompletePaths), pathValidator));
    return newPaths;
  }
}

KtList<KtList<String>> _addToAllPaths(String cave, KtList<KtList<String>> pathsSoFar) =>
  pathsSoFar.map((path) => path + listOf(cave));

bool _isValidPath(KtList<String> path) {
  final minorCaves = path.toSet().filter((cave) => cave.toLowerCase() == cave);
  return minorCaves.all((minorCave) => path.count((cave) => cave == minorCave) <= 1);
}

bool _isValidPathPartB(KtList<String> path) {
  final minorCaves = path.toSet().filter((cave) => cave.toLowerCase() == cave);
  final minorCavesCount = minorCaves.sumBy((minorCave) => path.count((cave) => cave == minorCave));
  return path.count((cave) => cave == "start") == 1
      && path.count((cave) => cave == "end") <= 1
      && minorCavesCount <= minorCaves.size + 1;
}

bool _isCompletePath(KtList<String> path) => path.last() == "end";

void main(List<String> arguments) {
  final input = readStringList('day_12/input.txt');
  final caveNetwork = _parseCaveNetwork(input);
  partA(caveNetwork);
  partB(caveNetwork);
}

CaveNetwork _parseCaveNetwork(KtList<String> input) {
  final map = mutableMapFrom<String, KtList<String>>();
  for (var line in input.iter) {
    final values = line.split("-");
    map.putInList(values[0], values[1]);
    map.putInList(values[1], values[0]);
  }

  return CaveNetwork(map.toMap());
}

void partA(CaveNetwork caveNetwork) {
  print(caveNetwork.findAllPathsFromStart(_isValidPath).size);
}

void partB(CaveNetwork caveNetwork) {
  print(caveNetwork.findAllPathsFromStart(_isValidPathPartB).size);
}