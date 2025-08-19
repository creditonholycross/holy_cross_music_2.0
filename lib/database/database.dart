import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@TableIndex(name: 'datetime', columns: {#date, #time})
class MusicItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()();
  TextColumn get time => text()();
  TextColumn get rehearsalTime => text().nullable()();
  TextColumn get serviceType => text()();
  TextColumn get musicType => text()();
  TextColumn get title => text()();
  TextColumn get composer => text().nullable()();
  TextColumn get link => text().nullable()();
  TextColumn get serviceOrganist => text().nullable()();
  TextColumn get colour => text().nullable()();
}

@DriftDatabase(tables: [MusicItems])
class AppDatabase extends _$AppDatabase {
  static AppDatabase instance() => AppDatabase();

  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
