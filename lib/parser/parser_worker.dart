// ignore_for_file: avoid_print

// If you modify ANY of the code in this file, and it needs to run on the
// web, then make sure to rerun lib/build_web_worker[_posix | _windows.bat].

import 'package:squadron/squadron.dart';

import './parser_service.dart';

class ParserWorker extends Worker implements ParserService {
  ParserWorker(dynamic entryPoint, {String? id, List args = const []})
      : super(entryPoint, id: id, args: args);

  @override
  Future<String> io({required int milliseconds}) {
    return send(ParserService.ioCommand, [milliseconds]);
  }

  @override
  Future<String> cpu({required int milliseconds}) {
    return send(ParserService.cpuCommand, [milliseconds]);
  }
}
