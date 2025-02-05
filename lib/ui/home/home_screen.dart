import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:throw_your_phone/data/services/google_login_service.dart';
import 'package:throw_your_phone/ui/home/home_screen_view_model.dart';
import 'package:throw_your_phone/ui/login/login_dialog.dart';
import 'package:throw_your_phone/ui/throw/throw_screen.dart';

import '../throw/throw_screen_view_model.dart';

class HomeScreen extends StatelessWidget {
  final HomeScreenViewModel viewModel;

  const HomeScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Throw your phone"),
              bottom: const PreferredSize(preferredSize: Size(100, 20),
              child: Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Logged in as: Filip"),
                  ],
                ),
              ),),
              actions: [
                if (!viewModel.loggedIn) ...[
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (builderContext) =>
                              LoginDialog(
                                logInFunction: () async {
                                  var result = await viewModel.logIn();
                                  if (result != null) {
                                    Navigator.of(context).pop();
                                  }
                                },
                              ));
                    },
                    icon: Icon(Icons.info_outline),
                    label: Text("Log in"),
                  )
                ] else
                  ...[
                    TextButton.icon(
                      onPressed: () {
                        viewModel.logOut();
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text("Log out"),
                    )
                  ]
              ],
            ),
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
                                  builder: (context) =>
                                      ThrowScreen(
                                        viewModel: ThrowScreenViewModel(
                                            throwRepository: context.read(),
                                            throwService: context.read()),
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
        });
  }
}
