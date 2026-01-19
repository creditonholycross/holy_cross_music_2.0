import 'package:holy_cross_music/models/music.dart';
import 'package:flutter/material.dart';
import 'package:holy_cross_music/themes/themes.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Service {
  final String date;
  final String time;
  final String? rehearsalTime;
  final String serviceType;
  final List<Music> music;
  final String? organist;
  final String colour;

  const Service({
    required this.date,
    required this.time,
    required this.rehearsalTime,
    required this.serviceType,
    required this.music,
    required this.organist,
    required this.colour,
  });

  factory Service.createService(String id, List<Music> music) {
    var idSplit = id.split(',');
    var organists = [];
    var colour = 'base';

    for (var item in music) {
      if (['', null].contains(item.serviceOrganist)) {
        continue;
      }
      if (!organists.contains(item.serviceOrganist)) {
        organists.add(item.serviceOrganist);
      }
    }

    for (var item in music) {
      if (['', null].contains(item.colour)) {
        continue;
      }
      colour = item.colour as String;
    }

    return Service(
      date: idSplit[0],
      time: music[0].time,
      rehearsalTime: music[0].rehearsalTime,
      serviceType: music[0].serviceType,
      music: music,
      organist: organists.join(', '),
      colour: colour,
    );
  }

  static Color serviceColor(
    String theme,
    Brightness brightness, {
    bool isAdmin = false,
  }) {
    if (brightness == Brightness.light) {
      if (isAdmin && GlobalThemeData.themeLightMap[theme] == null && !kIsWeb) {
        Fluttertoast.showToast(
          msg: 'Service colour "$theme" is not a valid theme colour.',
        );
      }
      var themeData =
          GlobalThemeData.themeLightMap[theme] ??
          GlobalThemeData.themeLightMap['red'];
      return themeData!.colorScheme.tertiary;
    } else {
      if (isAdmin && GlobalThemeData.themeDarkMap[theme] == null && !kIsWeb) {
        Fluttertoast.showToast(
          msg: 'Service colour "$theme" is not a valid theme colour.',
        );
      }
      var themeData =
          GlobalThemeData.themeDarkMap[theme] ??
          GlobalThemeData.themeDarkMap['red'];
      return themeData!.colorScheme.tertiary;
    }
  }

  Color servicePrimaryColour(Brightness brightness) {
    if (brightness == Brightness.light) {
      var themeData =
          GlobalThemeData.themeLightMap[colour] ??
          GlobalThemeData.themeLightMap['red'];
      return themeData!.colorScheme.tertiary;
    } else {
      var themeData =
          GlobalThemeData.themeDarkMap[colour] ??
          GlobalThemeData.themeDarkMap['red'];
      return themeData!.colorScheme.tertiary;
    }
  }

  Color serviceOnPrimaryColour(Brightness brightness) {
    if (brightness == Brightness.light) {
      var themeData =
          GlobalThemeData.themeLightMap[colour] ??
          GlobalThemeData.themeLightMap['red'];
      return themeData!.colorScheme.onPrimary;
    } else {
      var themeData =
          GlobalThemeData.themeDarkMap[colour] ??
          GlobalThemeData.themeDarkMap['red'];
      return themeData!.colorScheme.onPrimary;
    }
  }
}
