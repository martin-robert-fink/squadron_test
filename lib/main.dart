import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:squadron/squadron.dart';

import 'parser/browser/parser_worker.dart';
import 'parser/vm/parser_worker.dart';

void main() {
  runApp(const SquadronApp());
}

class SquadronApp extends StatelessWidget {
  const SquadronApp({Key? key}) : super(key: key);

  void _onPressed() async {
    var pool = WorkerPool(
      (kIsWeb) ? createJsParserWorker : createVmParserWorker,
      concurrencySettings: const ConcurrencySettings(
        maxWorkers: 4,
        maxParallel: 2,
      ),
    );
    await pool.start();

    var n = 42;
    var cpuResult = await pool.execute((w) => w.cpu(milliseconds: n));
    var ioResult = await pool.execute((w) => w.io(milliseconds: n));

    // ignore: avoid_print
    print('cpuResult: $cpuResult, ioResult: $ioResult');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: ElevatedButton(
          onPressed: _onPressed,
          child: const Text('Run...'),
        )),
      ),
    );
  }
}
