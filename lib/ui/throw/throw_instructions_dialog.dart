import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ThrowInstructionsDialog extends StatefulWidget {
  const ThrowInstructionsDialog({super.key});

  @override
  State<ThrowInstructionsDialog> createState() =>
      _ThrowInstructionsDialogState();
}

class _ThrowInstructionsDialogState extends State<ThrowInstructionsDialog> {
  var tutorialPage = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Builder(
        builder: (context) {
          switch (tutorialPage) {
            case 0:
              return const Text('Height');
            case 1:
              return const Text('Distance');
            case 2:
              return const Text('Throwing');
            default:
              return const Text('Instructions');
          }
        },
      ),
      content: SizedBox(
        height: 250,
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tutorialPage == 0) ...[
              const Text('App will measure height of your throw.'),
              SvgPicture.asset(
                height: 210,
                'assets/vertical-throw-instruction.svg',
                semanticsLabel: 'Vertical throw',
              )
            ] else if (tutorialPage == 1) ...[
              const Text('App will also measure total distance of your throw.'),
              SvgPicture.asset(
                height: 210,
                'assets/horizontal-throw-instruction.svg',
                semanticsLabel: 'Vertical throw',
              )
            ] else if (tutorialPage == 2) ...[
              const Text('Hold \'Throw\' button.'),
              const Text('It will change it\'s color to green.'),
              Container(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: const Center(child: Text("Hold and throw")),
                  ),
                  const Icon(Icons.navigate_next_rounded),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: const Center(child: Text("Hold and throw")),
                  )
                ],
              )
            ] else if (tutorialPage == 4) ...[
              const Text('Throw the phone releasing \'Throw\' button.'),
            ],
          ],
        ),
      ),
      actions: [
        if (tutorialPage > 0) ...[
          TextButton(
            key: const ValueKey('prev_button'),
            onPressed: () => setState(() {
              tutorialPage -= 1;
            }),
            child: const Text('Prev'),
          ),
        ],
        if (tutorialPage == 2) ...[
          TextButton(
            key: const ValueKey('ok_button'),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ok'),
          ),
        ] else ...[
          TextButton(
            key: const ValueKey('next_button'),
            onPressed: () => setState(() {
              tutorialPage += 1;
            }),
            child: const Text('Next'),
          ),
        ]
      ],
    );
  }
}
