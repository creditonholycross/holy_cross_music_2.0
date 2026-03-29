import 'package:holy_cross_music/database/catalogueDatabase.dart';
import 'package:holy_cross_music/database/database.dart';
import 'package:holy_cross_music/database/truroDatabase.dart';
import 'package:holy_cross_music/helper/fetchMusic.dart';
import 'package:holy_cross_music/helper/fetchMusicTruro.dart';
import 'package:holy_cross_music/models/catalogue.dart';
import 'package:holy_cross_music/models/month.dart';
import 'package:holy_cross_music/models/music.dart';
import 'package:holy_cross_music/models/service.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DbFunctions {
  Future addMusic(Music music, {bool isAdmin = false}) async {
    MusicDatabaseHelper dbHelper = MusicDatabaseHelper();
    await dbHelper.insertMusic(music);
  }

  Future addMultipleMusic(List<Music> musicList, {bool isAdmin = false}) async {
    MusicDatabaseHelper dbHelper = MusicDatabaseHelper();
    for (var music in musicList) {
      await dbHelper.insertMusic(music);
    }
  }

  Future<List<MonthlyMusic>?> getServiceList() async {
    MusicDatabaseHelper dbHelper = MusicDatabaseHelper();
    var result = await dbHelper.getServiceList();
    if (result.isEmpty) {
      return null;
    }
    var musicList = result.map((e) => Music.fromDb(e)).toList();

    return groupMusicByMonth(musicList);
  }

  Future<Service?> getNextService() async {
    MusicDatabaseHelper dbHelper = MusicDatabaseHelper();
    final result = await dbHelper.getNextService();
    if (result.isEmpty) {
      return null;
    }
    var musicList = result.map((e) => Music.fromDb(e)).toList();
    return groupMusic(musicList).first;
  }

  Future deleteAllMusic() async {
    MusicDatabaseHelper dbHelper = MusicDatabaseHelper();
    await dbHelper.deleteAllMusic();
  }

  Future addCatalogue(List<Catalogue> catalogueList) async {
    CatalogueDatabaseHelper dbHelper = CatalogueDatabaseHelper();
    for (var music in catalogueList) {
      await dbHelper.insertMusic(music);
    }
  }

  Future<int?> getCatalogueCount() async {
    CatalogueDatabaseHelper dbHelper = CatalogueDatabaseHelper();
    final result = await dbHelper.getCount();
    return result;
  }

  Future<List<Catalogue>?> getCatalogue() async {
    CatalogueDatabaseHelper dbHelper = CatalogueDatabaseHelper();
    final result = await dbHelper.getCatalogue();
    if (result.isEmpty) {
      return null;
    }
    var catalogue = result.map((e) => Catalogue.fromDb(e)).toList();
    return catalogue;
  }

  Future deleteCatalogue() async {
    CatalogueDatabaseHelper dbHelper = CatalogueDatabaseHelper();
    await dbHelper.deleteCatalogue();
  }

  Future addMultipleTruroMusic(
    List<Music> musicList, {
    bool isAdmin = false,
  }) async {
    TruroDatabaseHelper dbHelper = TruroDatabaseHelper();
    for (var music in musicList) {
      await dbHelper.insertMusic(music);
    }
  }

  Future<Map<int, List<Service>>> getAllTruroServices() async {
    TruroDatabaseHelper dbHelper = TruroDatabaseHelper();
    var result = await dbHelper.getAllServices();
    if (result.isEmpty) {
      return groupMusicByDay([]);
    }
    var musicList = result.map((e) => Music.fromDb(e)).toList();

    return groupMusicByDay(musicList);
  }

  Future deleteTruroMusic() async {
    TruroDatabaseHelper dbHelper = TruroDatabaseHelper();
    await dbHelper.deleteAllMusic();
  }
}
