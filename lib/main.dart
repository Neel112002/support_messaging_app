import 'package:flutter/material.dart';
import 'package:support_messaging_app/root_scaffold.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Support Messaging App',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const RootScaffold(),
      debugShowCheckedModeBanner: false,
    );
  }
}
