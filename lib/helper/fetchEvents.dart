import 'package:csv/csv.dart';
import 'package:holy_cross_music/models/event.dart';
import 'package:holy_cross_music/models/month.dart';
import 'package:http/http.dart' as http;
import "package:collection/collection.dart";
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

var eventsLink =
    'https://docs.google.com/spreadsheets/d/1r71O_Bm_-dkKBTtyAPMYMfhh1lg5-MwypKAnEs2eYkQ/gviz/tq?tqx=out:csv&sheet=Events';

Future<Map<String, List<MonthlyEvents>>> fetchEvents() async {
  print('fetching events');
  http.Response response;

  try {
    response = await http.get((Uri.parse(eventsLink)));
  } catch (e) {
    print(e);
    if (!kIsWeb) {
      Fluttertoast.showToast(
        msg: 'Failed to fetch events, check your internet connection',
      );
    }
    return {};
  }

  if (response.statusCode == 200) {
    var events = parseCsv(response.body);
    return groupEventsByMonth(events);
  } else {
    if (!kIsWeb) {
      Fluttertoast.showToast(msg: 'Failed to fetch events');
    }
    return {};
  }
}

List<Event> parseCsv(String csv) {
  List<List<dynamic>> parsedList = const CsvToListConverter().convert(
    csv,
    eol: '\n',
  );
  final keys = parsedList.first;

  var mappedList = parsedList
      .skip(1)
      .map((v) => Map.fromIterables(keys, v))
      .toList();

  List<Event> eventList;

  try {
    eventList = mappedList.map((e) => Event.fromCsv(e)).toList();
  } on FormatException {
    if (!kIsWeb) {
      Fluttertoast.showToast(msg: 'Failed to fetch events');
    }
    return [];
  }

  return eventList;
}

Map<String, List<MonthlyEvents>> groupEventsByMonth(List<Event> eventList) {
  var monthlyList = <MonthlyEvents>[];

  var filteredList = eventList.where((item) {
    if (item.dateStart == null || item.dateStart == '') {
      return true;
    }
    var startDatetime = DateTime.parse(item.dateStart as String);
    return startDatetime.compareTo(DateTime.now()) > 0;
  });

  var serviceMap = groupBy(
    filteredList,
    (item) => item.getdateLength(item.dateStart),
  );

  serviceMap.forEach(
    (k, v) => monthlyList.add(MonthlyEvents.createEvent(k, v)),
  );

  monthlyList.sort(
    (a, b) => '${a.year}${a.monthInt}'.compareTo('${b.year}${b.monthInt}'),
  );

  var yearMap = groupBy(monthlyList, (item) => item.year);

  return yearMap;
}
