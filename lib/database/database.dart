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

class CatalogueItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get composer => text()();
  TextColumn get title => text()();
  TextColumn get parts => text()();
  TextColumn get publisher => text().nullable()();
  TextColumn get season => text().nullable()();
  TextColumn get subCat => text().nullable()();
  TextColumn get source => text().nullable()();
  TextColumn get date => text().nullable()();
}

@DriftDatabase(tables: [MusicItems, CatalogueItems])
class AppDatabase extends _$AppDatabase {
  static AppDatabase instance() => AppDatabase();

  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(catalogueItems);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
