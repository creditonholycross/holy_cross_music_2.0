import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:holy_cross_music/helper/fetchMusic.dart';
import 'package:holy_cross_music/models/month.dart';
import 'package:intl/intl.dart';
import 'package:holy_cross_music/database/database.dart';

import 'package:holy_cross_music/models/music.dart';

class DbFunctions {
  Future<void> addMusic(AppDatabase db, Music entry) async {
    await db.into(db.musicItems).insert(entry.toCompanion());
  }

  Future<void> addMultipleMusic(AppDatabase db, List<Music> musicList) async {
    db.batch((b) {
      b.insertAll(db.musicItems, [for (var m in musicList) m.toCompanion()]);
    });
  }

  Future<List<MonthlyMusic>?> getServiceList(AppDatabase db) async {
    var now = DateTime.now();
    var formatter = DateFormat('yyyyMMdd');
    String formattedDate = formatter.format(now);
    var timeFormatter = DateFormat('HHmmss');
    String formattedTime = timeFormatter.format(
      now.subtract(const Duration(hours: 2)),
    );

    var result =
        await (db.select(db.musicItems)..where(
              (m) => (m.date + m.time).isBiggerOrEqualValue(
                '$formattedDate$formattedTime',
              ),
            ))
            .get();
    // var datetimeStr = m.date + m.time;
    // return datetimeStr.isBiggerOrEqualValue('$formattedDate$formattedTime');

    if (result.isEmpty) {
      return null;
    }
    var musicList = result.map((e) => Music.fromDb(e)).toList();

    return groupMusicByMonth(musicList);
  }

  // Future<Service?> getNextService() async {
  //   MusicDatabaseHelper dbHelper = MusicDatabaseHelper();
  //   final result = await dbHelper.getNextService();
  //   if (result.isEmpty) {
  //     return null;
  //   }
  //   var musicList = result.map((e) => Music.fromDb(e)).toList();
  //   return groupMusic(musicList).first;
  // }

  // Future deleteAllMusic() async {
  //   MusicDatabaseHelper dbHelper = MusicDatabaseHelper();
  //   await dbHelper.deleteAllMusic();
  // }

  // Future addCatalogue(List<Catalogue> catalogueList) async {
  //   CatalogueDatabaseHelper dbHelper = CatalogueDatabaseHelper();
  //   for (var music in catalogueList) {
  //     await dbHelper.insertMusic(music);
  //   }
  // }

  // Future<int?> getCatalogueCount() async {
  //   CatalogueDatabaseHelper dbHelper = CatalogueDatabaseHelper();
  //   final result = await dbHelper.getCount();
  //   return result;
  // }

  // Future<List<Catalogue>?> getCatalogue() async {
  //   CatalogueDatabaseHelper dbHelper = CatalogueDatabaseHelper();
  //   final result = await dbHelper.getCatalogue();
  //   if (result.isEmpty) {
  //     return null;
  //   }
  //   var catalogue = result.map((e) => Catalogue.fromDb(e)).toList();
  //   return catalogue;
  // }

  // Future deleteCatalogue() async {
  //   CatalogueDatabaseHelper dbHelper = CatalogueDatabaseHelper();
  //   await dbHelper.deleteCatalogue();
  // }
}
