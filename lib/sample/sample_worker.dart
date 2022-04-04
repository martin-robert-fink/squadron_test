// ignore_for_file: avoid_print

import 'package:squadron/squadron.dart';

import './sample_service.dart';

class SampleWorker extends Worker implements SampleService {
  SampleWorker(dynamic entryPoint, {String? id, List args = const []})
      : super(entryPoint, id: id, args: args);

  @override
  Future io({required int milliseconds}) {
    print('io: $milliseconds');
    return send(SampleService.ioCommand, [milliseconds]);
  }

  @override
  Future cpu({required int milliseconds}) {
    print('cpu: $milliseconds');
    return send(SampleService.cpuCommand, [milliseconds]);
  }
}
