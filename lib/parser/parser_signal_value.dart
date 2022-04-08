import 'dart:convert';

import 'package:squadron_test/utils/exception/parser_exception.dart';

import '../model/bit.dart';
import '../model/signal_value.dart';
import '../model/signal.dart';

class ParserSignalValue {
  ParserSignalValue({required this.serializedSignals}) {
    signals = jsonDecode(serializedSignals);
  }

  final String serializedSignals;
  late final List<Signal> signals;
  bool waitingForNextWord = false;
  int? tmpValue;
  List<Bit> tmpBits = [];

  static List<SignalValue> signalValues = [];

  // parse scenarios:
  //  - Starts with x, X, z, Z, 0, or 1
  //   -> parse scalar signalValue (single bit), no space, idCode
  //   -> parse is complete with the single word
  // - Starts with b, B, r, R
  //   -> parse vector signalValue, binary or real, space, idCode
  //   -> Expand (right adjust) bits to fit signalValue length according to spec
  //   -> Parse needs next word (the idCode) to complete the parse
  void call(String word, int interval) {
    if (waitingForNextWord) {
      finishParse(word, interval);
      return;
    }
    var valueType = word[0].toLowerCase();
    if (valueType == 'x' ||
        valueType == 'z' ||
        valueType == '0' ||
        valueType == '1') {
      // Scalar
      signalValues.add(SignalValue(
        signalBitValue: [Bit(bitType: BitTypeString(valueType).fromString)],
        interval: interval,
        idCode: word.substring(1),
      ));
    } else {
      // Vector

      if (valueType != 'b' && valueType != 'r') {
        throw ParserException(Codes.badTimingSignalValue);
      }
      if (valueType == 'b') parseBits(word);
      if (valueType == 'r') parseReal(word);
    }
  }

  void parseReal(String word) {
    if (int.tryParse(word.substring(1)) == null) {
      throw ParserException(Codes.badRealValue);
    }
    tmpValue = int.parse(word.substring(1));
    waitingForNextWord = true;
  }

  void parseBits(String word) {
    var bitList = word.substring(1);
    for (var i = bitList.length; i >= 1; i--) {
      tmpBits.add(Bit(bitType: BitTypeString(bitList[i - 1]).fromString));
    }
    waitingForNextWord = true;
  }

  void finishParse(String word, int interval) {
    var signal = signals.firstWhere((s) => s.idCode == word,
        orElse: () => throw ParserException(Codes.badTiming));
    if (tmpValue != null) {
      // Add a real signalValue to the list
      signalValues.add(SignalValue(
        signalDecimalValue: tmpValue,
        interval: interval,
        idCode: signal.idCode,
      ));
    } else {
      // Add a bitList to the signalValue list
      var expansionBit =
          (tmpBits.last.toString() == '0' || tmpBits.last.toString() == '1')
              ? const Bit(bitType: BitType.low)
              : tmpBits.last;
      if (tmpBits.isNotEmpty) {
        var expansion =
            List<Bit>.filled(signal.size - tmpBits.length, expansionBit);
        tmpBits.addAll(expansion);
        // toList() to avoid pass by reference
        signalValues.add(SignalValue(
          signalBitValue: tmpBits.toList(),
          interval: interval,
          idCode: signal.idCode,
        ));
      }
    }
    tmpBits.clear();
    waitingForNextWord = false;
  }
}
