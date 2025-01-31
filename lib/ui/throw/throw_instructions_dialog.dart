import 'package:flutter/material.dart';

class ThrowInstructionsDialog extends StatefulWidget {
  const ThrowInstructionsDialog({super.key});

  @override
  State<ThrowInstructionsDialog> createState() =>
      _ThrowInstructionsDialogState();
}

class _ThrowInstructionsDialogState extends State<ThrowInstructionsDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Instructions'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('1. Hold the phone in your hand'),
          Text('2. Hold \'Throw\' button.'),
          Text('3. Throw the phone releasing \'Throw\' button.'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
