import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'package:holy_cross_music/app_state.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  // const _AuthGateState({super.key});
  Future<bool> checkUserStatus(BuildContext context) async {
    var db = FirebaseFirestore.instance;
    bool userAutherised = true;
    String userLevel = 'user';

    if (FirebaseAuth.instance.currentUser == null) {
      return false;
    }

    await db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
          if (!value.exists) {
            userAutherised = false;
          } else {
            final data = value.data() as Map<String, dynamic>;
            if (['admin', 'superadmin'].contains(data['userLevel'])) {
              userLevel = data['userLevel'];
            }
          }
        })
        .onError((e, _) {
          print('Error getting user $e');
        });

    if (!userAutherised) {
      // Potentially do delete user here
      await FirebaseAuth.instance.signOut();
    }

    setState(() {
      context.read<ApplicationState>().userLevel = userLevel;
    });

    return userAutherised;
  }

  // @override
  // void initState() {
  //   checkUserStatus(context);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInWidget();
        } else {
          return FutureBuilder(
            future: checkUserStatus(context),
            builder: (_, data) {
              if (data.hasData) {
                if (!data.data!) {
                  return SignInWidget();
                } else {
                  return const HomeScreen();
                }
              } else {
                return Center(
                  child: Column(
                    spacing: 16.0,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}

class SignInWidget extends StatelessWidget {
  const SignInWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
}
