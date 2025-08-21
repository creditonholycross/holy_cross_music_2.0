import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:holy_cross_music/screens/auth_gate.dart';
import 'package:holy_cross_music/screens/home.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      appBar: AppBar(title: const Text('User Profile')),
      actions: [
        SignedOutAction((context) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const AuthGate()));
        }),
      ],
      children: [const Divider()],
    );
  }
}
