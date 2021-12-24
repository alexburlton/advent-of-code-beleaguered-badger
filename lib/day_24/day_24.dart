import 'dart:core';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

class AluComputer {
  final KtMutableMap<String, int> variables = {
    'w': 0,
    'x': 0,
    'y': 0,
    'z': 0
  }.toImmutableMap().toMutableMap();

  KtList<String> instructions;

  AluComputer(this.instructions);

  void processInstructions(KtList<int> inputs) {
    final mutableInput = inputs.toMutableList();
    for (var instruction in instructions.iter) {
      _processInstruction(instruction, mutableInput);
    }
  }
  void _processInstruction(String instruction, KtMutableList<int> inputs) {
    // Allow for blank lines
    if (instruction.isEmpty) {
      return;
    }

    final instructionParts = instruction.split(' ');
    final cmd = instructionParts[0];
    final variableToAffect = instructionParts[1];
    if (cmd == 'inp') {
      final inputValue = inputs.removeAt(0)!;
      variables[variableToAffect] = inputValue;
    } else {
      final operandRef = instructionParts[2];
      final operand = variables[operandRef] ?? int.parse(operandRef);
      final variableValue = variables.getValue(variableToAffect);

      if (cmd == 'add') {
        variables[variableToAffect] = variableValue + operand;
      } else if (cmd == 'mul') {
        variables[variableToAffect] = variableValue * operand;
      } else if (cmd == 'div') {
        variables[variableToAffect] = variableValue ~/ operand;
      } else if (cmd == 'mod') {
        variables[variableToAffect] = variableValue % operand;
      } else if (cmd == 'eql') {
        final equal = variableValue == operand;
        variables[variableToAffect] = equal ? 1 : 0;
      } else {
        print('ARGH');
      }
    }
  }

  String getResultStr() {
    return "${variables['w']}, ${variables['x']}, ${variables['y']}, ${variables['z']}";
  }
}

void main(List<String> arguments) {
  partA();
  partB();
}

void partA() {
  _verifySolution(29989297949519);
}

void partB() {
  _verifySolution(19518121316118);
}

void _verifySolution(int solution) {
  final digits = solution.toString().split('').map((digitStr) => int.parse(digitStr)).toImmutableList();
  final input = readStringList('day_24/input.txt');
  final computer = AluComputer(input);
  computer.processInstructions(digits);

  if (computer.variables['z'] == 0) {
    print(solution);
  }
}