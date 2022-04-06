import 'package:squadron/squadron.dart';

import '../parser_worker.dart';
import '../parser_service.dart';

ParserWorker createVmParserWorker() => ParserWorker(_main);

// Isolate entry-point.
// It must be a top level function or static method accepting a Map agrument.
// The argument passed to the entry-point must be passed to the run() function.
void _main(Map command) => run((_) => ParserService(), command);
