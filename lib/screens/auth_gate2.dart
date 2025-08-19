import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("User is currently signed out!");
      } else {
        print("User is signed in!");
        // Update the UI or redirect as needed
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            showAuthActionSwitch: false,
            providers: [EmailAuthProvider()],
            // headerBuilder: (context, constraints, shrinkOffset) {
            //   return Padding(
            //     padding: const EdgeInsets.all(20),
            //     child: AspectRatio(
            //       aspectRatio: 1,
            //       child: Image.asset('assets/crediton_boniface_community.png'),
            //     ),
            //   );
            // },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: const Text(
                  'Welcome to the Holy Cross Music app, please sign in!',
                ),
              );
            },
            // sideBuilder: (context, shrinkOffset) {
            //   return Padding(
            //     padding: const EdgeInsets.all(20),
            //     child: AspectRatio(
            //       aspectRatio: 1,
            //       child: Image.asset('assets/crediton_boniface_community.png'),
            //     ),
            //   );
            // },
          );
        }

        return const HomeScreen();
      },
    );
  }
}
