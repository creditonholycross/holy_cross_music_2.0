import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/Auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:holy_cross_music/app_state.dart';
import 'package:holy_cross_music/models/app_user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string_generator/random_string_generator.dart';

import 'package:holy_cross_music/service_account.dart';
import 'package:provider/provider.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/creds.json');
  }

  Future<File> writeCreds() async {
    final file = await _localFile;
    return file.writeAsString(json.encode(creds));
  }

  Future<void> loadUsers(BuildContext context) async {
    List<AppUser> usersList = [];

    var db = FirebaseFirestore.instance;
    await db.collection('users').get().then((snapshot) {
      for (var doc in snapshot.docs) {
        var userData = doc.data();
        usersList.add(
          AppUser(
            uid: doc.id,
            email: userData['email'],
            userLevel: userData['userLevel'],
          ),
        );
      }
    });

    setState(() {
      context.read<ApplicationState>().userList = usersList;
      context.read<ApplicationState>().initUserSpinner = false;
    });
  }

  Future<void> createUser(BuildContext context, String userEmail) async {
    if (context.read<ApplicationState>().credsInitialised == false) {
      await writeCreds();
      setState(() {
        context.read<ApplicationState>().credsInitialised = true;
      });
    }

    final admin = FirebaseAdminApp.initializeApp(
      'crediton-holy-cross-music',
      Credential.fromServiceAccount(await _localFile),
    );

    final auth = Auth(admin);

    var passwordGenerator = RandomStringGenerator(fixedLength: 10);

    CreateRequest user = CreateRequest(
      email: userEmail,
      emailVerified: false,
      password: passwordGenerator.generate(),
      displayName: userEmail.split('@').first,
    );

    UserRecord newUser = await auth.createUser(user);
    await admin.close();

    final newUserInfo = <String, String>{
      'email': userEmail,
      'userLevel': 'user',
    };

    var db = FirebaseFirestore.instance;
    db
        .collection('users')
        .doc(newUser.uid)
        .set(newUserInfo)
        .onError((e, _) => print("Error writing document: $e"));

    setState(() {
      context.read<ApplicationState>().addUser(
        AppUser(
          uid: newUser.uid,
          email: newUser.email as String,
          userLevel: 'user',
        ),
      );
    });
  }

  Future<void> deleteUser(BuildContext context, AppUser user) async {
    if (context.read<ApplicationState>().credsInitialised == false) {
      await writeCreds();
      setState(() {
        context.read<ApplicationState>().credsInitialised = true;
      });
    }

    final admin = FirebaseAdminApp.initializeApp(
      'crediton-holy-cross-music',
      Credential.fromServiceAccount(await _localFile),
    );

    final auth = Auth(admin);

    await auth.deleteUser(user.uid);
    await admin.close();

    setState(() {
      context.read<ApplicationState>().removeUser(user);
    });
  }

  @override
  void initState() {
    loadUsers(context);

    // FirebaseFirestore.instance.collection('user').get().then((snapshot) {
    //   for (var user in snapshot.docs) {
    //     users.add({'user_id': user.id, 'data': user.data()});
    //     print(user.data());
    //   }
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    final _formKey = GlobalKey<FormState>();
    String userEmail = '';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Add new user',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),

                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email address.';
                        }
                        if (!EmailValidator.validate(value)) {
                          return 'Please enter a valid email address.';
                        }
                        if (appState.userEmails().contains(value)) {
                          return 'Email address already registered.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        userEmail = value!;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            createUser(context, userEmail);
                            _formKey.currentState!.reset();
                          }
                        },
                        style: ButtonStyle(
                          shadowColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16.0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Current users', style: TextStyle(fontSize: 20)),
              ),
            ),
            if (!appState.initUserSpinner)
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: appState.userList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(appState.userList[index].email),
                    trailing: appState.userList[index].userLevel != 'superadmin'
                        ? IconButton(
                            // todo: add promote to admin button
                            onPressed: () {
                              final snackBar = SnackBar(
                                content: Text(
                                  'Are you sure you want to delete user ${appState.userList[index].email}?',
                                ),
                                action: SnackBarAction(
                                  label: 'Yes',
                                  onPressed: () async {
                                    await deleteUser(
                                      context,
                                      appState.userList[index],
                                    );
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(snackBar);
                            },
                            icon: Icon(Icons.delete),
                          )
                        : null,
                  );
                },
              )
            else
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
