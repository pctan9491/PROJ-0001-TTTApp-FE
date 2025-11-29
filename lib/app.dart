import 'package:flutter/material.dart';

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo Target App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 66, 132, 100)),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Architecture Ready! Implement Features in lib/features'),
        ),
      ),
    );
  }
}