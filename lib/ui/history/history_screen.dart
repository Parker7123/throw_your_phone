import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:throw_your_phone/models/throw_entry.dart';
import 'package:throw_your_phone/ui/history/history_screen_view_model.dart';

enum SortCriteria { distance, height, date }

enum Actions { delete, addToRanking }

class SortWindow extends StatelessWidget {
  const SortWindow(
      {super.key,
      required this.currentSort,
      required this.ascending,
      required this.onSort});

  final SortCriteria currentSort;
  final bool ascending;
  final Function(SortCriteria) onSort;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        padding: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sort by",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.straighten),
                    title: Text('Distance'),
                    onTap: () {
                      onSort(SortCriteria.distance);
                      Navigator.pop(context);
                    },
                    trailing: currentSort == SortCriteria.distance
                        ? (ascending
                            ? const Icon(Icons.arrow_upward_rounded)
                            : const Icon(Icons.arrow_downward_rounded))
                        : null,
                    selected: currentSort == SortCriteria.distance,
                  ),
                  ListTile(
                    leading: Icon(Icons.height),
                    onTap: () {
                      onSort(SortCriteria.height);
                      Navigator.pop(context);
                    },
                    trailing: currentSort == SortCriteria.height
                        ? (ascending
                            ? const Icon(Icons.arrow_upward_rounded)
                            : const Icon(Icons.arrow_downward_rounded))
                        : null,
                    title: Text('Height'),
                    selected: currentSort == SortCriteria.height,
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text('Date'),
                    onTap: () {
                      onSort(SortCriteria.date);
                      Navigator.pop(context);
                    },
                    trailing: currentSort == SortCriteria.date
                        ? (ascending
                            ? const Icon(Icons.arrow_upward_rounded)
                            : const Icon(Icons.arrow_downward_rounded))
                        : null,
                    // Disable until implemented
                    selected: currentSort == SortCriteria.date,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.viewModel});

  final HistoryScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Throw History'),
          actions: [
            IconButton(
                icon: Icon(Icons.sort),
                padding: EdgeInsets.all(20),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SortWindow(
                            currentSort: viewModel.currentSort,
                            ascending: viewModel.ascending,
                            onSort: viewModel.sortBy);
                      });
                })
          ],
        ),
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
                      if (viewModel.throwEntries.isEmpty) {
                        return Center(child: Text("History is empty."));
                      }
                      return HistoryList(
                        throwEntries: viewModel.throwEntries,
                        delete: (entry) {
                          viewModel.delete(entry);
                        },
                        addToGlobalRanking: (entry) {},
                      );
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}

class HistoryList extends StatelessWidget {
  const HistoryList(
      {super.key,
      required this.throwEntries,
      required this.delete,
      required this.addToGlobalRanking});

  final List<ThrowEntry> throwEntries;
  final Function(ThrowEntry) delete;
  final Function(ThrowEntry) addToGlobalRanking;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: throwEntries
          .map((throwEntry) => ListTile(
                trailing: PopupMenuButton<Actions>(
                  onSelected: (Actions action) {
                    switch (action) {
                      case Actions.delete:
                        delete(throwEntry);
                      case Actions.addToRanking:
                        addToGlobalRanking(throwEntry);
                    }
                  },
                  itemBuilder: (context) => <PopupMenuEntry<Actions>>[
                    const PopupMenuItem<Actions>(
                        value: Actions.delete, child: Text("Delete")),
                    const PopupMenuItem<Actions>(
                        value: Actions.addToRanking,
                        child: Text("Add to ranking"))
                  ],
                ),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.height_rounded),
                    Text("${throwEntry.distance.toStringAsFixed(2)} m"),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(Icons.straighten_rounded),
                    const SizedBox(
                      width: 7,
                    ),
                    Text("${throwEntry.height.toStringAsFixed(2)} m"),
                  ],
                ),
                subtitle: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 1.0),
                      child: Icon(
                        Icons.calendar_month_rounded,
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(DateFormat("yyyy/MM/dd HH:mm")
                        .format(throwEntry.dateTime)),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
