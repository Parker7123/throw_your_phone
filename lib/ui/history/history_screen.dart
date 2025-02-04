import 'package:flutter/material.dart';
import 'package:throw_your_phone/models/throw_entry.dart';
import 'package:throw_your_phone/ui/history/history_screen_view_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.viewModel});

  final HistoryScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: viewModel.load,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return ListenableBuilder(
                    listenable: viewModel,
                    builder: (context, _) {
                      return HistoryList(throwEntries: viewModel.verticalThrows);
                    });
              } else {
                return const CircularProgressIndicator();
              }
            }));
  }
}

class HistoryList extends StatelessWidget {
  const HistoryList({super.key, required this.throwEntries});

  final List<ThrowEntry> throwEntries;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(tabs: [
              Tab(icon: Icon(Icons.running_with_errors), text: "Vertical throws"),
              Tab(icon: Icon(Icons.ad_units), text: "Horizontal throws"),
            ]),
          ),
          body: TabBarView(
            children: throwEntries
                .map((throwEntry) => ListTile(
                      title: const Text("Throw #"),
                      subtitle: Text("Distance: ${throwEntry.distance} m"),
                    ))
                .toList(),
          )),
    );
  }
}
