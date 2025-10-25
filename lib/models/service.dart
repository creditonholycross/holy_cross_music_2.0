import 'package:holy_cross_music/models/music.dart';
import 'package:flutter/material.dart';
import 'package:holy_cross_music/themes/themes.dart';

enum ServiceTemplate { eucharist, mattins, evensong }

class Service {
  final String date;
  final String time;
  final String? rehearsalTime;
  final String serviceType;
  final List<Music> music;
  final String? organist;
  final String colour;
  final ServiceTemplate? serviceTemplate;

  const Service({
    required this.date,
    required this.time,
    required this.rehearsalTime,
    required this.serviceType,
    required this.music,
    required this.organist,
    required this.colour,
    this.serviceTemplate,
  });

  factory Service.createService(
    String id,
    List<Music> music, [
    ServiceTemplate? serviceTemplate,
  ]) {
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
      serviceTemplate: serviceTemplate,
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

class CreateServiceItem {
  String? date;
  String? time;
  String? rehearsalTime;
  String? serviceType;
  List<Music>? music;
  String? organist;
  String? colour;
  ServiceTemplate serviceTemplate;
  bool editing;

  CreateServiceItem({
    this.date,
    this.time,
    this.rehearsalTime,
    this.serviceType,
    this.music,
    this.organist,
    this.colour,
    required this.serviceTemplate,
    required this.editing,
  });

  factory CreateServiceItem.fromService(
    Service? service,
    ServiceTemplate serviceTemplate,
  ) {
    if (service == null) {
      return CreateServiceItem(serviceTemplate: serviceTemplate, editing: true);
    }

    String dateFormatted =
        '${service.date.substring(6)}/${service.date.substring(4, 6)}/${service.date.substring(0, 4)}';

    String timeFormatted =
        '${service.time.substring(0, 2)}:${service.time.substring(2, 4)}';

    String rehearsalTimeFormatted = '';
    if (service.rehearsalTime != '') {
      rehearsalTimeFormatted =
          '${service.rehearsalTime?.substring(0, 2)}:${service.rehearsalTime?.substring(2, 4)}';
    }

    return CreateServiceItem(
      date: dateFormatted,
      time: timeFormatted,
      rehearsalTime: rehearsalTimeFormatted,
      serviceType: service.serviceType,
      music: service.music,
      organist: service.organist,
      colour: service.colour,
      serviceTemplate: service.serviceTemplate as ServiceTemplate,
      editing: true,
    );
  }
}
