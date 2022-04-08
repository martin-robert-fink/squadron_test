import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:squadron_test/utils/exception/parser_exception.dart';

import '../../constants/json_keys.dart';

enum SignalType {
  event,
  integer,
  parameter,
  real,
  reg,
  supply0,
  supply1,
  time,
  tri,
  triand,
  trior,
  trireg,
  tri0,
  tri1,
  wand,
  wire,
  wor
}

extension SignalTypeString on String {
  SignalType get fromString =>
      SignalType.values.firstWhere((signalType) => signalType.name == this,
          orElse: () => throw ParserException(Codes.invalidSignalType));
}

class Signal extends Equatable {
  const Signal({
    required this.signalType,
    required this.size,
    required this.idCode,
    required this.id,
    this.bitSelectIndex,
    this.msbIndex,
    this.lsbIndex,
    required this.scopeId,
  });
  final SignalType signalType;
  final int size;
  final String idCode;
  final String id;
  final int? bitSelectIndex;
  final int? msbIndex;
  final int? lsbIndex;
  final String? scopeId;

  factory Signal.fromJson(Map<String, dynamic> json) => Signal(
        signalType: (json[JsonKeys.signalType] as String).fromString,
        size: json[JsonKeys.size],
        idCode: json[JsonKeys.idCode],
        id: json[JsonKeys.id],
        bitSelectIndex: json[JsonKeys.bitSelectIndex],
        msbIndex: json[JsonKeys.msbIndex],
        lsbIndex: json[JsonKeys.lsbIndex],
        scopeId: json[JsonKeys.scopeId],
      );

  Map<String, dynamic> toJson() => {
        JsonKeys.signalType: signalType.name,
        JsonKeys.size: size,
        JsonKeys.idCode: idCode,
        JsonKeys.id: id,
        JsonKeys.bitSelectIndex: bitSelectIndex,
        JsonKeys.msbIndex: msbIndex,
        JsonKeys.lsbIndex: lsbIndex,
        JsonKeys.scopeId: scopeId,
      };

  String serialize() => jsonEncode(toJson());

  factory Signal.deserialize(String jsonString) =>
      Signal.fromJson(jsonDecode(jsonString));

  @override
  String toString() {
    String name = id;
    String bits = (size > 1 && msbIndex != null)
        ? ' [' + msbIndex.toString() + ':' + lsbIndex.toString() + ']'
        : '';
    return (name + bits);
  }

  @override
  List<Object?> get props => [
        signalType,
        size,
        idCode,
        id,
        bitSelectIndex,
        msbIndex,
        lsbIndex,
        scopeId
      ];
}
