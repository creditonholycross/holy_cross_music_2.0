import 'package:csv/csv.dart';
import 'package:holy_cross_music/models/fundraisingEvent.dart';
import 'package:holy_cross_music/models/month.dart';
import 'package:http/http.dart' as http;
import "package:collection/collection.dart";
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

var eventsLink =
    'https://docs.google.com/spreadsheets/d/1r71O_Bm_-dkKBTtyAPMYMfhh1lg5-MwypKAnEs2eYkQ/gviz/tq?tqx=out:csv&sheet=FundraisingEvents';

Future<Map<String, List<MonthlyFundraisingEvents>>>
fetchFundraisingEvents() async {
  print('fetching events');
  http.Response response;

  try {
    response = await http.get((Uri.parse(eventsLink)));
  } catch (e) {
    print(e);
    if (!kIsWeb) {
      Fluttertoast.showToast(
        msg:
            'Failed to fetch fundraising events, check your internet connection',
      );
    }
    return {};
  }

  if (response.statusCode == 200) {
    var events = parseCsv(response.body);
    return groupEventsByMonth(events);
  } else {
    if (!kIsWeb) {
      Fluttertoast.showToast(msg: 'Failed to fetch fundraising events');
    }
    return {};
  }
}

List<FundraisingEvent> parseCsv(String csv) {
  List<List<dynamic>> parsedList = const CsvToListConverter().convert(
    csv,
    eol: '\n',
  );
  final keys = parsedList.first;

  var mappedList = parsedList
      .skip(1)
      .map((v) => Map.fromIterables(keys, v))
      .toList();

  List<FundraisingEvent> eventList;

  try {
    eventList = mappedList.map((e) => FundraisingEvent.fromCsv(e)).toList();
  } on FormatException {
    if (!kIsWeb) {
      Fluttertoast.showToast(msg: 'Failed to fetch events');
    }
    return [];
  }

  return eventList;
}

Map<String, List<MonthlyFundraisingEvents>> groupEventsByMonth(
  List<FundraisingEvent> eventList,
) {
  var monthlyList = <MonthlyFundraisingEvents>[];

  var filteredList = eventList.where((item) {
    var startDatetime = DateTime.parse(item.date);
    return startDatetime.compareTo(DateTime.now()) > 0;
  });

  var serviceMap = groupBy(
    filteredList,
    (item) => item.getdateLength(item.date),
  );

  serviceMap.forEach(
    (k, v) =>
        monthlyList.add(MonthlyFundraisingEvents.createFundraisingEvent(k, v)),
  );

  monthlyList.sort(
    (a, b) => '${a.year}${a.monthInt}'.compareTo('${b.year}${b.monthInt}'),
  );

  var yearMap = groupBy(monthlyList, (item) => item.year);

  return yearMap;
}
