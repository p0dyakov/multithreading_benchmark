import 'package:flutter/material.dart';
import 'package:flutter_multithreading/test_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Multithreading',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TestPage(),
      );
}
