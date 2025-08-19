import 'package:drift/drift.dart';
import 'package:holy_cross_music/database/database.dart';
import 'package:intl/intl.dart';

class Music {
  final String? id;
  final String date;
  final String time;
  final String? rehearsalTime;
  final String serviceType;
  final String musicType;
  final String title;
  final String? composer;
  final String? link;
  final String? serviceOrganist;
  final String? colour;

  const Music({
    required this.date,
    required this.time,
    required this.rehearsalTime,
    required this.serviceType,
    required this.musicType,
    required this.title,
    this.composer,
    this.link,
    this.id,
    this.serviceOrganist,
    this.colour,
  });

  factory Music.fromCsv(Map<dynamic, dynamic> csv) {
    return switch (csv) {
      {
        'date': String date,
        'time': String time,
        'rehearsal': String? rehearsalTime,
        'service': String serviceType,
        'type': String musicType,
        'title': String title,
        'composer': String? composer,
        'link': String? link,
        'organist': String? serviceOrganist,
        'colour': String? colour,
      } =>
        Music(
          date: date.replaceAll('-', ''),
          time: time.replaceAll(':', ''),
          rehearsalTime: rehearsalTime?.replaceAll(':', ''),
          serviceType: serviceType,
          musicType: musicType,
          title: title,
          composer: composer,
          link: link,
          serviceOrganist: serviceOrganist,
          colour: colour,
        ),
      _ => throw const FormatException('Failed to load music from csv.'),
    };
  }

  factory Music.fromDb(MusicItem dict) {
    return Music(
      date: dict.date,
      time: dict.time,
      rehearsalTime: dict.rehearsalTime,
      serviceType: dict.serviceType,
      musicType: dict.musicType,
      title: dict.title,
      composer: dict.composer,
      link: dict.link,
      serviceOrganist: dict.serviceOrganist,
      colour: dict.colour,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': '$date$serviceType$musicType$title',
      'service_date': date,
      'service_time': time,
      'rehearsalTime': rehearsalTime,
      'serviceType': serviceType,
      'musicType': musicType,
      'title': title,
      'composer': composer,
      'link': link,
      'serviceOrganist': serviceOrganist,
      'colour': colour,
    };
  }

  MusicItemsCompanion toCompanion() {
    return MusicItemsCompanion(
      date: Value(date),
      time: Value(time),
      rehearsalTime: Value.absentIfNull(rehearsalTime),
      serviceType: Value(serviceType),
      musicType: Value(musicType),
      title: Value(title),
      composer: Value.absentIfNull(composer),
      link: Value.absentIfNull(link),
      serviceOrganist: Value.absentIfNull(serviceOrganist),
      colour: Value.absentIfNull(colour),
    );
  }

  static String parseDate(String date) {
    final DateFormat dateFormatter = DateFormat('EEEE d MMMM');
    if (date.length != 8) date = '0$date';
    return dateFormatter.format(DateTime.parse(date));
  }

  static String formatTime(String? time) {
    if (time == null) {
      return 'N/A';
    } else if (time == '') {
      return 'N/A';
    } else if (double.tryParse(time) == null) {
      return time;
    }
    var paddedTime = time.padLeft(6, '0');
    return '${paddedTime.substring(0, 2)}:${paddedTime.substring(2, 4)}';
  }
}
