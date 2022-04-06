// ignore_for_file: avoid_print

// If you modify ANY of the code in this file, and it needs to run on the
// web, then make sure to rerun lib/build_web_worker[_posix | _windows.bat].

import 'package:squadron/squadron.dart';

class ParserService implements WorkerService {
  Stream<String> streamParser({required int milliseconds}) async* {
    for (var i = 0; i < milliseconds; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      yield '$i';
    }
  }

  // command IDs
  static const streamCommand = 1;

  // command IDs --> command implementations
  @override
  Map<int, CommandHandler> get operations => {
        streamCommand: (WorkerRequest r) =>
            streamParser(milliseconds: r.args[0]),
      };
}
