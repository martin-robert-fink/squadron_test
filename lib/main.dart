// ignore_for_file: avoid_print
import 'package:flutter/foundation.dart';
import 'package:squadron/squadron.dart';
import 'package:flutter/material.dart';

import './parser/browser/parser_worker.dart';
import './parser/vm/parser_worker.dart';

void main() {
  runApp(const SquadronApp());
}

class SquadronApp extends StatelessWidget {
  const SquadronApp({Key? key}) : super(key: key);

  final List<String> words = const ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];

  // void _onTap() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       dialogTitle: 'Select VCD File',
  //       type: FileType.custom,
  //       withData: false,
  //       withReadStream: true,
  //       allowedExtensions: ['vcd', 'VCD'],
  //       allowMultiple: false);
  //   if (result != null &&
  //       result.files.isNotEmpty &&
  //       result.files.first.readStream != null) {
  //     final DateTime startTime = DateTime.now();
  //     final Parser parser = Parser(
  //         vcdStream: result.files.first.readStream!,
  //         vcdFileSize: result.files.first.size);
  //     parser.parse(
  //       onDone: () {
  //         print(DateTime.now().difference(startTime));
  //       },
  //     );
  //   }
  // }

  void _onPressed() async {
    var pool = WorkerPool(
      (kIsWeb) ? createJsParserWorker : createVmParserWorker,
      concurrencySettings: const ConcurrencySettings(
        maxWorkers: 4,
        maxParallel: 2,
      ),
    );
    await pool.start();

    pool.stream((w) => w.streamParser(words)).listen(
      (sv) {
        print('${sv.decimalValue}: ${sv.interval}, ${sv.idCode}');
      },
      onError: (object) => print('Got an error $object'),
      onDone: () => print('I\'m done'),
      cancelOnError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: _onPressed,
                child: const Text('Parse...'),
              ),
            ),
            const Divider(height: 20, thickness: 5),
            Expanded(
              child: ListView(
                controller: ScrollController(),
                children: List.generate(1000, (index) => Text('Item: $index')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
