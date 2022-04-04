// ignore_for_file: avoid_print

// If you modify ANY of the code in this file, and it needs to run on the
// web, then make sure to rerun lib/build_web_worker[_posix | _windows.bat].

import 'package:squadron/squadron.dart';

class SampleService implements WorkerService {
  Future<String> io({required int milliseconds}) async {
    DateTime startTime = DateTime.now();
    await Future.delayed(Duration(milliseconds: milliseconds));
    return 'runTime: ${DateTime.now().difference(startTime)}';
  }

  // print messages show up in the javascript console for the web version
  Future<String> cpu({required int milliseconds}) async {
    final sw = Stopwatch()..start();
    while (sw.elapsedMilliseconds < milliseconds) {
      print('elapsed: ${sw.elapsed}');
    }
    sw.stop();
    return sw.elapsedMilliseconds.toString();
  }

  // command IDs
  static const ioCommand = 1;
  static const cpuCommand = 2;

  // command IDs --> command implementations
  @override
  Map<int, CommandHandler> get operations => {
        ioCommand: (WorkerRequest r) => io(milliseconds: r.args[0]),
        cpuCommand: (WorkerRequest r) => cpu(milliseconds: r.args[0]),
      };
}
