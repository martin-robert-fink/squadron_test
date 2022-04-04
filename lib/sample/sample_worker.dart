// ignore_for_file: avoid_print

// If you modify ANY of the code in this file, and it needs to run on the
// web, then make sure to rerun lib/build_web_worker[_posix | _windows.bat].

import 'package:squadron/squadron.dart';

import './sample_service.dart';

class SampleWorker extends Worker implements SampleService {
  SampleWorker(dynamic entryPoint, {String? id, List args = const []})
      : super(entryPoint, id: id, args: args);

  @override
  Future<String> io({required int milliseconds}) {
    return send(SampleService.ioCommand, [milliseconds]);
  }

  @override
  Future<String> cpu({required int milliseconds}) {
    return send(SampleService.cpuCommand, [milliseconds]);
  }
}
