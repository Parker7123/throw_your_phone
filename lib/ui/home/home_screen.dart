import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:throw_your_phone/ui/throw/throw_screen.dart';

import '../throw/ThrowScreenViewModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Throw your phone"),),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ThrowScreen(
                              viewModel: ThrowScreenViewModel(throwRepository: context.read()),
                            )));
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      minimumSize: const Size(150, 150),
                      textStyle: const TextStyle(fontSize: 20)),
                  child: const Text("New throw")),
            ],
          )
        ],
      ),
    );
  }
}
