// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $MusicItemsTable extends MusicItems
    with TableInfo<$MusicItemsTable, MusicItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MusicItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rehearsalTimeMeta = const VerificationMeta(
    'rehearsalTime',
  );
  @override
  late final GeneratedColumn<String> rehearsalTime = GeneratedColumn<String>(
    'rehearsal_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serviceTypeMeta = const VerificationMeta(
    'serviceType',
  );
  @override
  late final GeneratedColumn<String> serviceType = GeneratedColumn<String>(
    'service_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _musicTypeMeta = const VerificationMeta(
    'musicType',
  );
  @override
  late final GeneratedColumn<String> musicType = GeneratedColumn<String>(
    'music_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _composerMeta = const VerificationMeta(
    'composer',
  );
  @override
  late final GeneratedColumn<String> composer = GeneratedColumn<String>(
    'composer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkMeta = const VerificationMeta('link');
  @override
  late final GeneratedColumn<String> link = GeneratedColumn<String>(
    'link',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serviceOrganistMeta = const VerificationMeta(
    'serviceOrganist',
  );
  @override
  late final GeneratedColumn<String> serviceOrganist = GeneratedColumn<String>(
    'service_organist',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colourMeta = const VerificationMeta('colour');
  @override
  late final GeneratedColumn<String> colour = GeneratedColumn<String>(
    'colour',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    time,
    rehearsalTime,
    serviceType,
    musicType,
    title,
    composer,
    link,
    serviceOrganist,
    colour,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'music_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<MusicItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('rehearsal_time')) {
      context.handle(
        _rehearsalTimeMeta,
        rehearsalTime.isAcceptableOrUnknown(
          data['rehearsal_time']!,
          _rehearsalTimeMeta,
        ),
      );
    }
    if (data.containsKey('service_type')) {
      context.handle(
        _serviceTypeMeta,
        serviceType.isAcceptableOrUnknown(
          data['service_type']!,
          _serviceTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serviceTypeMeta);
    }
    if (data.containsKey('music_type')) {
      context.handle(
        _musicTypeMeta,
        musicType.isAcceptableOrUnknown(data['music_type']!, _musicTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_musicTypeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('composer')) {
      context.handle(
        _composerMeta,
        composer.isAcceptableOrUnknown(data['composer']!, _composerMeta),
      );
    }
    if (data.containsKey('link')) {
      context.handle(
        _linkMeta,
        link.isAcceptableOrUnknown(data['link']!, _linkMeta),
      );
    }
    if (data.containsKey('service_organist')) {
      context.handle(
        _serviceOrganistMeta,
        serviceOrganist.isAcceptableOrUnknown(
          data['service_organist']!,
          _serviceOrganistMeta,
        ),
      );
    }
    if (data.containsKey('colour')) {
      context.handle(
        _colourMeta,
        colour.isAcceptableOrUnknown(data['colour']!, _colourMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MusicItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MusicItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time'],
      )!,
      rehearsalTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rehearsal_time'],
      ),
      serviceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_type'],
      )!,
      musicType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}music_type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      composer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}composer'],
      ),
      link: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}link'],
      ),
      serviceOrganist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_organist'],
      ),
      colour: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}colour'],
      ),
    );
  }

  @override
  $MusicItemsTable createAlias(String alias) {
    return $MusicItemsTable(attachedDatabase, alias);
  }
}

class MusicItem extends DataClass implements Insertable<MusicItem> {
  final int id;
  final String date;
  final String time;
  final String? rehearsalTime;
  final String serviceType;
  final String musicType;
  final String title;
  final String? composer;
  final String? link;
  final String? serviceOrganist;
  final String? colour;
  const MusicItem({
    required this.id,
    required this.date,
    required this.time,
    this.rehearsalTime,
    required this.serviceType,
    required this.musicType,
    required this.title,
    this.composer,
    this.link,
    this.serviceOrganist,
    this.colour,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['time'] = Variable<String>(time);
    if (!nullToAbsent || rehearsalTime != null) {
      map['rehearsal_time'] = Variable<String>(rehearsalTime);
    }
    map['service_type'] = Variable<String>(serviceType);
    map['music_type'] = Variable<String>(musicType);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || composer != null) {
      map['composer'] = Variable<String>(composer);
    }
    if (!nullToAbsent || link != null) {
      map['link'] = Variable<String>(link);
    }
    if (!nullToAbsent || serviceOrganist != null) {
      map['service_organist'] = Variable<String>(serviceOrganist);
    }
    if (!nullToAbsent || colour != null) {
      map['colour'] = Variable<String>(colour);
    }
    return map;
  }

