import 'dart:io';

import 'package:flutter/material.dart';
import 'package:throw_your_phone/ui/throw/throw_instructions_dialog.dart';
import 'package:throw_your_phone/ui/throw/throw_screen_view_model.dart';

class ThrowScreen extends StatefulWidget {
  const ThrowScreen({super.key, required this.viewModel});

  final ThrowScreenViewModel viewModel;

  @override
  State<ThrowScreen> createState() => _ThrowScreenState();
}

class _ThrowScreenState extends State<ThrowScreen> {
  var _buttonColor = Colors.red;

  void processThrowButtonTouch() {
    widget.viewModel.beginThrow();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.viewModel.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Throw your phone"),
      ),
      body: Center(
        child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              return Column(
                children: [
                  if (widget.viewModel.throwState == ThrowState.done ||
                      widget.viewModel.throwState == ThrowState.saved) ...[
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Throw statistics"),
                        Container(height: 2),
                        Container(
                          height: 100,
                          width: 250,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 2.0, color: Colors.black)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  "Height: ${widget.viewModel.throwEntry?.height.toStringAsFixed(2)}m"),
                              Text(
                                  "Total distance: ${widget.viewModel.throwEntry?.distance.toStringAsFixed(2)}m"),
                            ],
                          ),
                        ),
                        Container(height: 50),
                        SizedBox(
                          width: 250,
                          child: Row(
                            mainAxisAlignment:
                                widget.viewModel.throwState == ThrowState.saved
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.spaceBetween,
                            children: [
                              if (widget.viewModel.throwState !=
                                  ThrowState.saved) ...[
                                TextButton.icon(
                                    icon: const Icon(Icons.save),
                                    onPressed: () async {
                                      await widget.viewModel.saveThrow();
                                    },
                                    label: const Text("Save to history")),
                              ],
                              ElevatedButton(
                                  onPressed: () async {
                                    await widget.viewModel.reset();
                                  },
                                  child: const Text("Retry")),
                            ],
                          ),
                        )
                      ],
                    ))
                  ] else if (_buttonColor == Colors.red &&
                      widget.viewModel.throwState == ThrowState.inProgress) ...[
                    const Expanded(
                        child: Center(child: CircularProgressIndicator()))
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                            label: const Text("Instructions"),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (builderContext) =>
                                      const ThrowInstructionsDialog());
                            },
                            icon: const Icon(Icons.info_outline)),
                      ],
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                          child: Listener(
                        onPointerDown: (details) {
                          setState(() {
                            _buttonColor = Colors.green;
                          });
                          if (!Platform.isAndroid) {
                            return;
                          }
                          processThrowButtonTouch();
                        },
                        onPointerUp: (details) {
                          widget.viewModel.setReleaseTimestamp();
                          setState(() {
                            _buttonColor = Colors.red;
                          });
                        },
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _buttonColor,
                          ),
                          child: const Center(child: Text("Hold and throw")),
                        ),
                      )),
                    )
                  ]
                ],
              );
            }),
      ),
    );
  }
}
