import 'package:equatable/equatable.dart';

import '../constants/json_keys.dart';
import '../utils/exception/parser_exception.dart';

enum BitType { low, high, x, z }

extension BitTypeString on String {
  BitType get fromString {
    if (this == '0') return BitType.low;
    if (this == '1') return BitType.high;
    if (toLowerCase() == 'x') return BitType.x;
    if (toLowerCase() == 'z') return BitType.z;
    throw ParserException(Codes.invalidBitType);
  }
}

class Bit extends Equatable {
  const Bit({required this.bitType});

  final BitType bitType;

  factory Bit.fromJson(Map<String, dynamic> json) =>
      Bit(bitType: (json[JsonKeys.bitType] as String).fromString);

  Map<String, dynamic> toJson() => {JsonKeys.bitType: bitType.name};

  @override
  List<Object?> get props => [bitType];
}
