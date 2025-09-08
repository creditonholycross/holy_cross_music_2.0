import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'package:holy_cross_music/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'app_state.dart';
import 'firebase_options.dart';

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // Initialize FFI
    databaseFactory = databaseFactoryFfiWeb;
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
