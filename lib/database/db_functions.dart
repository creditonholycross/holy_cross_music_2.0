import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:holy_cross_music/helper/fetchMusic.dart';
import 'package:holy_cross_music/models/catalogue.dart';
import 'package:holy_cross_music/models/month.dart';
import 'package:holy_cross_music/models/service.dart';
import 'package:intl/intl.dart';
import 'package:holy_cross_music/database/database.dart';

import 'package:holy_cross_music/models/music.dart';

class DbFunctions {
  Future<void> addMusic(AppDatabase db, Music entry) async {
    await db.into(db.musicItems).insert(entry.toCompanion());
  }

  Future<void> addMultipleMusic(AppDatabase db, List<Music> musicList) async {
    await db.batch((b) {
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

    if (result.isEmpty) {
      return null;
    }
    var musicList = result.map((e) => Music.fromDb(e)).toList();

    return groupMusicByMonth(musicList);
  }

  Future<Service?> getNextService(AppDatabase db) async {
    List<MonthlyMusic>? monthly_music = await getServiceList(db);
    return monthly_music!.first.services.firstOrNull;
  }

  Future deleteAllMusic(AppDatabase db) async {
    await (db.delete(db.musicItems)).go();
  }

  Future addCatalogue(AppDatabase db, List<Catalogue> catalogueList) async {
    await db.batch((b) {
      b.insertAll(db.catalogueItems, [
        for (var c in catalogueList) c.toCompanion(),
      ]);
    });
  }

  Future<int?> getCatalogueCount(AppDatabase db) async {
    final count = db.catalogueItems.id.count();
    var result = await (db.selectOnly(
      db.catalogueItems,
    )..addColumns([count])).map((row) => row.read(count)).getSingle();
    return result;
  }

  Future<List<Catalogue>?> getCatalogue(AppDatabase db) async {
    final result =
        await (db.select(db.catalogueItems)..orderBy([
              (c) => OrderingTerm(expression: c.composer),
              (c) => OrderingTerm(expression: c.title),
            ]))
            .get();

    if (result.isEmpty) {
      return null;
    }
    var catalogue = result.map((e) => Catalogue.fromDb(e)).toList();
    return catalogue;
  }

  Future deleteCatalogue(AppDatabase db) async {
    await (db.delete(db.catalogueItems)).go();
  }
}
