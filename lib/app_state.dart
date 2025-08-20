import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_firebase_admin/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:holy_cross_music/database/database.dart';
import 'package:holy_cross_music/models/app_user.dart';
import 'package:holy_cross_music/models/month.dart';
import 'package:holy_cross_music/models/service.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  final db = AppDatabase();

  late Service currentService;
  List<MonthlyMusic>? serviceList;
  Service? nextService;
  Map<String, List<MonthlyEvents>>? eventList;
  bool initMusicSpinner = true;

  void setCurrentService(Service service) {
    currentService = service;
    notifyListeners();
  }

  // User Management

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  set loggedIn(bool value) {
    _loggedIn = value;
    notifyListeners();
  }

  String _userLevel = 'user';
  String get userLevel => _userLevel;
  set userLevel(String value) {
    _userLevel = value;
  }

  bool _credsInitialised = false;
  bool get credsInitialised => _credsInitialised;
  set credsInitialised(bool value) {
    _credsInitialised = value;
    notifyListeners();
  }

  bool _initUserSpinner = true;
  bool get initUserSpinner => _initUserSpinner;
  set initUserSpinner(bool value) {
    _initUserSpinner = value;
    // notifyListeners();
  }

  List<AppUser> _userList = [];
  List<AppUser> get userList => _userList;
  set userList(List<AppUser> value) {
    _userList = value;
    // notifyListeners();
  }

  List<String> userEmails() {
    return _userList.map((x) => x.email).toList();
  }

  void addUser(AppUser user) {
    _userList.add(user);
    notifyListeners();
  }

  void removeUser(AppUser user) {
    _userList.remove(user);
    notifyListeners();
  }

  Future<void> checkUserStatus() async {
    var db = FirebaseFirestore.instance;
    String userLevel = 'user';

    await db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
          if (value.exists) {
            final data = value.data() as Map<String, dynamic>;
            if (['admin', 'superadmin'].contains(data['userLevel'])) {
              userLevel = data['userLevel'];
            }
          }
        })
        .onError((e, _) {
          print('Error getting user $e');
        });
    userLevel = userLevel;
    notifyListeners();
  }

  Future<void> init() async {
    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        checkUserStatus();
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }
}
