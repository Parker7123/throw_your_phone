import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:throw_your_phone/data/repositories/throw_ranking_repository.dart';
import 'package:throw_your_phone/models/throw_entry.dart';
import 'package:throw_your_phone/ui/ranking/ranking_screen_view_model.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key, required this.viewModel});

  final RankingScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.loading) {
            const Center(child: CircularProgressIndicator());
          }
          return DefaultTabController(
            length: 3,
            child: Scaffold(
                appBar: AppBar(
                  title: const Text("Global ranking"),
                  bottom: const TabBar(tabs: [
                    Tab(
                        icon: Icon(Icons.leaderboard_outlined),
                        text: "Top All-Time"),
                    Tab(icon: Icon(Icons.calendar_month_outlined), text: "Top Monthly"),
                    Tab(icon: Icon(Icons.watch_later_outlined), text: "Top Today"),
                  ]),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton.icon(
                        iconAlignment: IconAlignment.end,
                          icon: Icon(Icons.arrow_drop_down),
                          onPressed: () {
                            viewModel.reloadRankings(
                                viewModel.sortOption == SortOption.height
                                    ? SortOption.distance
                                    : SortOption.height);
                          },
                          label: Container(
                            width: 120,
                            child: Builder(builder: (context) {
                              if (viewModel.sortOption == SortOption.height) {
                                return const Text("Top by height");
                              } else {
                                return const Text("Top by distance");
                              }
                            }),
                          )),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          RankingList(
                            entries: viewModel.allTimeRanking,
                          ),
                          RankingList(
                            entries: viewModel.todayRanking,
                          ),
                          RankingList(
                            entries: viewModel.monthlyRanking,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          );
        });
  }
}

class RankingList extends StatelessWidget {
  const RankingList({super.key, required this.entries});

  final List<ThrowEntry> entries;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: entries.indexed
          .map((entry) => RankingScreenTile(i: entry.$1, throwEntry: entry.$2))
          .toList(),
    );
  }
}

class RankingScreenTile extends StatelessWidget {
  const RankingScreenTile(
      {super.key, required this.throwEntry, required this.i});

  final int i;
  final ThrowEntry throwEntry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            "$i",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Expanded(
          child: ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.height_rounded),
                Container(width: 100,child: Text("${throwEntry.height.toStringAsFixed(2)} m")),
                const SizedBox(
                  width: 10,
                ),
                const Icon(Icons.straighten_rounded),
                const SizedBox(
                  width: 7,
                ),
                Text("${throwEntry.distance.toStringAsFixed(2)} m"),
              ],
            ),
            subtitle: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 1.0, right: 2.0),
                  child: Icon(
                    Icons.person_outlined,
                  ),
                ),
                Text(throwEntry.username != null
                    ? throwEntry.username!
                    : "Anonymous"),
                // const Padding(
                //   padding: EdgeInsets.only(left: 1.0),
                //   child: Icon(
                //     Icons.calendar_month_outlined,
                //   ),
                // ),
                // const SizedBox(
                //   width: 7,
                // ),
                // Text(DateFormat("yyyy/MM/dd HH:mm").format(throwEntry.dateTime)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
