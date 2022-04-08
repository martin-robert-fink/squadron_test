import 'dart:async';
import 'dart:convert';

class Parser {
  Parser({required this.vcdStream, required this.vcdFileSize});

  final Stream<List<int>> vcdStream;
  final int vcdFileSize;
  DateTime? startParse;
  StreamSubscription<String>? parseSub;
  int bytesProcessed = 0;
  bool lineStart = false;
  bool headersDone = false;
  bool headerStart = false;
  List<String> valueChanges = [];

  void parse({Function()? onDone}) {
    startParse = DateTime.now();
    parseSub = vcdStream
        .transform(const Utf8Decoder())
        .transform(const LineSplitter())
        .listen((line) {
      bytesProcessed += line.length + 2; // Add CR/LF to each line
      if (headerStart) {
        if (line.startsWith('\$end')) {
          headerStart = false;
        }
        return;
      }
      if (line.startsWith('\$var') ||
          line.startsWith('\$scope') ||
          line.startsWith('\$upscope') ||
          line.startsWith('\$end') ||
          line.startsWith('\$dump')) {
        return;
      }
      if (line.startsWith('\$date') ||
          line.startsWith('\$version') ||
          line.startsWith('\$timescale')) {
        headerStart = true;
        return;
      }
      _parseLine(line);
    }, onDone: () {
      print('Value Change Lines: ${valueChanges.length}');
    });
  }

  void _parseLine(String line) {
    valueChanges.add(line);
  }
}
