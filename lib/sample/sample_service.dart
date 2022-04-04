// ignore_for_file: avoid_print

import 'package:squadron/squadron.dart';

class SampleService implements WorkerService {
  Future io({required int milliseconds}) =>
      Future.delayed(Duration(milliseconds: milliseconds));

  void cpu({required int milliseconds}) {
    final sw = Stopwatch()..start();
    while (sw.elapsedMilliseconds < milliseconds) {
      print('elapsed: ${sw.elapsed}');
    }
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
