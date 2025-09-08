import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:holy_cross_music/helper/navScroll.dart';
import 'package:holy_cross_music/models/app_user.dart';
import 'package:holy_cross_music/models/catalogue.dart';
import 'package:holy_cross_music/models/month.dart';
import 'package:holy_cross_music/models/service.dart';

class ApplicationState extends ChangeNotifier {
  Color serviceColour;
  ApplicationState(
    this._profilePhotoPath,
    this._themeName,
    this._lightThemeData,
    this._darkThemeData,
  ) : serviceColour = Service.serviceColor(_themeName, Brightness.dark) {
    init();
  }

  late Service currentService;
  List<MonthlyMusic>? serviceList;
  Service? nextService;
  Map<String, List<MonthlyEvents>>? eventList;
  bool initMusicSpinner = true;

  void setCurrentService(Service service) {
    currentService = service;
    notifyListeners();
  }

  // Catalogue

  List<Catalogue>? catalogueList;
  List<Catalogue>? filteredCatalogueList;
  String seasonMenuValue = 'season (all)';
  String partsMenuValue = 'parts (all)';
  int navIndex = 0;
  Map<String, int> navScrollIndexMapping = {};
  var alphabetList = List.generate(
    26,
    (index) => String.fromCharCode(index + 65),
  );
  bool initCatalogueSpinner = true;
  bool catalogueRefreshDisabled = false;

  Future<void> setCatalogueList(List<Catalogue>? catalogue) async {
    catalogueList = catalogue;
    filterCatalogueListNotify();
    print('catalogue set');
    notifyListeners();
  }

  Future<List<Catalogue>?> filterCatalogueList() async {
    var filteredList = catalogueList;
    if (seasonMenuValue.toLowerCase() != 'season (all)') {
      final filteredSeasonCatalogue = filteredList
          ?.where(
            (music) =>
                music.season!.toLowerCase() == seasonMenuValue.toLowerCase(),
          )
          .toList();
      filteredList = filteredSeasonCatalogue;
    }
    if (partsMenuValue.toLowerCase() != 'parts (all)') {
      final filteredPartsCatalogue = filteredList
          ?.where(
            (music) =>
                music.parts.toLowerCase() == partsMenuValue.toLowerCase(),
          )
          .toList();
      filteredList = filteredPartsCatalogue;
    }

    filteredCatalogueList = filteredList;
    if (filteredList != null) {
      setnavScrollIndexMapping(filteredList);
    }
    return filteredCatalogueList;
  }

  void filterCatalogueListNotify() {
    filterCatalogueList();
    notifyListeners();
  }

  void setNavIndex(int index) {
    navIndex = index;
    notifyListeners();
  }

  void setnavScrollIndexMapping(List<Catalogue> catalogueList) {
    navScrollIndexMapping = createIndexes(catalogueList);
    alphabetList = navScrollIndexMapping.keys.toList();
    navIndex = 0;
  }

  void enableCatalogueRefresh() {
    catalogueRefreshDisabled = false;
    notifyListeners();
  }

  void disableCatalogueRefresh() {
    catalogueRefreshDisabled = true;
    notifyListeners();
  }

  // Theme Management

  ThemeData _lightThemeData;
  ThemeData _darkThemeData;
  String _themeName;

  getLightTheme() => _lightThemeData;
  getDarkTheme() => _darkThemeData;
  getThemeName() => _themeName;

  setTheme(
    String themeName,
    ThemeData lightThemeData,
    ThemeData darkThemeData,
  ) async {
    _themeName = themeName;
    _lightThemeData = lightThemeData;
    _darkThemeData = darkThemeData;
    // notifyListeners();
  }

  // User Management

  String? _profilePhotoPath;
  String? get profilePhotoPath => _profilePhotoPath;
  set profilePhotoPath(String? value) {
    _profilePhotoPath = value;
    notifyListeners();
  }

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

  bool _userInitialised = false;
  bool get userInitialised => _userInitialised;
  set userInitialised(bool value) {
    _userInitialised = value;
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
  }

  List<AppUser> _userList = [];
  List<AppUser> get userList => _userList;
  set userList(List<AppUser> value) {
    _userList = value;
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
    String user = 'user';

    await db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
          if (value.exists) {
            final data = value.data() as Map<String, dynamic>;
            if (['admin', 'superadmin'].contains(data['userLevel'])) {
              user = data['userLevel'];
            }
          } else {
            FirebaseAuth.instance.signOut();
          }
        })
        .onError((e, _) {
          print('Error getting user $e');
          FirebaseAuth.instance.signOut();
        });
    userLevel = user;
    notifyListeners();
  }

  Future<void> init() async {
    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        _loggedIn = true;
        await checkUserStatus();
        userInitialised = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }
}
