import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TestType { createNumbersArray, calculateFactorial }

class TestResult {
  final Duration mainThreadExecutionTime;
  final Duration isolateExecutionTime;
  final Duration computeExecutionTime;
  final TestType testType;

  TestResult({
    required this.testType,
    required this.computeExecutionTime,
    required this.mainThreadExecutionTime,
    required this.isolateExecutionTime,
  });
}

class TestsController extends ChangeNotifier {
  TestsController();

  List<TestResult> results = [];
  bool isTestRunning = false;

  Future<void> runTest(TestType testType) async {
    isTestRunning = true;
    notifyListeners();

    late final Future<void> Function(int number) test;
    late final int testNumber;

    switch (testType) {
      case TestType.createNumbersArray:
        test = createNumbersArray;
        testNumber = 10000;
        break;
      case TestType.calculateFactorial:
        test = calculateFactorial;
        testNumber = 50;
        break;
    }

    final isolateExecutionTime = await measureExecutionTime(
      () => workInIsolate(
        (port) async {
          await test(testNumber);
          Isolate.exit(port, 'canceled');
        },
      ),
    );
    final mainThreadExecutionTime = await measureExecutionTime(() async {
      await test(testNumber);
    });
    final computeExecutionTime = await measureExecutionTime(() async {
      await compute<int, void>(test, testNumber);
    });

    isTestRunning = false;
    results.add(
      TestResult(
        computeExecutionTime: computeExecutionTime,
        isolateExecutionTime: isolateExecutionTime,
        mainThreadExecutionTime: mainThreadExecutionTime,
        testType: TestType.createNumbersArray,
      ),
    );
    notifyListeners();
  }
}

final testsControllerProvider =
    ChangeNotifierProvider<TestsController>((ref) => TestsController());

// ========== HELPERS ==========

Future<Duration> measureExecutionTime(
  Future<void> Function() computation,
) async {
  final stopwatch = Stopwatch()..start();
  await computation();
  stopwatch.stop();

  return stopwatch.elapsed;
}

Future<void> workInIsolate(void Function(SendPort) test) async {
  final port = ReceivePort('test');
  await Isolate.spawn(test, port.sendPort);
  await port.first;
}

// ========== TESTS ==========

Future<void> createNumbersArray(int numbersCount) async {
  final arr = <int>[];
  for (var i = 0; i < numbersCount; i++) {
    arr.add(i);
  }
  debugPrint('Array: ' + arr.toString());
}

Future<void> calculateFactorial(int number) async {
  var factorial = BigInt.from(1);
  for (var i = number; i >= 1; i--) {
    factorial *= BigInt.from(i);
  }
  debugPrint('Factorial: ' + factorial.toString());
}
