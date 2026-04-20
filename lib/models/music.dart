import 'package:holy_cross_music/database/database.dart';
import 'package:holy_cross_music/models/fundraisingEvent.dart';
import 'package:holy_cross_music/screens/home.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

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
  final String? conductor;
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
    this.conductor,
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
        'conductor': String? conductor,
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
          conductor: conductor,
          serviceOrganist: serviceOrganist,
          colour: colour?.toLowerCase(),
        ),
      {
        'date': String date,
        'time': String time,
        'rehearsal': String? rehearsalTime,
        'service': String serviceType,
        'type': String musicType,
        'title': String title,
        'composer': String? composer,
        'link': String? link,
        'conductor': String? conductor,
        'organist': String? serviceOrganist,
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
          conductor: conductor,
          serviceOrganist: serviceOrganist,
          colour: null,
        ),
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
          conductor: null,
          serviceOrganist: serviceOrganist,
          colour: null,
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
        'conductor': String? conductor,
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
          conductor: conductor,
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
        'conductor': String? conductor,
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
          conductor: conductor,
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
        'conductor': String? conductor,
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
          conductor: conductor,
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
        'conductor': String? conductor,
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
          conductor: conductor,
          serviceOrganist: serviceOrganist,
          colour: colour,
        ),
      _ => throw const FormatException('Failed to load music from db.'),
    };
  }

  Map<String, Object?> toMap() {
    if (date == '') {
      throw AdminException(
        'Date is missing for $serviceType $musicType $title',
      );
    } else if (time == '') {
      throw AdminException(
        'Time is missing for $serviceType $musicType $title',
      );
    } else if (serviceType == '') {
      throw AdminException(
        'Service name is missing for $date $musicType $title',
      );
    }
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
      'conductor': conductor,
      'serviceOrganist': serviceOrganist,
      'colour': colour,
    };
  }

  Map<String, Object?> toIdMap() {
    if (date == '') {
      throw AdminException(
        'Date is missing for $serviceType $musicType $title',
      );
    } else if (time == '') {
      throw AdminException(
        'Time is missing for $serviceType $musicType $title',
      );
    } else if (serviceType == '') {
      throw AdminException(
        'Service name is missing for $date $musicType $title',
      );
    }
    var uuid = Uuid();
    return {
      'id': uuid.v4(),
      'service_date': date,
      'service_time': time,
      'rehearsalTime': rehearsalTime,
      'serviceType': serviceType,
      'musicType': musicType,
      'title': title,
      'composer': composer,
      'link': link,
      'conductor': conductor,
      'serviceOrganist': serviceOrganist,
      'colour': colour,
    };
  }

  static String parseDate(String date) {
    if (FundraisingEvent.isWeekDay(date)) {
      return '${date}s';
    }
    final DateFormat dateFormatter = DateFormat('EEEE d MMMM');
    if (date.length != 8) date = '0$date';
    return dateFormatter.format(DateTime.parse(date));
  }

  static String formatTime(String? time) {
    if (time == null) {
      return 'N/A';
    } else if (time == '') {
      return 'N/A';
    } else if (time.contains("-")) {
      var timeSplit = time.split("-");
      return '${padTime(timeSplit[0])} - ${padTime(timeSplit[1])}';
    }
     else if (double.tryParse(time) == null) {
      return time;
    }

    return padTime(time);
  }

  static String padTime(String time) {
    var paddedTime = time.padLeft(6, '0');
    return '${paddedTime.substring(0, 2)}:${paddedTime.substring(2, 4)}';
  }
}
