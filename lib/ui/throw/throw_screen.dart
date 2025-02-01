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
  var buttonColor = Colors.red;

  void processThrowButtonTouch() {
    widget.viewModel.beginVerticalThrow();
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
                  if (widget.viewModel.throwEntry != null) ...[
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Throw statistics"),
                        Container(height: 2),
                        Container(
                          height: 100,
                          width: 200,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 2.0, color: Colors.black)),
                          child: Center(
                            child: Text(
                                "Height: ${widget.viewModel.throwEntry?.height.toStringAsFixed(2)}m"),
                          ),
                        ),
                        Container(height: 50),
                        ElevatedButton(
                            onPressed: () async {
                              await widget.viewModel.reset();
                            },
                            child: const Text("Retry"))
                      ],
                    ))
                  ] else if (buttonColor == Colors.red &&
                      widget.viewModel.throwInProgress) ...[
                    const CircularProgressIndicator()
                  ] else ...[
                    Expanded(
                      flex: 1,
                      child: Center(
                          child: Listener(
                        onPointerDown: (details) {
                          setState(() {
                            buttonColor = Colors.green;
                          });
                          if (!Platform.isAndroid) {
                            return;
                          }
                          processThrowButtonTouch();
                        },
                        onPointerUp: (details) {
                          widget.viewModel.setReleaseTimestamp();
                          setState(() {
                            buttonColor = Colors.red;
                          });
                        },
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: buttonColor,
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