  MusicItemsCompanion toCompanion(bool nullToAbsent) {
    return MusicItemsCompanion(
      id: Value(id),
      date: Value(date),
      time: Value(time),
      rehearsalTime: rehearsalTime == null && nullToAbsent
          ? const Value.absent()
          : Value(rehearsalTime),
      serviceType: Value(serviceType),
      musicType: Value(musicType),
      title: Value(title),
      composer: composer == null && nullToAbsent
          ? const Value.absent()
          : Value(composer),
      link: link == null && nullToAbsent ? const Value.absent() : Value(link),
      serviceOrganist: serviceOrganist == null && nullToAbsent
          ? const Value.absent()
          : Value(serviceOrganist),
      colour: colour == null && nullToAbsent
          ? const Value.absent()
          : Value(colour),
    );
  }

  factory MusicItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MusicItem(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      time: serializer.fromJson<String>(json['time']),
      rehearsalTime: serializer.fromJson<String?>(json['rehearsalTime']),
      serviceType: serializer.fromJson<String>(json['serviceType']),
      musicType: serializer.fromJson<String>(json['musicType']),
      title: serializer.fromJson<String>(json['title']),
      composer: serializer.fromJson<String?>(json['composer']),
      link: serializer.fromJson<String?>(json['link']),
      serviceOrganist: serializer.fromJson<String?>(json['serviceOrganist']),
      colour: serializer.fromJson<String?>(json['colour']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'time': serializer.toJson<String>(time),
      'rehearsalTime': serializer.toJson<String?>(rehearsalTime),
      'serviceType': serializer.toJson<String>(serviceType),
      'musicType': serializer.toJson<String>(musicType),
      'title': serializer.toJson<String>(title),
      'composer': serializer.toJson<String?>(composer),
      'link': serializer.toJson<String?>(link),
      'serviceOrganist': serializer.toJson<String?>(serviceOrganist),
      'colour': serializer.toJson<String?>(colour),
    };
  }

