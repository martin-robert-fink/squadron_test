// ignore_for_file: avoid_print

// If you modify ANY of the code in this file, and it needs to run on the
// web, then make sure to rerun lib/build_web_worker[_posix | _windows.bat].

import 'dart:async';

import 'package:squadron/squadron.dart';
import '../model/signal_value.dart';

class ParserService implements WorkerService {
  Stream<SignalValue> streamParser(List<dynamic> words) async* {
    int id = 0;
    for (var word in words) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (id == 2) throw 'this is an error';
      yield SignalValue(signalDecimalValue: ++id, interval: id, idCode: word);
    }
  }

  // command IDs
  static const streamCommand = 1;

  // command IDs --> command implementations
  @override
  Map<int, CommandHandler> get operations => {
        streamCommand: (r) =>
            streamParser(r.args[0]).map((sv) => sv.serialize()),
      };
}
