import 'package:flutter/material.dart';
import 'package:holy_cross_music/app_state.dart';
import 'package:holy_cross_music/screens/request_delete_user.dart';
import 'package:provider/provider.dart';

import 'screens/auth_gate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<ApplicationState>();
    return MaterialApp(
      theme: appState.getLightTheme(),
      darkTheme: appState.getDarkTheme(),
      home: AuthGate(),
      routes: {'/delete-account': (context) => RequestDeleteUserScreen()},
    );
  }
}
