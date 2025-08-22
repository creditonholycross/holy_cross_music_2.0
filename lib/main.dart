import 'package:flutter/material.dart';
import 'package:holy_cross_music/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'app_state.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
