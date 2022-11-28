import 'package:flutter/cupertino.dart';
import 'package:flutter_multithreading/notifier.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({super.key, required this.result});

  final TestResult result;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Test Type: ' + result.testType.toString().split('.').last,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            'In Isolate: ' +
                result.anotherThreadExecutionTime.inMilliseconds.toString() +
                ' milliseconds',
          ),
          const SizedBox(height: 2),
          Text(
            'In Main thread: ' +
                result.mainThreadExecutionTime.inMilliseconds.toString() +
                ' milliseconds',
          ),
        ],
      );
}
