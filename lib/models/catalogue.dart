import 'package:drift/drift.dart';
import 'package:holy_cross_music/database/database.dart';

class Catalogue {
  final String? id;
  final String composer;
  final String title;
  final String parts;
  final String? publisher;
  final String? season;
  final String? subCat;
  final String? source;
  final String? date;

  const Catalogue({
    this.id,
    required this.composer,
    required this.title,
    required this.parts,
    this.publisher,
    this.season,
    this.subCat,
    this.source,
    this.date,
  });

  Map<String, Object?> toMap() {
    return {
      'id': '$composer$title$parts$publisher$subCat$source$date',
      'composer': composer,
      'title': title,
      'parts': parts,
      'publisher': publisher,
      'season': season,
    };
  }

  factory Catalogue.fromCsv(Map<dynamic, dynamic> dict) {
    return Catalogue(
      composer: dict['COMPOSER'],
      title: dict['TITLE'],
      parts: dict['PARTS'],
      publisher: dict['PUBLISHER']!,
      season: dict['SEASON']!,
      subCat: dict['SUB CATEGORY']!,
      source: dict['SOURCE'],
      date: dict['DATE'],
    );
  }

  factory Catalogue.fromDb(Map<dynamic, dynamic> dict) {
    return Catalogue(
      composer: dict['composer'],
      title: dict['title'],
      parts: dict['parts'],
      publisher: dict['publisher']!,
      season: dict.containsKey('season') ? dict['season'] : "",
    );
  }
}
