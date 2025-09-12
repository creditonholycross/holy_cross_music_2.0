<<<<<<< HEAD
import 'package:holy_cross_music/database/database.dart';
=======
>>>>>>> 7d264eb (Adding create users page)
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

  factory Music.fromDb(Map<String, dynamic>? dict) {
    return switch (dict) {
      {
        'id': String id,
        'service_date': int date,
        'service_time': int time,
        'rehearsalTime': int? rehearsalTime,
        'serviceType': String serviceType,
        'musicType': String musicType,
        'title': String title,
        'composer': String? composer,
        'link': String? link,
        'serviceOrganist': String? serviceOrganist,
        'colour': String? colour,
      } =>
        Music(
          date: date.toString(),
          time: time.toString(),
          rehearsalTime: rehearsalTime.toString(),
          serviceType: serviceType,
          musicType: musicType,
          title: title,
          composer: composer,
          link: link,
          serviceOrganist: serviceOrganist,
          colour: colour,
        ),
      {
        'id': String id,
        'service_date': int date,
        'service_time': int time,
        'rehearsalTime': int? rehearsalTime,
        'serviceType': String serviceType,
        'musicType': String musicType,
        'title': int title,
        'composer': String? composer,
        'link': String? link,
        'serviceOrganist': String? serviceOrganist,
        'colour': String? colour,
      } =>
        Music(
          date: date.toString(),
          time: time.toString(),
          rehearsalTime: rehearsalTime.toString(),
          serviceType: serviceType,
          musicType: musicType,
          title: title.toString(),
          composer: composer,
          link: link,
          serviceOrganist: serviceOrganist,
          colour: colour,
        ),
      {
        'id': String id,
        'service_date': int date,
        'service_time': int time,
        'rehearsalTime': String? rehearsalTime,
        'serviceType': String serviceType,
        'musicType': String musicType,
        'title': String title,
        'composer': String? composer,
        'link': String? link,
        'serviceOrganist': String? serviceOrganist,
        'colour': String? colour,
      } =>
        Music(
          date: date.toString(),
          time: time.toString(),
          rehearsalTime: rehearsalTime,
          serviceType: serviceType,
          musicType: musicType,
          title: title.toString(),
          composer: composer,
          link: link,
          serviceOrganist: serviceOrganist,
          colour: colour,
        ),
      {
        'id': String id,
        'service_date': int date,
        'service_time': int time,
        'rehearsalTime': String? rehearsalTime,
        'serviceType': String serviceType,
        'musicType': String musicType,
        'title': int title,
        'composer': String? composer,
        'link': String? link,
        'serviceOrganist': String? serviceOrganist,
        'colour': String? colour,
      } =>
        Music(
          date: date.toString(),
          time: time.toString(),
          rehearsalTime: rehearsalTime,
          serviceType: serviceType,
          musicType: musicType,
          title: title.toString(),
          composer: composer,
          link: link,
          serviceOrganist: serviceOrganist,
          colour: colour,
        ),
      _ => throw const FormatException('Failed to load music from db.'),
    };
  }

  factory Music.fromCreateMusicItem(
    CreateMusicItem createMusicItem,
    String serviceType,
    String serviceTime,
    String serviceDate,
    String rehearsalTime,
    String serviceOrganist,
  ) {
    return Music(
      date: serviceDate,
      time: serviceTime,
      rehearsalTime: rehearsalTime,
      serviceType: serviceType,
      musicType: createMusicItem.musicType,
      title: createMusicItem.title as String,
      composer: createMusicItem.composer,
      link: createMusicItem.link,
      serviceOrganist: serviceOrganist,
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

class CreateMusicItem {
  String? id;
  String musicType;
  String? title;
  String? composer;
  String? link;
  bool editing;

  CreateMusicItem({
    required this.musicType,
    this.title,
    this.composer,
    this.link,
    this.id,
    required this.editing,
  });
}

class HymnItem {
  String? id;
  String musicType = 'Hymn';
  String? number;
  String? title;

  HymnItem({this.title, this.number, this.id});

  factory HymnItem.fromCreateMusicItem(CreateMusicItem createMusicItem) {
    if (createMusicItem.title == null) {
      return HymnItem();
    }

    List<String> titleSplit = createMusicItem.title?.split('#') as List<String>;
    return HymnItem(
      number: titleSplit[0],
      title: titleSplit.length == 2 ? titleSplit[1] : '',
    );
  }
}

class PsalmItem {
  String? id;
  String musicType = 'Psalm';
  String? number;
  String? verses;

  PsalmItem({this.number, this.verses, this.id});

  factory PsalmItem.fromCreateMusicItem(CreateMusicItem createMusicItem) {
    if (createMusicItem.title == null) {
      return PsalmItem();
    }

    List<String> titleSplit =
        createMusicItem.title?.split(' v') as List<String>;
    return PsalmItem(
      number: titleSplit[0],
      verses: titleSplit.length == 2 ? 'v${titleSplit[1]}' : '',
    );
  }
}