  MusicItem copyWith({
    int? id,
    String? date,
    String? time,
    Value<String?> rehearsalTime = const Value.absent(),
    String? serviceType,
    String? musicType,
    String? title,
    Value<String?> composer = const Value.absent(),
    Value<String?> link = const Value.absent(),
    Value<String?> serviceOrganist = const Value.absent(),
    Value<String?> colour = const Value.absent(),
  }) => MusicItem(
    id: id ?? this.id,
    date: date ?? this.date,
    time: time ?? this.time,
    rehearsalTime: rehearsalTime.present
        ? rehearsalTime.value
        : this.rehearsalTime,
    serviceType: serviceType ?? this.serviceType,
    musicType: musicType ?? this.musicType,
    title: title ?? this.title,
    composer: composer.present ? composer.value : this.composer,
    link: link.present ? link.value : this.link,
    serviceOrganist: serviceOrganist.present
        ? serviceOrganist.value
        : this.serviceOrganist,
    colour: colour.present ? colour.value : this.colour,
  );
  MusicItem copyWithCompanion(MusicItemsCompanion data) {
    return MusicItem(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      time: data.time.present ? data.time.value : this.time,
      rehearsalTime: data.rehearsalTime.present
          ? data.rehearsalTime.value
          : this.rehearsalTime,
      serviceType: data.serviceType.present
          ? data.serviceType.value
          : this.serviceType,
      musicType: data.musicType.present ? data.musicType.value : this.musicType,
      title: data.title.present ? data.title.value : this.title,
      composer: data.composer.present ? data.composer.value : this.composer,
      link: data.link.present ? data.link.value : this.link,
      serviceOrganist: data.serviceOrganist.present
          ? data.serviceOrganist.value
          : this.serviceOrganist,
      colour: data.colour.present ? data.colour.value : this.colour,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MusicItem(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('rehearsalTime: $rehearsalTime, ')
          ..write('serviceType: $serviceType, ')
          ..write('musicType: $musicType, ')
          ..write('title: $title, ')
          ..write('composer: $composer, ')
          ..write('link: $link, ')
          ..write('serviceOrganist: $serviceOrganist, ')
          ..write('colour: $colour')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    time,
    rehearsalTime,
    serviceType,
    musicType,
    title,
    composer,
    link,
    serviceOrganist,
    colour,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MusicItem &&
          other.id == this.id &&
          other.date == this.date &&
          other.time == this.time &&
          other.rehearsalTime == this.rehearsalTime &&
          other.serviceType == this.serviceType &&
          other.musicType == this.musicType &&
          other.title == this.title &&
          other.composer == this.composer &&
          other.link == this.link &&
          other.serviceOrganist == this.serviceOrganist &&
          other.colour == this.colour);
}

class MusicItemsCompanion extends UpdateCompanion<MusicItem> {
  final Value<int> id;
  final Value<String> date;
  final Value<String> time;
  final Value<String?> rehearsalTime;
  final Value<String> serviceType;
  final Value<String> musicType;
  final Value<String> title;
  final Value<String?> composer;
  final Value<String?> link;
  final Value<String?> serviceOrganist;
  final Value<String?> colour;
  const MusicItemsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.time = const Value.absent(),
    this.rehearsalTime = const Value.absent(),
    this.serviceType = const Value.absent(),
    this.musicType = const Value.absent(),
    this.title = const Value.absent(),
    this.composer = const Value.absent(),
    this.link = const Value.absent(),
    this.serviceOrganist = const Value.absent(),
    this.colour = const Value.absent(),
  });
  MusicItemsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required String time,
    this.rehearsalTime = const Value.absent(),
    required String serviceType,
    required String musicType,
    required String title,
    this.composer = const Value.absent(),
    this.link = const Value.absent(),
    this.serviceOrganist = const Value.absent(),
    this.colour = const Value.absent(),
  }) : date = Value(date),
       time = Value(time),
       serviceType = Value(serviceType),
       musicType = Value(musicType),
       title = Value(title);
  static Insertable<MusicItem> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<String>? time,
    Expression<String>? rehearsalTime,
    Expression<String>? serviceType,
    Expression<String>? musicType,
    Expression<String>? title,
    Expression<String>? composer,
    Expression<String>? link,
    Expression<String>? serviceOrganist,
    Expression<String>? colour,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (time != null) 'time': time,
      if (rehearsalTime != null) 'rehearsal_time': rehearsalTime,
      if (serviceType != null) 'service_type': serviceType,
      if (musicType != null) 'music_type': musicType,
      if (title != null) 'title': title,
      if (composer != null) 'composer': composer,
      if (link != null) 'link': link,
      if (serviceOrganist != null) 'service_organist': serviceOrganist,
      if (colour != null) 'colour': colour,
    });
  }

  MusicItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<String>? time,
    Value<String?>? rehearsalTime,
    Value<String>? serviceType,
    Value<String>? musicType,
    Value<String>? title,
    Value<String?>? composer,
    Value<String?>? link,
    Value<String?>? serviceOrganist,
    Value<String?>? colour,
  }) {
    return MusicItemsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      rehearsalTime: rehearsalTime ?? this.rehearsalTime,
      serviceType: serviceType ?? this.serviceType,
      musicType: musicType ?? this.musicType,
      title: title ?? this.title,
      composer: composer ?? this.composer,
      link: link ?? this.link,
      serviceOrganist: serviceOrganist ?? this.serviceOrganist,
      colour: colour ?? this.colour,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (rehearsalTime.present) {
      map['rehearsal_time'] = Variable<String>(rehearsalTime.value);
    }
    if (serviceType.present) {
      map['service_type'] = Variable<String>(serviceType.value);
    }
    if (musicType.present) {
      map['music_type'] = Variable<String>(musicType.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (composer.present) {
      map['composer'] = Variable<String>(composer.value);
    }
    if (link.present) {
      map['link'] = Variable<String>(link.value);
    }
    if (serviceOrganist.present) {
      map['service_organist'] = Variable<String>(serviceOrganist.value);
    }
    if (colour.present) {
      map['colour'] = Variable<String>(colour.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MusicItemsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('rehearsalTime: $rehearsalTime, ')
          ..write('serviceType: $serviceType, ')
          ..write('musicType: $musicType, ')
          ..write('title: $title, ')
          ..write('composer: $composer, ')
          ..write('link: $link, ')
          ..write('serviceOrganist: $serviceOrganist, ')
          ..write('colour: $colour')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MusicItemsTable musicItems = $MusicItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [musicItems];
}

typedef $$MusicItemsTableCreateCompanionBuilder =
    MusicItemsCompanion Function({
      Value<int> id,
      required String date,
      required String time,
      Value<String?> rehearsalTime,
      required String serviceType,
      required String musicType,
      required String title,
      Value<String?> composer,
      Value<String?> link,
      Value<String?> serviceOrganist,
      Value<String?> colour,
    });
typedef $$MusicItemsTableUpdateCompanionBuilder =
    MusicItemsCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<String> time,
      Value<String?> rehearsalTime,
      Value<String> serviceType,
      Value<String> musicType,
      Value<String> title,
      Value<String?> composer,
      Value<String?> link,
      Value<String?> serviceOrganist,
      Value<String?> colour,
    });

class $$MusicItemsTableFilterComposer
    extends Composer<_$AppDatabase, $MusicItemsTable> {
  $$MusicItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rehearsalTime => $composableBuilder(
    column: $table.rehearsalTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get musicType => $composableBuilder(
    column: $table.musicType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get composer => $composableBuilder(
    column: $table.composer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get link => $composableBuilder(
    column: $table.link,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serviceOrganist => $composableBuilder(
    column: $table.serviceOrganist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colour => $composableBuilder(
    column: $table.colour,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MusicItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $MusicItemsTable> {
  $$MusicItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rehearsalTime => $composableBuilder(
    column: $table.rehearsalTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get musicType => $composableBuilder(
    column: $table.musicType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get composer => $composableBuilder(
    column: $table.composer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get link => $composableBuilder(
    column: $table.link,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceOrganist => $composableBuilder(
    column: $table.serviceOrganist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colour => $composableBuilder(
    column: $table.colour,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MusicItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MusicItemsTable> {
  $$MusicItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get rehearsalTime => $composableBuilder(
    column: $table.rehearsalTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get musicType =>
      $composableBuilder(column: $table.musicType, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get composer =>
      $composableBuilder(column: $table.composer, builder: (column) => column);

  GeneratedColumn<String> get link =>
      $composableBuilder(column: $table.link, builder: (column) => column);

  GeneratedColumn<String> get serviceOrganist => $composableBuilder(
    column: $table.serviceOrganist,
    builder: (column) => column,
  );

  GeneratedColumn<String> get colour =>
      $composableBuilder(column: $table.colour, builder: (column) => column);
}

class $$MusicItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MusicItemsTable,
          MusicItem,
          $$MusicItemsTableFilterComposer,
          $$MusicItemsTableOrderingComposer,
          $$MusicItemsTableAnnotationComposer,
          $$MusicItemsTableCreateCompanionBuilder,
          $$MusicItemsTableUpdateCompanionBuilder,
          (
            MusicItem,
            BaseReferences<_$AppDatabase, $MusicItemsTable, MusicItem>,
          ),
          MusicItem,
          PrefetchHooks Function()
        > {
  $$MusicItemsTableTableManager(_$AppDatabase db, $MusicItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MusicItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MusicItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MusicItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> time = const Value.absent(),
                Value<String?> rehearsalTime = const Value.absent(),
                Value<String> serviceType = const Value.absent(),
                Value<String> musicType = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> composer = const Value.absent(),
                Value<String?> link = const Value.absent(),
                Value<String?> serviceOrganist = const Value.absent(),
                Value<String?> colour = const Value.absent(),
              }) => MusicItemsCompanion(
                id: id,
                date: date,
                time: time,
                rehearsalTime: rehearsalTime,
                serviceType: serviceType,
                musicType: musicType,
                title: title,
                composer: composer,
                link: link,
                serviceOrganist: serviceOrganist,
                colour: colour,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                required String time,
                Value<String?> rehearsalTime = const Value.absent(),
                required String serviceType,
                required String musicType,
                required String title,
                Value<String?> composer = const Value.absent(),
                Value<String?> link = const Value.absent(),
                Value<String?> serviceOrganist = const Value.absent(),
                Value<String?> colour = const Value.absent(),
              }) => MusicItemsCompanion.insert(
                id: id,
                date: date,
                time: time,
                rehearsalTime: rehearsalTime,
                serviceType: serviceType,
                musicType: musicType,
                title: title,
                composer: composer,
                link: link,
                serviceOrganist: serviceOrganist,
                colour: colour,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MusicItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MusicItemsTable,
      MusicItem,
      $$MusicItemsTableFilterComposer,
      $$MusicItemsTableOrderingComposer,
      $$MusicItemsTableAnnotationComposer,
      $$MusicItemsTableCreateCompanionBuilder,
      $$MusicItemsTableUpdateCompanionBuilder,
      (MusicItem, BaseReferences<_$AppDatabase, $MusicItemsTable, MusicItem>),
      MusicItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MusicItemsTableTableManager get musicItems =>
      $$MusicItemsTableTableManager(_db, _db.musicItems);
}
