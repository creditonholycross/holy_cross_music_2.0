import 'dart:async';

import 'package:csv/csv.dart';
import 'package:holy_cross_music/database/database.dart';
import 'package:holy_cross_music/database/db_functions.dart';
import 'package:holy_cross_music/helper/fetchMusic.dart';
import 'package:holy_cross_music/models/month.dart';
import 'package:holy_cross_music/models/music.dart';
import 'package:holy_cross_music/models/service.dart';
import 'package:http/http.dart' as http;
import "package:collection/collection.dart";
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

var musicLink =
    'https://docs.google.com/spreadsheets/d/1r71O_Bm_-dkKBTtyAPMYMfhh1lg5-MwypKAnEs2eYkQ/gviz/tq?tqx=out:csv&sheet=Truro';

var testingMusicLink =
    'https://docs.google.com/spreadsheets/d/1r71O_Bm_-dkKBTtyAPMYMfhh1lg5-MwypKAnEs2eYkQ/gviz/tq?tqx=out:csv&sheet=Truro';

Future<void> updateTruroMusicDb({isAdmin = false}) async {
  print('updating db');

  String musicURI;
  http.Response response;

  if (kDebugMode) {
    musicURI = testingMusicLink;
  } else {
    musicURI = musicLink;
  }

  try {
    response = await http
        .get((Uri.parse(musicURI)))
        .timeout(const Duration(seconds: 3));
  } on TimeoutException {
    if (!kIsWeb) {
      Fluttertoast.showToast(
        msg: 'Failed to update music, check your internet connection',
      );
    }
    return;
  } catch (e) {
    print(e);
    if (!kIsWeb) {
      Fluttertoast.showToast(
        msg: 'Failed to update music, check your internet connection',
      );
    }
    return;
  }

  if (response.statusCode == 200) {
    var parsedMusic = parseCsv(response.body, isAdmin: isAdmin);
    if (parsedMusic.isEmpty) {
      return;
    }
    await DbFunctions().deleteTruroMusic();
    await DbFunctions().addMultipleTruroMusic(parsedMusic, isAdmin: isAdmin);
  } else {
    if (!kIsWeb) {
      Fluttertoast.showToast(msg: 'Failed to update music');
    }
  }
}

List<Music> parseCsv(String csv, {isAdmin = false}) {
  List<List<dynamic>> parsedList = const CsvToListConverter().convert(
    csv,
    eol: '\n',
  );
  final keys = parsedList.first;

  var mappedList = parsedList
      .skip(1)
      .map((v) => Map.fromIterables(keys, v))
      .toList();

  var musicList;

  try {
    musicList = mappedList.map((e) => Music.fromCsv(e)).toList();
  } on FormatException {
    if (isAdmin && !kIsWeb) {
      Fluttertoast.showToast(
        msg: 'Failed to update music - required fields missing',
      );
    } else if (!kIsWeb) {
      Fluttertoast.showToast(msg: 'Failed to update music');
    }
  }

  return musicList;
}

var dateMapping = {
  '20260727': 0,
  '20260728': 1,
  '20260729': 2,
  '20260730': 3,
  '20260731': 4,
  '20260802': 5,
};

Map<int, List<Service>> truroDateToIndex(Map<String, List<Service>> musicList) {
  Map<int, List<Service>> newMap = {0: [], 1: [], 2: [], 3: [], 4: [], 5: []};
  musicList.forEach((k, v) {
    if (dateMapping.containsKey(k)) {
      newMap[dateMapping[k] as int] = v;
    }
  });
  return newMap;
}

Map<int, List<Service>> groupMusicByDay(List<Music> musicList) {
  var serviceList = groupMusic(musicList);
  var serviceMap = groupBy(serviceList, (item) => item.date);

  return truroDateToIndex(serviceMap);
}

int getindexForDate() {
  var dateNow = DateTime.now();
  var formatter = DateFormat('yyyyMMdd');
  String formattedDate = formatter.format(dateNow);

  if (dateMapping.containsKey(formattedDate)) {
    return dateMapping[formattedDate] as int;
  }
  return 0;
}
