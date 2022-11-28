import 'package:flutter/material.dart';
import 'package:flutter_multithreading/notifier.dart';
import 'package:flutter_multithreading/test_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestPage extends ConsumerWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tests = ref.watch(testsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      body: tests.isTestRunning
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  TextButton(
                    onPressed: () => tests.runTest(TestType.createNumbersArray),
                    child: const Text('Run Test'),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        TestWidget(result: tests.results[index]),
                    separatorBuilder: (context, index) => const Divider(
                      color: Color.fromARGB(221, 82, 82, 82),
                    ),
                    itemCount: tests.results.length,
                  ),
                ],
              ),
            ),
    );
  }
}
