import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:throw_your_phone/data/repositories/throw_repository.dart';
import 'package:throw_your_phone/data/services/throw_service.dart';
import 'package:throw_your_phone/data/services/throw_service_interface.dart';
import 'package:throw_your_phone/ui/history/history_screen.dart';
import 'package:throw_your_phone/ui/history/history_screen_view_model.dart';
import 'package:throw_your_phone/ui/home/home_screen.dart';
import 'package:throw_your_phone/ui/ranking/ranking_screean.dart';

void main() {
  runApp(MultiProvider(providers: [
    Provider(
      create: (context) => InMemoryThrowRepository() as ThrowRepository,
    ),
    Provider(create: (context) => ThrowService() as IThrowService)
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MainScreenController());
  }
}

class MainScreenController extends StatefulWidget {
  const MainScreenController({super.key});

  @override
  State<MainScreenController> createState() => _MainScreenControllerState();
}

class _MainScreenControllerState extends State<MainScreenController> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Ranking'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
      ),
      body: <Widget>[
        const HomeScreen(),
        HistoryScreen(
          viewModel: HistoryScreenViewModel(throwRepository: context.read()),
        ),
        const RankingScreen(),
      ][currentPageIndex],
    );
  }
}
