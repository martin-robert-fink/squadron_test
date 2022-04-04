import 'package:squadron/squadron.dart';

import '../sample_worker.dart';
import '../sample_service.dart';

SampleWorker createVmSampleWorker() => SampleWorker(_main);

// Isolate entry-point.
// It must be a top level function or static method accepting a Map agrument.
// The argument passed to the entry-point must be passed to the run() function.
void _main(Map command) => run((startRequest) => SampleService(), command);
