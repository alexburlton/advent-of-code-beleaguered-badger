import 'dart:core';
import 'package:beleaguered_badger/utils/utils.dart';
import 'package:kt_dart/kt.dart';

abstract class Packet {
  final int version;
  final int id;

  Packet(this.version, this.id);

  int getVersionSum();
  int getValue();
}

class LiteralPacket extends Packet {
  final int value;

  LiteralPacket(int version, int id, String groupString):
      value = _parseBinaryString(groupString), super(version, id);

  @override
  int getVersionSum() => version;

  @override
  int getValue() => value;

  @override
  String toString() {
    return 'Literal Packet: $value';
  }
}

class OperatorPacket extends Packet {
  final KtList<Packet> subPackets;

  OperatorPacket(int version, int id, this.subPackets): super(version, id);

  @override
  int getVersionSum() => subPackets.sumBy((packet) => packet.getVersionSum()) + version;

  @override
  int getValue() {
    final subPacketValues = subPackets.map((packet) => packet.getValue());
    if (id == 0) {
      return subPacketValues.sum();
    } else if (id == 1) {
      return subPacketValues.product();
    } else if (id == 2) {
      return subPacketValues.min()!;
    } else if (id == 3) {
      return subPacketValues.max()!;
    } else if (id == 5) {
      return subPacketValues[0] > subPacketValues[1] ? 1 : 0;
    } else if (id == 6) {
      return subPacketValues[0] < subPacketValues[1] ? 1 : 0;
    } else if (id == 7) {
      return subPacketValues[0] == subPacketValues[1] ? 1 : 0;
    }

    throw Exception('Unhandled id $id');
  }

  @override
  String toString() {
    return '$subPackets';
  }
}

final packet = _parseInput();

void main(List<String> arguments) {
  partA();
  partB();
}

void partA() {
  print(packet.getVersionSum());
}

void partB() {
  print(packet.getValue());
}

Packet _parseInput() {
  final inputLine = readStringList('day_16/input.txt')[0];
  final parsedBinaryString = inputLine.split('').map(_parseHexString).join();
  final packetAndRemaining = _parsePacket(parsedBinaryString);
  return packetAndRemaining.first;
}

KtPair<Packet, String> _parsePacket(String str) {
  final version = _parseVersion(str);
  final id = _parseId(str);
  if (id == 4) {
    final groupStr = str.substring(6);
    final groups = groupStr.split('').toKtList().chunked(5).map((list) => list.joinToString(separator: ''));

    var keepReading = true;
    var groupsRead = 0;
    final groupString = groups.fold<String>('', (strSoFar, newGroup) {
      if (keepReading) {
        groupsRead++;
      }

      final leadDigit = newGroup[0];
      final newDigits = newGroup.substring(1);

      final value = keepReading ? strSoFar + newDigits : strSoFar;
      keepReading = keepReading && leadDigit == '1';
      return value;
    });

    final fullPacketString = str.substring(0, 6 + (groupsRead * 5));
    return KtPair(LiteralPacket(version, id, groupString), str.replaceFirst(fullPacketString, ''));
  } else {
    final lengthType = str[6];
    final lengthBits = lengthType == '0' ? str.substring(7, 22) : str.substring(7, 18);
    final lengthInt = _parseBinaryString(lengthBits);

    final packetSoFar = str.substring(0, 6) + lengthType + lengthBits;
    var remainingString = str.replaceFirst(packetSoFar, '');

    final packetList = mutableListFrom<Packet>();
    if (lengthType == '0') {
      var amountParsed = 0;
      while (amountParsed < lengthInt) {
        final result = _parsePacket(remainingString);
        packetList.add(result.first);

        amountParsed += (remainingString.replaceFirst(result.second, '').length);
        remainingString = result.second;
      }

      return KtPair(OperatorPacket(version, id, packetList.toList()), remainingString);
    } else {
      for (var i=0; i<lengthInt; i++) {
        final result = _parsePacket(remainingString);
        packetList.add(result.first);
        remainingString = result.second;
      }

      return KtPair(OperatorPacket(version, id, packetList.toList()), remainingString);
    }
  }
}

int _parseVersion(String str) => _parseBinaryString(str.substring(0, 3));
int _parseId(String str) => _parseBinaryString(str.substring(3, 6));
int _parseBinaryString(String str) => int.parse(str, radix: 2);
String _parseHexString(String str) => int.parse(str, radix: 16).toRadixString(2).padLeft(4, '0');