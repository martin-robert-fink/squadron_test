import 'dart:math';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:squadron_test/constants/json_keys.dart';
import 'package:squadron_test/utils/exception/parser_exception.dart';

import './bit.dart';

class SignalValue extends Equatable {
  const SignalValue(
      {this.signalBitValue,
      this.signalDecimalValue,
      required this.interval,
      required this.idCode})
      : assert(
            !(signalBitValue == null && signalDecimalValue == null) &&
                !(signalBitValue != null && signalDecimalValue != null),
            '''Both signalBitValue and signalDecimalValue can't be null 
            and both can't be non-null''');

  final List<Bit>? signalBitValue;
  final int? signalDecimalValue;
  final int interval;
  final String idCode;

  int? get decimalValue {
    if (signalBitValue == null) return signalDecimalValue;
    int _decimalValue = 0;
    for (var exponent = 0; exponent < signalBitValue!.length; exponent++) {
      _decimalValue = _decimalValue +
          ((signalBitValue![exponent].bitType == BitType.low) ? 0 : 1) *
              pow(2, exponent).toInt();
    }
    return _decimalValue;
  }

  @override
  String toString() {
    if (signalDecimalValue != null) return 'R' + signalDecimalValue.toString();
    if (signalBitValue != null) {
      var bitString = '';
      for (var bit in signalBitValue!.reversed) {
        bitString = bitString + bit.toString();
      }
      return 'B' + bitString;
    }
    throw ParserException(Codes.badSignalValue);
  }

  factory SignalValue.fromJson(Map<String, dynamic> json) => SignalValue(
        signalBitValue: (json[JsonKeys.signalBitValue] != null)
            ? List<Bit>.from(
                json[JsonKeys.signalBitValue].map((x) => Bit.fromJson(x)))
            : null,
        signalDecimalValue: json[JsonKeys.signalDecimalValue],
        interval: json[JsonKeys.interval],
        idCode: json[JsonKeys.idCode],
      );

  Map<String, dynamic> toJson() => {
        JsonKeys.signalBitValue: (signalBitValue != null)
            ? List<dynamic>.from(signalBitValue!.map((x) => x.toJson()))
            : null,
        JsonKeys.signalDecimalValue: signalDecimalValue,
        JsonKeys.interval: interval,
        JsonKeys.idCode: idCode,
      };

  String serialize() => jsonEncode(toJson());

  factory SignalValue.deserialize(String jsonString) =>
      SignalValue.fromJson(jsonDecode(jsonString));

  @override
  List<Object?> get props => [
        signalBitValue,
        signalDecimalValue,
        interval,
        idCode,
      ];
}
