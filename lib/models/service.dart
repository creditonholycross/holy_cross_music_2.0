import 'package:holy_cross_music/models/music.dart';
import 'package:flutter/material.dart';
import 'package:holy_cross_music/themes/themes.dart';

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

  static Color serviceColor(String theme, Brightness brightness) {
    if (brightness == Brightness.light) {
      return GlobalThemeData.themeLightMap[theme]!.colorScheme.tertiary;
    } else {
      return GlobalThemeData.themeDarkMap[theme]!.colorScheme.tertiary;
    }
  }

  Color servicePrimaryColour(Brightness brightness) {
    if (brightness == Brightness.light) {
      return GlobalThemeData.themeLightMap[colour]!.colorScheme.tertiary;
    } else {
      return GlobalThemeData.themeDarkMap[colour]!.colorScheme.tertiary;
    }
  }

  Color serviceOnPrimaryColour(Brightness brightness) {
    if (brightness == Brightness.light) {
      return GlobalThemeData.themeLightMap[colour]!.colorScheme.onPrimary;
    } else {
      return GlobalThemeData.themeDarkMap[colour]!.colorScheme.onPrimary;
    }
  }
}
