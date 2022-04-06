import 'package:squadron/squadron.dart';

import '../parser_service.dart';
import '../parser_worker.dart';

ParserWorker createJsParserWorker() =>
    ParserWorker('/workers/parser_worker.dart.js');

// Web Worker entry-point.
// It must be a parameter-less "main()" function.
void main() => run((_) => ParserService());
