import 'package:squadron/squadron.dart';

import '../sample_service.dart';
import '../sample_worker.dart';

SampleWorker createJsSampleWorker() => SampleWorker('sample_worker.dart.js');

// Web Worker entry-point.
// It must be a parameter-less "main()" function.
void main() => run((startRequest) => SampleService());
