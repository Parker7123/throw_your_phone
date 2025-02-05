import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({super.key, required this.logInFunction});

  final Function logInFunction;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Unlock the Leaderboard!"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"))
      ],
      content: SizedBox(
        height: 200,
        width: 200,
        child: Column(
          children: [
            const Text(
                "Log in now to see your global ranking and discover how you stack up against other throwers. Enjoy a competitive edge by viewing the leaderboard and tracking your position over time!"),
            Container(
              height: 40,
            ),
            SignInButton(
              Buttons.Google,
              onPressed: () {
                logInFunction();
              },
            )
          ],
        ),
      ),
    );
  }
}
