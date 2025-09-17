import 'package:holy_cross_music/models/event.dart';
import 'package:holy_cross_music/models/fundraisingEvent.dart';
import 'package:holy_cross_music/models/service.dart';

var monthConv = {
  '01': 'January',
  '02': 'February',
  '03': 'March',
  '04': 'April',
  '05': 'May',
  '06': 'June',
  '07': 'July',
  '08': 'August',
  '09': 'September',
  '10': 'October',
  '11': 'November',
  '12': 'December',
  '13': 'TBC',
};

class MonthlyMusic {
  final String monthName;
  final String monthInt;
  final List<Service> services;

  const MonthlyMusic({
    required this.monthName,
    required this.monthInt,
    required this.services,
  });

  factory MonthlyMusic.createService(String monthInt, List<Service> services) {
    return MonthlyMusic(
      monthName: monthConv[monthInt] ?? 'January',
      monthInt: monthInt,
      services: services,
    );
  }
}

class MonthlyEvents {
  final String monthName;
  final String monthInt;
  final String year;
  final List<Event> events;

  const MonthlyEvents({
    required this.monthName,
    required this.monthInt,
    required this.year,
    required this.events,
  });

  factory MonthlyEvents.createEvent(String dateStart, List<Event> events) {
    var monthInt = dateStart.substring(5, 7);
    var year = Event.getYear(dateStart);
    var monthName = monthConv[monthInt] ?? 'TBC';
    if (monthName == 'TBC') {
      monthInt = '13';
    }
    return MonthlyEvents(
      monthName: monthName,
      monthInt: monthInt,
      year: year,
      events: events,
    );
  }
}

class MonthlyFundraisingEvents {
  final String monthName;
  final String monthInt;
  final String year;
  final List<FundraisingEvent> events;

  const MonthlyFundraisingEvents({
    required this.monthName,
    required this.monthInt,
    required this.year,
    required this.events,
  });

  factory MonthlyFundraisingEvents.createFundraisingEvent(
    String date,
    List<FundraisingEvent> events,
  ) {
    var monthInt = date.substring(5, 7);
    var year = Event.getYear(date);
    var monthName = monthConv[monthInt] ?? 'TBC';
    if (monthName == 'TBC') {
      monthInt = '13';
    }
    return MonthlyFundraisingEvents(
      monthName: monthName,
      monthInt: monthInt,
      year: year,
      events: events,
    );
  }
}
