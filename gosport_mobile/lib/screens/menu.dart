import 'package:flutter/material.dart';
import 'package:gosport_mobile/widgets/left_drawer.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GoSport')),
      drawer: const LeftDrawer(),
      body: const Center(
        child: Text(
          "Welcome to GoSport!",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
