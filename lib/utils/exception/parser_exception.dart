enum Codes {
  invalidBitType,
  badSignalValue,
  invalidSignalType,
  badTimingSignalValue,
  badRealValue,
  badTiming,
}

const Map<Codes, String> exceptionCodes = {
  Codes.invalidBitType: 'Invalid bit type',
  Codes.badSignalValue: 'Bad Signal Value',
  Codes.invalidSignalType: 'Invalid Signal Type',
  Codes.badTimingSignalValue: 'Bad Timing Signal Value',
  Codes.badRealValue: 'Bad Real Value',
  Codes.badTiming: 'Bad Timing',
};

class ParserException implements Exception {
  ParserException([this.code]);

  final Codes? code;

  @override
  String toString() {
    if (code == null) return 'Unknown Parser Exception';
    return 'Parser Exception: ${exceptionCodes[code]}';
  }
}
