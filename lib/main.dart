import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'package:holy_cross_music/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'app_state.dart';
import 'firebase_options.dart';


@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
  send?.send([id, status, progress]);
}

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // Initialize FFI
    databaseFactory = databaseFactoryFfiWeb;
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(
  providerAndroid: kDebugMode ? AndroidDebugProvider() : AndroidPlayIntegrityProvider(),
  providerWeb: kDebugMode ? WebDebugProvider() : ReCaptchaV3Provider('6LdQ2cksAAAAAO7uBa3Y44YkD2TzWrqgNS2N71Yn')
);

  await FlutterDownloader.initialize(
    debug: kDebugMode, // set to false in production
    ignoreSsl: true 
  );

  SharedPreferences.getInstance().then((prefs) {
    var themeName = prefs.getString('themeName') ?? 'base';
    var profilePhotoPath = prefs.getString('profilePhotoPath');
    runApp(
      ChangeNotifierProvider(
        create: (context) => ApplicationState(
          profilePhotoPath,
          themeName,
          GlobalThemeData.themeLightMap[themeName] as ThemeData,
          GlobalThemeData.themeDarkMap[themeName] as ThemeData,
        ),
        builder: ((context, child) => const MyApp()),
      ),
    );
  });
}
