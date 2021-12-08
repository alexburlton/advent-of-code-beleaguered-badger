import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

class Display {
  final KtList<String> digits;
  final KtList<String> outputs;
  final KtMutableMap<String, KtList<String>> litUpWireToCandidates = _initialiseMappingsMap();
  KtMap<String, String> litUpWireToActual = KtMap.empty();

  Display(String puzzleLine) :
        digits = puzzleLine.split(' | ')[0].split(' ').toKtList(),
        outputs = puzzleLine.split(' | ')[1].split(' ').toKtList();

  int parseOutputs() {
    _solveMappings();
    return int.parse(outputs.map(_parseOutput).joinToString(separator: ""));
  }

  int _parseOutput(String output) {
    final outputWires = output.split("").toKtList().map((wire) => litUpWireToActual.getValue(wire));
    final outputWireStr = outputWires.sorted().joinToString(separator: "");

    if (outputWireStr == "abcefg") {
      return 0;
    } else if (outputWireStr == "cf") {
      return 1;
    } else if (outputWireStr == "acdeg") {
      return 2;
    } else if (outputWireStr == "acdfg") {
      return 3;
    } else if (outputWireStr == "bcdf") {
      return 4;
    } else if (outputWireStr == "abdfg") {
      return 5;
    } else if (outputWireStr == "abdefg") {
      return 6;
    } else if (outputWireStr == "acf") {
      return 7;
    } else if (outputWireStr == "abcdefg") {
      return 8;
    } else if (outputWireStr == "abcdfg") {
      return 9;
    } else {
      print("ARGH");
      return 0;
    }
  }

  void _solveMappings() {
    _updateFromFiveWireDigits();
    _updateFromDigitCounts();
    _dealWithSingletons();
    _dealWithCAndF();

    litUpWireToActual = litUpWireToCandidates.mapValues((entry) => entry.value[0]);
  }

  void _updateFromDigitCounts() {
    digits.forEach((digit) {
      final litUpWires = digit.split("").toKtList();
      final possibles = _getPossibleCharacterMappings(digit);

      litUpWires.forEach((wire) {
        _updatePossibilities(wire, possibles);
      });
    });
  }

  void _updateFromFiveWireDigits() {
    final fiveWireDigits = digits.filter((digit) => _getDigitLength(digit) == 5);

    final allWires = fiveWireDigits.flatMap(_getWires);
    final wiresInThree = allWires.filter((wire) => _countDigitsWithWire(fiveWireDigits, wire) == 3);
    final wiresInTwo = allWires.filter((wire) => _countDigitsWithWire(fiveWireDigits, wire) == 2);
    final wiresInOne = allWires.filter((wire) => _countDigitsWithWire(fiveWireDigits, wire) == 1);

    wiresInThree.forEach((wire) {
      _updatePossibilities(wire, ["a", "d", "g"]);
    });

    wiresInTwo.forEach((wire) {
      _updatePossibilities(wire, ["c", "f"]);
    });

    wiresInOne.forEach((wire) {
      _updatePossibilities(wire, ["e", "b"]);
    });
  }

  void _dealWithSingletons() {
    litUpWireToCandidates.forEach((wire, candidates) {
      if (candidates.size == 1) {
        final certainMapping = candidates[0];
        _removeFromOtherWires(wire, certainMapping);
      }
    });
  }

  void _removeFromOtherWires(String wireToKeep, String candidateToRemove) {
    litUpWireToCandidates.forEach((wire, candidates) {
      if (wire != wireToKeep) {
        litUpWireToCandidates[wire] = candidates.filter((candidate) => candidate != candidateToRemove);
      }
    });
  }

  /// c and f are still not distinguished. C appears in 8 digits, F in 9.
  void _dealWithCAndF() {
    final wires = litUpWireToCandidates.filter((entry) => entry.value == listOf("c", "f"));

    wires.keys.forEach((wire) {
      final count = _countDigitsWithWire(digits, wire);
      if (count == 8) {
        _updatePossibilities(wire, ["c"]);
      } else {
        _updatePossibilities(wire, ["f"]);
      }
    });
  }

  void _updatePossibilities(String wire, Iterable<String> candidates) {
    final currentPossibles = litUpWireToCandidates.getValue(wire);
    litUpWireToCandidates[wire] = currentPossibles.filter((wire) => candidates.contains(wire));
  }
}

KtList<String> _getWires(String digitStr) => digitStr.split("").toKtList().distinct();
int _getDigitLength(String digitStr) => _getWires(digitStr).size;

int _countDigitsWithWire(KtList<String> digits, String wire) => digits.count((digitStr) => digitStr.contains(wire));

List<String> _getPossibleCharacterMappings(String digit) {
  final distinctCount = _getDigitLength(digit);

  if (distinctCount == 2) {
    return ["c", "f"];
  } else if (distinctCount == 4) {
    return ["b", "c", "d", "f"];
  } else if (distinctCount == 3) {
    return ["a", "c", "f"];
  } else {
    return ["a", "b", "c", "d", "e", "f", "g"];
  }
}

KtMutableMap<String, KtList<String>> _initialiseMappingsMap() {
  final possibilities = ["a", "b", "c", "d", "e", "f", "g"];
  final map = mutableMapFrom<String, KtList<String>>();

  for (var wire in possibilities) {
    map[wire] = possibilities.toKtList();
  }

  return map;
}

void main(List<String> arguments) {
  final input = readStringList('day_8/input.txt');
  final displays = input.map((puzzleLine) => Display(puzzleLine));
  partA(displays);
  partB(displays);
}

bool _isUniqueOutput(String outputValue) {
  final distinctCount = _getDigitLength(outputValue);
  return distinctCount == 2  // 1
      || distinctCount == 4 // 4
      || distinctCount == 3 // 7
      || distinctCount == 7; // 8
}

void partA(KtList<Display> displays) {
  final outputs = displays.flatMap((display) => display.outputs);
  final uniqueOutputs = outputs.filter(_isUniqueOutput);
  print(uniqueOutputs.size);
}

void partB(KtList<Display> displays) {
  print(displays.map((display) => display.parseOutputs()).sum());
}
