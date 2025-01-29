import 'package:flutter/material.dart';
import 'package:throw_your_phone/ui/throw/throw_screen_view_model.dart';

class ThrowScreen extends StatelessWidget {
  const ThrowScreen({super.key, required this.viewModel});

  final ThrowScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListenableBuilder(
            listenable: viewModel,
          builder: (context, _) {
            return Column(
              children: [
                if (viewModel.throwEntry != null)
                  Text(viewModel.throwEntry!.distance.toString()),
                TextButton(
                    onPressed: () {
                      viewModel.makeThrow();
                    },
                    child: const Text("Throw")),
              ],
            );
          }),
    );
  }
}
