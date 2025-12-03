import 'package:flutter/material.dart';

class InternalToolsScreen extends StatelessWidget {
  const InternalToolsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internal Tools Dashboard'),
        elevation: 1,
      ),
      body: const Center(
        child: Text('Internal Tools Screen'),
      ),
    );
  }
}
