import 'package:flutter/material.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(tabs: [
              Tab(icon: Icon(Icons.running_with_errors), text: "Distance"),
              Tab(icon: Icon(Icons.ad_units), text: "Height"),
            ]),
          ),
          body: TabBarView(
            children: [
              ListView(
                children: List.generate(
                    7,
                    (int i) => ListTile(
                          title: Text("Throw #$i"),
                          subtitle: Text("Distance: $i m"),
                        )),
              ),
              ListView(
                children: List.generate(
                    3,
                        (int i) => ListTile(
                      title: Text("Throw #$i"),
                      subtitle: Text("Distance: $i m"),
                    )),
              )
            ],
          )),
    );
  }
}
