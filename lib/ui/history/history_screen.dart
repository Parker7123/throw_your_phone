import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: List.generate(7, (int i) => ListTile(
        title: Text("Throw #$i"),
        subtitle: Text("Distance: $i m"),
      )),
    ));
  }
}
