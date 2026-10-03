// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_database.dart';

// ignore_for_file: type=lint
class $LocalParentsTable extends LocalParents
    with TableInfo<$LocalParentsTable, ParentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalParentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _singletonMeta = const VerificationMeta(
    'singleton',
  );
  @override
  late final GeneratedColumn<int> singleton = GeneratedColumn<int>(
    'singleton',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    singleton,
    displayName,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_parents';
  @override
  VerificationContext validateIntegrity(
    Insertable<ParentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('singleton')) {
      context.handle(
        _singletonMeta,
        singleton.isAcceptableOrUnknown(data['singleton']!, _singletonMeta),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ParentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      singleton: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}singleton'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalParentsTable createAlias(String alias) {
    return $LocalParentsTable(attachedDatabase, alias);
  }
}

class ParentRow extends DataClass implements Insertable<ParentRow> {
  final String id;
  final int singleton;
  final String? displayName;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ParentRow({
    required this.id,
    required this.singleton,
    this.displayName,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['singleton'] = Variable<int>(singleton);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalParentsCompanion toCompanion(bool nullToAbsent) {
    return LocalParentsCompanion(
      id: Value(id),
      singleton: Value(singleton),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ParentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParentRow(
      id: serializer.fromJson<String>(json['id']),
      singleton: serializer.fromJson<int>(json['singleton']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'singleton': serializer.toJson<int>(singleton),
      'displayName': serializer.toJson<String?>(displayName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ParentRow copyWith({
    String? id,
    int? singleton,
    Value<String?> displayName = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ParentRow(
    id: id ?? this.id,
    singleton: singleton ?? this.singleton,
    displayName: displayName.present ? displayName.value : this.displayName,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ParentRow copyWithCompanion(LocalParentsCompanion data) {
    return ParentRow(
      id: data.id.present ? data.id.value : this.id,
      singleton: data.singleton.present ? data.singleton.value : this.singleton,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParentRow(')
          ..write('id: $id, ')
          ..write('singleton: $singleton, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, singleton, displayName, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParentRow &&
          other.id == this.id &&
          other.singleton == this.singleton &&
          other.displayName == this.displayName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocalParentsCompanion extends UpdateCompanion<ParentRow> {
  final Value<String> id;
  final Value<int> singleton;
  final Value<String?> displayName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalParentsCompanion({
    this.id = const Value.absent(),
    this.singleton = const Value.absent(),
    this.displayName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalParentsCompanion.insert({
    required String id,
    this.singleton = const Value.absent(),
    this.displayName = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ParentRow> custom({
    Expression<String>? id,
    Expression<int>? singleton,
    Expression<String>? displayName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (singleton != null) 'singleton': singleton,
      if (displayName != null) 'display_name': displayName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalParentsCompanion copyWith({
    Value<String>? id,
    Value<int>? singleton,
    Value<String?>? displayName,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalParentsCompanion(
      id: id ?? this.id,
      singleton: singleton ?? this.singleton,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (singleton.present) {
      map['singleton'] = Variable<int>(singleton.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalParentsCompanion(')
          ..write('id: $id, ')
          ..write('singleton: $singleton, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalChildrenTable extends LocalChildren
    with TableInfo<$LocalChildrenTable, ChildRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalChildrenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES local_parents (id)',
    ),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 160,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startingAgeMeta = const VerificationMeta(
    'startingAge',
  );
  @override
  late final GeneratedColumn<int> startingAge = GeneratedColumn<int>(
    'starting_age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarIdMeta = const VerificationMeta(
    'avatarId',
  );
  @override
  late final GeneratedColumn<String> avatarId = GeneratedColumn<String>(
    'avatar_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    parentId,
    displayName,
    startingAge,
    avatarId,
    language,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_children';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChildRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_parentIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('starting_age')) {
      context.handle(
        _startingAgeMeta,
        startingAge.isAcceptableOrUnknown(
          data['starting_age']!,
          _startingAgeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startingAgeMeta);
    }
    if (data.containsKey('avatar_id')) {
      context.handle(
        _avatarIdMeta,
        avatarId.isAcceptableOrUnknown(data['avatar_id']!, _avatarIdMeta),
      );
    } else if (isInserting) {
      context.missing(_avatarIdMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChildRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChildRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      startingAge: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}starting_age'],
      )!,
      avatarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_id'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalChildrenTable createAlias(String alias) {
    return $LocalChildrenTable(attachedDatabase, alias);
  }
}

class ChildRow extends DataClass implements Insertable<ChildRow> {
  final String id;
  final String parentId;
  final String displayName;
  final int startingAge;
  final String avatarId;
  final String language;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ChildRow({
    required this.id,
    required this.parentId,
    required this.displayName,
    required this.startingAge,
    required this.avatarId,
    required this.language,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['parent_id'] = Variable<String>(parentId);
    map['display_name'] = Variable<String>(displayName);
    map['starting_age'] = Variable<int>(startingAge);
    map['avatar_id'] = Variable<String>(avatarId);
    map['language'] = Variable<String>(language);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalChildrenCompanion toCompanion(bool nullToAbsent) {
    return LocalChildrenCompanion(
      id: Value(id),
      parentId: Value(parentId),
      displayName: Value(displayName),
      startingAge: Value(startingAge),
      avatarId: Value(avatarId),
      language: Value(language),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ChildRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChildRow(
      id: serializer.fromJson<String>(json['id']),
      parentId: serializer.fromJson<String>(json['parentId']),
      displayName: serializer.fromJson<String>(json['displayName']),
      startingAge: serializer.fromJson<int>(json['startingAge']),
      avatarId: serializer.fromJson<String>(json['avatarId']),
      language: serializer.fromJson<String>(json['language']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'parentId': serializer.toJson<String>(parentId),
      'displayName': serializer.toJson<String>(displayName),
      'startingAge': serializer.toJson<int>(startingAge),
      'avatarId': serializer.toJson<String>(avatarId),
      'language': serializer.toJson<String>(language),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ChildRow copyWith({
    String? id,
    String? parentId,
    String? displayName,
    int? startingAge,
    String? avatarId,
    String? language,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ChildRow(
    id: id ?? this.id,
    parentId: parentId ?? this.parentId,
    displayName: displayName ?? this.displayName,
    startingAge: startingAge ?? this.startingAge,
    avatarId: avatarId ?? this.avatarId,
    language: language ?? this.language,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ChildRow copyWithCompanion(LocalChildrenCompanion data) {
    return ChildRow(
      id: data.id.present ? data.id.value : this.id,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      startingAge: data.startingAge.present
          ? data.startingAge.value
          : this.startingAge,
      avatarId: data.avatarId.present ? data.avatarId.value : this.avatarId,
      language: data.language.present ? data.language.value : this.language,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChildRow(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('displayName: $displayName, ')
          ..write('startingAge: $startingAge, ')
          ..write('avatarId: $avatarId, ')
          ..write('language: $language, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    parentId,
    displayName,
    startingAge,
    avatarId,
    language,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChildRow &&
          other.id == this.id &&
          other.parentId == this.parentId &&
          other.displayName == this.displayName &&
          other.startingAge == this.startingAge &&
          other.avatarId == this.avatarId &&
          other.language == this.language &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocalChildrenCompanion extends UpdateCompanion<ChildRow> {
  final Value<String> id;
  final Value<String> parentId;
  final Value<String> displayName;
  final Value<int> startingAge;
  final Value<String> avatarId;
  final Value<String> language;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalChildrenCompanion({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.startingAge = const Value.absent(),
    this.avatarId = const Value.absent(),
    this.language = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalChildrenCompanion.insert({
    required String id,
    required String parentId,
    required String displayName,
    required int startingAge,
    required String avatarId,
    required String language,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       parentId = Value(parentId),
       displayName = Value(displayName),
       startingAge = Value(startingAge),
       avatarId = Value(avatarId),
       language = Value(language),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ChildRow> custom({
    Expression<String>? id,
    Expression<String>? parentId,
    Expression<String>? displayName,
    Expression<int>? startingAge,
    Expression<String>? avatarId,
    Expression<String>? language,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentId != null) 'parent_id': parentId,
      if (displayName != null) 'display_name': displayName,
      if (startingAge != null) 'starting_age': startingAge,
      if (avatarId != null) 'avatar_id': avatarId,
      if (language != null) 'language': language,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalChildrenCompanion copyWith({
    Value<String>? id,
    Value<String>? parentId,
    Value<String>? displayName,
    Value<int>? startingAge,
    Value<String>? avatarId,
    Value<String>? language,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalChildrenCompanion(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      displayName: displayName ?? this.displayName,
      startingAge: startingAge ?? this.startingAge,
      avatarId: avatarId ?? this.avatarId,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (startingAge.present) {
      map['starting_age'] = Variable<int>(startingAge.value);
    }
    if (avatarId.present) {
      map['avatar_id'] = Variable<String>(avatarId.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalChildrenCompanion(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('displayName: $displayName, ')
          ..write('startingAge: $startingAge, ')
          ..write('avatarId: $avatarId, ')
          ..write('language: $language, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSetupTable extends LocalSetup
    with TableInfo<$LocalSetupTable, SetupRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSetupTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, completed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_setup';
  @override
  VerificationContext validateIntegrity(
    Insertable<SetupRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    } else if (isInserting) {
      context.missing(_completedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetupRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetupRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
    );
  }

  @override
  $LocalSetupTable createAlias(String alias) {
    return $LocalSetupTable(attachedDatabase, alias);
  }
}

class SetupRow extends DataClass implements Insertable<SetupRow> {
  final int id;
  final bool completed;
  const SetupRow({required this.id, required this.completed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['completed'] = Variable<bool>(completed);
    return map;
  }

  LocalSetupCompanion toCompanion(bool nullToAbsent) {
    return LocalSetupCompanion(id: Value(id), completed: Value(completed));
  }

  factory SetupRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetupRow(
      id: serializer.fromJson<int>(json['id']),
      completed: serializer.fromJson<bool>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'completed': serializer.toJson<bool>(completed),
    };
  }

  SetupRow copyWith({int? id, bool? completed}) =>
      SetupRow(id: id ?? this.id, completed: completed ?? this.completed);
  SetupRow copyWithCompanion(LocalSetupCompanion data) {
    return SetupRow(
      id: data.id.present ? data.id.value : this.id,
      completed: data.completed.present ? data.completed.value : this.completed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetupRow(')
          ..write('id: $id, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, completed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetupRow &&
          other.id == this.id &&
          other.completed == this.completed);
}

class LocalSetupCompanion extends UpdateCompanion<SetupRow> {
  final Value<int> id;
  final Value<bool> completed;
  const LocalSetupCompanion({
    this.id = const Value.absent(),
    this.completed = const Value.absent(),
  });
  LocalSetupCompanion.insert({
    this.id = const Value.absent(),
    required bool completed,
  }) : completed = Value(completed);
  static Insertable<SetupRow> custom({
    Expression<int>? id,
    Expression<bool>? completed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (completed != null) 'completed': completed,
    });
  }

  LocalSetupCompanion copyWith({Value<int>? id, Value<bool>? completed}) {
    return LocalSetupCompanion(
      id: id ?? this.id,
      completed: completed ?? this.completed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSetupCompanion(')
          ..write('id: $id, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }
}

class $ChildProgressesTable extends ChildProgresses
    with TableInfo<$ChildProgressesTable, ChildProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChildProgressesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<String> childId = GeneratedColumn<String>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES local_children (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _experiencePointsMeta = const VerificationMeta(
    'experiencePoints',
  );
  @override
  late final GeneratedColumn<int> experiencePoints = GeneratedColumn<int>(
    'experience_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _starsMeta = const VerificationMeta('stars');
  @override
  late final GeneratedColumn<int> stars = GeneratedColumn<int>(
    'stars',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _coinsMeta = const VerificationMeta('coins');
  @override
  late final GeneratedColumn<int> coins = GeneratedColumn<int>(
    'coins',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalLearningActivitiesCompletedMeta =
      const VerificationMeta('totalLearningActivitiesCompleted');
  @override
  late final GeneratedColumn<int> totalLearningActivitiesCompleted =
      GeneratedColumn<int>(
        'total_learning_activities_completed',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    childId,
    experiencePoints,
    stars,
    coins,
    totalLearningActivitiesCompleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'child_progresses';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChildProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('experience_points')) {
      context.handle(
        _experiencePointsMeta,
        experiencePoints.isAcceptableOrUnknown(
          data['experience_points']!,
          _experiencePointsMeta,
        ),
      );
    }
    if (data.containsKey('stars')) {
      context.handle(
        _starsMeta,
        stars.isAcceptableOrUnknown(data['stars']!, _starsMeta),
      );
    }
    if (data.containsKey('coins')) {
      context.handle(
        _coinsMeta,
        coins.isAcceptableOrUnknown(data['coins']!, _coinsMeta),
      );
    }
    if (data.containsKey('total_learning_activities_completed')) {
      context.handle(
        _totalLearningActivitiesCompletedMeta,
        totalLearningActivitiesCompleted.isAcceptableOrUnknown(
          data['total_learning_activities_completed']!,
          _totalLearningActivitiesCompletedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {childId};
  @override
  ChildProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChildProgressRow(
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_id'],
      )!,
      experiencePoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}experience_points'],
      )!,
      stars: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stars'],
      )!,
      coins: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}coins'],
      )!,
      totalLearningActivitiesCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_learning_activities_completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ChildProgressesTable createAlias(String alias) {
    return $ChildProgressesTable(attachedDatabase, alias);
  }
}

class ChildProgressRow extends DataClass
    implements Insertable<ChildProgressRow> {
  final String childId;
  final int experiencePoints;
  final int stars;
  final int coins;
  final int totalLearningActivitiesCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ChildProgressRow({
    required this.childId,
    required this.experiencePoints,
    required this.stars,
    required this.coins,
    required this.totalLearningActivitiesCompleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['child_id'] = Variable<String>(childId);
    map['experience_points'] = Variable<int>(experiencePoints);
    map['stars'] = Variable<int>(stars);
    map['coins'] = Variable<int>(coins);
    map['total_learning_activities_completed'] = Variable<int>(
      totalLearningActivitiesCompleted,
    );
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ChildProgressesCompanion toCompanion(bool nullToAbsent) {
    return ChildProgressesCompanion(
      childId: Value(childId),
      experiencePoints: Value(experiencePoints),
      stars: Value(stars),
      coins: Value(coins),
      totalLearningActivitiesCompleted: Value(totalLearningActivitiesCompleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ChildProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChildProgressRow(
      childId: serializer.fromJson<String>(json['childId']),
      experiencePoints: serializer.fromJson<int>(json['experiencePoints']),
      stars: serializer.fromJson<int>(json['stars']),
      coins: serializer.fromJson<int>(json['coins']),
      totalLearningActivitiesCompleted: serializer.fromJson<int>(
        json['totalLearningActivitiesCompleted'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'childId': serializer.toJson<String>(childId),
      'experiencePoints': serializer.toJson<int>(experiencePoints),
      'stars': serializer.toJson<int>(stars),
      'coins': serializer.toJson<int>(coins),
      'totalLearningActivitiesCompleted': serializer.toJson<int>(
        totalLearningActivitiesCompleted,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ChildProgressRow copyWith({
    String? childId,
    int? experiencePoints,
    int? stars,
    int? coins,
    int? totalLearningActivitiesCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ChildProgressRow(
    childId: childId ?? this.childId,
    experiencePoints: experiencePoints ?? this.experiencePoints,
    stars: stars ?? this.stars,
    coins: coins ?? this.coins,
    totalLearningActivitiesCompleted:
        totalLearningActivitiesCompleted ??
        this.totalLearningActivitiesCompleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ChildProgressRow copyWithCompanion(ChildProgressesCompanion data) {
    return ChildProgressRow(
      childId: data.childId.present ? data.childId.value : this.childId,
      experiencePoints: data.experiencePoints.present
          ? data.experiencePoints.value
          : this.experiencePoints,
      stars: data.stars.present ? data.stars.value : this.stars,
      coins: data.coins.present ? data.coins.value : this.coins,
      totalLearningActivitiesCompleted:
          data.totalLearningActivitiesCompleted.present
          ? data.totalLearningActivitiesCompleted.value
          : this.totalLearningActivitiesCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChildProgressRow(')
          ..write('childId: $childId, ')
          ..write('experiencePoints: $experiencePoints, ')
          ..write('stars: $stars, ')
          ..write('coins: $coins, ')
          ..write(
            'totalLearningActivitiesCompleted: $totalLearningActivitiesCompleted, ',
          )
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    childId,
    experiencePoints,
    stars,
    coins,
    totalLearningActivitiesCompleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChildProgressRow &&
          other.childId == this.childId &&
          other.experiencePoints == this.experiencePoints &&
          other.stars == this.stars &&
          other.coins == this.coins &&
          other.totalLearningActivitiesCompleted ==
              this.totalLearningActivitiesCompleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ChildProgressesCompanion extends UpdateCompanion<ChildProgressRow> {
  final Value<String> childId;
  final Value<int> experiencePoints;
  final Value<int> stars;
  final Value<int> coins;
  final Value<int> totalLearningActivitiesCompleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ChildProgressesCompanion({
    this.childId = const Value.absent(),
    this.experiencePoints = const Value.absent(),
    this.stars = const Value.absent(),
    this.coins = const Value.absent(),
    this.totalLearningActivitiesCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChildProgressesCompanion.insert({
    required String childId,
    this.experiencePoints = const Value.absent(),
    this.stars = const Value.absent(),
    this.coins = const Value.absent(),
    this.totalLearningActivitiesCompleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : childId = Value(childId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ChildProgressRow> custom({
    Expression<String>? childId,
    Expression<int>? experiencePoints,
    Expression<int>? stars,
    Expression<int>? coins,
    Expression<int>? totalLearningActivitiesCompleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (childId != null) 'child_id': childId,
      if (experiencePoints != null) 'experience_points': experiencePoints,
      if (stars != null) 'stars': stars,
      if (coins != null) 'coins': coins,
      if (totalLearningActivitiesCompleted != null)
        'total_learning_activities_completed': totalLearningActivitiesCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChildProgressesCompanion copyWith({
    Value<String>? childId,
    Value<int>? experiencePoints,
    Value<int>? stars,
    Value<int>? coins,
    Value<int>? totalLearningActivitiesCompleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ChildProgressesCompanion(
      childId: childId ?? this.childId,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      stars: stars ?? this.stars,
      coins: coins ?? this.coins,
      totalLearningActivitiesCompleted:
          totalLearningActivitiesCompleted ??
          this.totalLearningActivitiesCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (childId.present) {
      map['child_id'] = Variable<String>(childId.value);
    }
    if (experiencePoints.present) {
      map['experience_points'] = Variable<int>(experiencePoints.value);
    }
    if (stars.present) {
      map['stars'] = Variable<int>(stars.value);
    }
    if (coins.present) {
      map['coins'] = Variable<int>(coins.value);
    }
    if (totalLearningActivitiesCompleted.present) {
      map['total_learning_activities_completed'] = Variable<int>(
        totalLearningActivitiesCompleted.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChildProgressesCompanion(')
          ..write('childId: $childId, ')
          ..write('experiencePoints: $experiencePoints, ')
          ..write('stars: $stars, ')
          ..write('coins: $coins, ')
          ..write(
            'totalLearningActivitiesCompleted: $totalLearningActivitiesCompleted, ',
          )
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MissionAttemptsTable extends MissionAttempts
    with TableInfo<$MissionAttemptsTable, MissionAttemptRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MissionAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<String> childId = GeneratedColumn<String>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES local_children (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _missionIdMeta = const VerificationMeta(
    'missionId',
  );
  @override
  late final GeneratedColumn<String> missionId = GeneratedColumn<String>(
    'mission_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _starsEarnedMeta = const VerificationMeta(
    'starsEarned',
  );
  @override
  late final GeneratedColumn<int> starsEarned = GeneratedColumn<int>(
    'stars_earned',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xpAwardedMeta = const VerificationMeta(
    'xpAwarded',
  );
  @override
  late final GeneratedColumn<int> xpAwarded = GeneratedColumn<int>(
    'xp_awarded',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coinsAwardedMeta = const VerificationMeta(
    'coinsAwarded',
  );
  @override
  late final GeneratedColumn<int> coinsAwarded = GeneratedColumn<int>(
    'coins_awarded',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptNumberMeta = const VerificationMeta(
    'attemptNumber',
  );
  @override
  late final GeneratedColumn<int> attemptNumber = GeneratedColumn<int>(
    'attempt_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    eventId,
    childId,
    missionId,
    worldId,
    score,
    starsEarned,
    xpAwarded,
    coinsAwarded,
    attemptNumber,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mission_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<MissionAttemptRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('mission_id')) {
      context.handle(
        _missionIdMeta,
        missionId.isAcceptableOrUnknown(data['mission_id']!, _missionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_missionIdMeta);
    }
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_worldIdMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('stars_earned')) {
      context.handle(
        _starsEarnedMeta,
        starsEarned.isAcceptableOrUnknown(
          data['stars_earned']!,
          _starsEarnedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_starsEarnedMeta);
    }
    if (data.containsKey('xp_awarded')) {
      context.handle(
        _xpAwardedMeta,
        xpAwarded.isAcceptableOrUnknown(data['xp_awarded']!, _xpAwardedMeta),
      );
    } else if (isInserting) {
      context.missing(_xpAwardedMeta);
    }
    if (data.containsKey('coins_awarded')) {
      context.handle(
        _coinsAwardedMeta,
        coinsAwarded.isAcceptableOrUnknown(
          data['coins_awarded']!,
          _coinsAwardedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_coinsAwardedMeta);
    }
    if (data.containsKey('attempt_number')) {
      context.handle(
        _attemptNumberMeta,
        attemptNumber.isAcceptableOrUnknown(
          data['attempt_number']!,
          _attemptNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attemptNumberMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventId};
  @override
  MissionAttemptRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MissionAttemptRow(
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_id'],
      )!,
      missionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mission_id'],
      )!,
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      ),
      starsEarned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stars_earned'],
      )!,
      xpAwarded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp_awarded'],
      )!,
      coinsAwarded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}coins_awarded'],
      )!,
      attemptNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_number'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
    );
  }

  @override
  $MissionAttemptsTable createAlias(String alias) {
    return $MissionAttemptsTable(attachedDatabase, alias);
  }
}

class MissionAttemptRow extends DataClass
    implements Insertable<MissionAttemptRow> {
  final String eventId;
  final String childId;
  final String missionId;
  final String worldId;
  final int? score;
  final int starsEarned;
  final int xpAwarded;
  final int coinsAwarded;
  final int attemptNumber;
  final DateTime completedAt;
  const MissionAttemptRow({
    required this.eventId,
    required this.childId,
    required this.missionId,
    required this.worldId,
    this.score,
    required this.starsEarned,
    required this.xpAwarded,
    required this.coinsAwarded,
    required this.attemptNumber,
    required this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_id'] = Variable<String>(eventId);
    map['child_id'] = Variable<String>(childId);
    map['mission_id'] = Variable<String>(missionId);
    map['world_id'] = Variable<String>(worldId);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    map['stars_earned'] = Variable<int>(starsEarned);
    map['xp_awarded'] = Variable<int>(xpAwarded);
    map['coins_awarded'] = Variable<int>(coinsAwarded);
    map['attempt_number'] = Variable<int>(attemptNumber);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  MissionAttemptsCompanion toCompanion(bool nullToAbsent) {
    return MissionAttemptsCompanion(
      eventId: Value(eventId),
      childId: Value(childId),
      missionId: Value(missionId),
      worldId: Value(worldId),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
      starsEarned: Value(starsEarned),
      xpAwarded: Value(xpAwarded),
      coinsAwarded: Value(coinsAwarded),
      attemptNumber: Value(attemptNumber),
      completedAt: Value(completedAt),
    );
  }

  factory MissionAttemptRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MissionAttemptRow(
      eventId: serializer.fromJson<String>(json['eventId']),
      childId: serializer.fromJson<String>(json['childId']),
      missionId: serializer.fromJson<String>(json['missionId']),
      worldId: serializer.fromJson<String>(json['worldId']),
      score: serializer.fromJson<int?>(json['score']),
      starsEarned: serializer.fromJson<int>(json['starsEarned']),
      xpAwarded: serializer.fromJson<int>(json['xpAwarded']),
      coinsAwarded: serializer.fromJson<int>(json['coinsAwarded']),
      attemptNumber: serializer.fromJson<int>(json['attemptNumber']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<String>(eventId),
      'childId': serializer.toJson<String>(childId),
      'missionId': serializer.toJson<String>(missionId),
      'worldId': serializer.toJson<String>(worldId),
      'score': serializer.toJson<int?>(score),
      'starsEarned': serializer.toJson<int>(starsEarned),
      'xpAwarded': serializer.toJson<int>(xpAwarded),
      'coinsAwarded': serializer.toJson<int>(coinsAwarded),
      'attemptNumber': serializer.toJson<int>(attemptNumber),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  MissionAttemptRow copyWith({
    String? eventId,
    String? childId,
    String? missionId,
    String? worldId,
    Value<int?> score = const Value.absent(),
    int? starsEarned,
    int? xpAwarded,
    int? coinsAwarded,
    int? attemptNumber,
    DateTime? completedAt,
  }) => MissionAttemptRow(
    eventId: eventId ?? this.eventId,
    childId: childId ?? this.childId,
    missionId: missionId ?? this.missionId,
    worldId: worldId ?? this.worldId,
    score: score.present ? score.value : this.score,
    starsEarned: starsEarned ?? this.starsEarned,
    xpAwarded: xpAwarded ?? this.xpAwarded,
    coinsAwarded: coinsAwarded ?? this.coinsAwarded,
    attemptNumber: attemptNumber ?? this.attemptNumber,
    completedAt: completedAt ?? this.completedAt,
  );
  MissionAttemptRow copyWithCompanion(MissionAttemptsCompanion data) {
    return MissionAttemptRow(
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      childId: data.childId.present ? data.childId.value : this.childId,
      missionId: data.missionId.present ? data.missionId.value : this.missionId,
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      score: data.score.present ? data.score.value : this.score,
      starsEarned: data.starsEarned.present
          ? data.starsEarned.value
          : this.starsEarned,
      xpAwarded: data.xpAwarded.present ? data.xpAwarded.value : this.xpAwarded,
      coinsAwarded: data.coinsAwarded.present
          ? data.coinsAwarded.value
          : this.coinsAwarded,
      attemptNumber: data.attemptNumber.present
          ? data.attemptNumber.value
          : this.attemptNumber,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MissionAttemptRow(')
          ..write('eventId: $eventId, ')
          ..write('childId: $childId, ')
          ..write('missionId: $missionId, ')
          ..write('worldId: $worldId, ')
          ..write('score: $score, ')
          ..write('starsEarned: $starsEarned, ')
          ..write('xpAwarded: $xpAwarded, ')
          ..write('coinsAwarded: $coinsAwarded, ')
          ..write('attemptNumber: $attemptNumber, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    eventId,
    childId,
    missionId,
    worldId,
    score,
    starsEarned,
    xpAwarded,
    coinsAwarded,
    attemptNumber,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MissionAttemptRow &&
          other.eventId == this.eventId &&
          other.childId == this.childId &&
          other.missionId == this.missionId &&
          other.worldId == this.worldId &&
          other.score == this.score &&
          other.starsEarned == this.starsEarned &&
          other.xpAwarded == this.xpAwarded &&
          other.coinsAwarded == this.coinsAwarded &&
          other.attemptNumber == this.attemptNumber &&
          other.completedAt == this.completedAt);
}

class MissionAttemptsCompanion extends UpdateCompanion<MissionAttemptRow> {
  final Value<String> eventId;
  final Value<String> childId;
  final Value<String> missionId;
  final Value<String> worldId;
  final Value<int?> score;
  final Value<int> starsEarned;
  final Value<int> xpAwarded;
  final Value<int> coinsAwarded;
  final Value<int> attemptNumber;
  final Value<DateTime> completedAt;
  final Value<int> rowid;
  const MissionAttemptsCompanion({
    this.eventId = const Value.absent(),
    this.childId = const Value.absent(),
    this.missionId = const Value.absent(),
    this.worldId = const Value.absent(),
    this.score = const Value.absent(),
    this.starsEarned = const Value.absent(),
    this.xpAwarded = const Value.absent(),
    this.coinsAwarded = const Value.absent(),
    this.attemptNumber = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MissionAttemptsCompanion.insert({
    required String eventId,
    required String childId,
    required String missionId,
    required String worldId,
    this.score = const Value.absent(),
    required int starsEarned,
    required int xpAwarded,
    required int coinsAwarded,
    required int attemptNumber,
    required DateTime completedAt,
    this.rowid = const Value.absent(),
  }) : eventId = Value(eventId),
       childId = Value(childId),
       missionId = Value(missionId),
       worldId = Value(worldId),
       starsEarned = Value(starsEarned),
       xpAwarded = Value(xpAwarded),
       coinsAwarded = Value(coinsAwarded),
       attemptNumber = Value(attemptNumber),
       completedAt = Value(completedAt);
  static Insertable<MissionAttemptRow> custom({
    Expression<String>? eventId,
    Expression<String>? childId,
    Expression<String>? missionId,
    Expression<String>? worldId,
    Expression<int>? score,
    Expression<int>? starsEarned,
    Expression<int>? xpAwarded,
    Expression<int>? coinsAwarded,
    Expression<int>? attemptNumber,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (childId != null) 'child_id': childId,
      if (missionId != null) 'mission_id': missionId,
      if (worldId != null) 'world_id': worldId,
      if (score != null) 'score': score,
      if (starsEarned != null) 'stars_earned': starsEarned,
      if (xpAwarded != null) 'xp_awarded': xpAwarded,
      if (coinsAwarded != null) 'coins_awarded': coinsAwarded,
      if (attemptNumber != null) 'attempt_number': attemptNumber,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MissionAttemptsCompanion copyWith({
    Value<String>? eventId,
    Value<String>? childId,
    Value<String>? missionId,
    Value<String>? worldId,
    Value<int?>? score,
    Value<int>? starsEarned,
    Value<int>? xpAwarded,
    Value<int>? coinsAwarded,
    Value<int>? attemptNumber,
    Value<DateTime>? completedAt,
    Value<int>? rowid,
  }) {
    return MissionAttemptsCompanion(
      eventId: eventId ?? this.eventId,
      childId: childId ?? this.childId,
      missionId: missionId ?? this.missionId,
      worldId: worldId ?? this.worldId,
      score: score ?? this.score,
      starsEarned: starsEarned ?? this.starsEarned,
      xpAwarded: xpAwarded ?? this.xpAwarded,
      coinsAwarded: coinsAwarded ?? this.coinsAwarded,
      attemptNumber: attemptNumber ?? this.attemptNumber,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (childId.present) {
      map['child_id'] = Variable<String>(childId.value);
    }
    if (missionId.present) {
      map['mission_id'] = Variable<String>(missionId.value);
    }
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (starsEarned.present) {
      map['stars_earned'] = Variable<int>(starsEarned.value);
    }
    if (xpAwarded.present) {
      map['xp_awarded'] = Variable<int>(xpAwarded.value);
    }
    if (coinsAwarded.present) {
      map['coins_awarded'] = Variable<int>(coinsAwarded.value);
    }
    if (attemptNumber.present) {
      map['attempt_number'] = Variable<int>(attemptNumber.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MissionAttemptsCompanion(')
          ..write('eventId: $eventId, ')
          ..write('childId: $childId, ')
          ..write('missionId: $missionId, ')
          ..write('worldId: $worldId, ')
          ..write('score: $score, ')
          ..write('starsEarned: $starsEarned, ')
          ..write('xpAwarded: $xpAwarded, ')
          ..write('coinsAwarded: $coinsAwarded, ')
          ..write('attemptNumber: $attemptNumber, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MissionBestResultsTable extends MissionBestResults
    with TableInfo<$MissionBestResultsTable, MissionBestResultRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MissionBestResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<String> childId = GeneratedColumn<String>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES local_children (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _missionIdMeta = const VerificationMeta(
    'missionId',
  );
  @override
  late final GeneratedColumn<String> missionId = GeneratedColumn<String>(
    'mission_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bestStarsMeta = const VerificationMeta(
    'bestStars',
  );
  @override
  late final GeneratedColumn<int> bestStars = GeneratedColumn<int>(
    'best_stars',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bestScoreMeta = const VerificationMeta(
    'bestScore',
  );
  @override
  late final GeneratedColumn<int> bestScore = GeneratedColumn<int>(
    'best_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firstCompletedAtMeta = const VerificationMeta(
    'firstCompletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> firstCompletedAt =
      GeneratedColumn<DateTime>(
        'first_completed_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _lastImprovedAtMeta = const VerificationMeta(
    'lastImprovedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastImprovedAt =
      GeneratedColumn<DateTime>(
        'last_improved_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    childId,
    missionId,
    worldId,
    bestStars,
    bestScore,
    firstCompletedAt,
    lastImprovedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mission_best_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<MissionBestResultRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('mission_id')) {
      context.handle(
        _missionIdMeta,
        missionId.isAcceptableOrUnknown(data['mission_id']!, _missionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_missionIdMeta);
    }
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_worldIdMeta);
    }
    if (data.containsKey('best_stars')) {
      context.handle(
        _bestStarsMeta,
        bestStars.isAcceptableOrUnknown(data['best_stars']!, _bestStarsMeta),
      );
    } else if (isInserting) {
      context.missing(_bestStarsMeta);
    }
    if (data.containsKey('best_score')) {
      context.handle(
        _bestScoreMeta,
        bestScore.isAcceptableOrUnknown(data['best_score']!, _bestScoreMeta),
      );
    }
    if (data.containsKey('first_completed_at')) {
      context.handle(
        _firstCompletedAtMeta,
        firstCompletedAt.isAcceptableOrUnknown(
          data['first_completed_at']!,
          _firstCompletedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstCompletedAtMeta);
    }
    if (data.containsKey('last_improved_at')) {
      context.handle(
        _lastImprovedAtMeta,
        lastImprovedAt.isAcceptableOrUnknown(
          data['last_improved_at']!,
          _lastImprovedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastImprovedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {childId, missionId};
  @override
  MissionBestResultRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MissionBestResultRow(
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_id'],
      )!,
      missionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mission_id'],
      )!,
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      )!,
      bestStars: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_stars'],
      )!,
      bestScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_score'],
      ),
      firstCompletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}first_completed_at'],
      )!,
      lastImprovedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_improved_at'],
      )!,
    );
  }

  @override
  $MissionBestResultsTable createAlias(String alias) {
    return $MissionBestResultsTable(attachedDatabase, alias);
  }
}

class MissionBestResultRow extends DataClass
    implements Insertable<MissionBestResultRow> {
  final String childId;
  final String missionId;
  final String worldId;
  final int bestStars;
  final int? bestScore;
  final DateTime firstCompletedAt;
  final DateTime lastImprovedAt;
  const MissionBestResultRow({
    required this.childId,
    required this.missionId,
    required this.worldId,
    required this.bestStars,
    this.bestScore,
    required this.firstCompletedAt,
    required this.lastImprovedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['child_id'] = Variable<String>(childId);
    map['mission_id'] = Variable<String>(missionId);
    map['world_id'] = Variable<String>(worldId);
    map['best_stars'] = Variable<int>(bestStars);
    if (!nullToAbsent || bestScore != null) {
      map['best_score'] = Variable<int>(bestScore);
    }
    map['first_completed_at'] = Variable<DateTime>(firstCompletedAt);
    map['last_improved_at'] = Variable<DateTime>(lastImprovedAt);
    return map;
  }

  MissionBestResultsCompanion toCompanion(bool nullToAbsent) {
    return MissionBestResultsCompanion(
      childId: Value(childId),
      missionId: Value(missionId),
      worldId: Value(worldId),
      bestStars: Value(bestStars),
      bestScore: bestScore == null && nullToAbsent
          ? const Value.absent()
          : Value(bestScore),
      firstCompletedAt: Value(firstCompletedAt),
      lastImprovedAt: Value(lastImprovedAt),
    );
  }

  factory MissionBestResultRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MissionBestResultRow(
      childId: serializer.fromJson<String>(json['childId']),
      missionId: serializer.fromJson<String>(json['missionId']),
      worldId: serializer.fromJson<String>(json['worldId']),
      bestStars: serializer.fromJson<int>(json['bestStars']),
      bestScore: serializer.fromJson<int?>(json['bestScore']),
      firstCompletedAt: serializer.fromJson<DateTime>(json['firstCompletedAt']),
      lastImprovedAt: serializer.fromJson<DateTime>(json['lastImprovedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'childId': serializer.toJson<String>(childId),
      'missionId': serializer.toJson<String>(missionId),
      'worldId': serializer.toJson<String>(worldId),
      'bestStars': serializer.toJson<int>(bestStars),
      'bestScore': serializer.toJson<int?>(bestScore),
      'firstCompletedAt': serializer.toJson<DateTime>(firstCompletedAt),
      'lastImprovedAt': serializer.toJson<DateTime>(lastImprovedAt),
    };
  }

  MissionBestResultRow copyWith({
    String? childId,
    String? missionId,
    String? worldId,
    int? bestStars,
    Value<int?> bestScore = const Value.absent(),
    DateTime? firstCompletedAt,
    DateTime? lastImprovedAt,
  }) => MissionBestResultRow(
    childId: childId ?? this.childId,
    missionId: missionId ?? this.missionId,
    worldId: worldId ?? this.worldId,
    bestStars: bestStars ?? this.bestStars,
    bestScore: bestScore.present ? bestScore.value : this.bestScore,
    firstCompletedAt: firstCompletedAt ?? this.firstCompletedAt,
    lastImprovedAt: lastImprovedAt ?? this.lastImprovedAt,
  );
  MissionBestResultRow copyWithCompanion(MissionBestResultsCompanion data) {
    return MissionBestResultRow(
      childId: data.childId.present ? data.childId.value : this.childId,
      missionId: data.missionId.present ? data.missionId.value : this.missionId,
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      bestStars: data.bestStars.present ? data.bestStars.value : this.bestStars,
      bestScore: data.bestScore.present ? data.bestScore.value : this.bestScore,
      firstCompletedAt: data.firstCompletedAt.present
          ? data.firstCompletedAt.value
          : this.firstCompletedAt,
      lastImprovedAt: data.lastImprovedAt.present
          ? data.lastImprovedAt.value
          : this.lastImprovedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MissionBestResultRow(')
          ..write('childId: $childId, ')
          ..write('missionId: $missionId, ')
          ..write('worldId: $worldId, ')
          ..write('bestStars: $bestStars, ')
          ..write('bestScore: $bestScore, ')
          ..write('firstCompletedAt: $firstCompletedAt, ')
          ..write('lastImprovedAt: $lastImprovedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    childId,
    missionId,
    worldId,
    bestStars,
    bestScore,
    firstCompletedAt,
    lastImprovedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MissionBestResultRow &&
          other.childId == this.childId &&
          other.missionId == this.missionId &&
          other.worldId == this.worldId &&
          other.bestStars == this.bestStars &&
          other.bestScore == this.bestScore &&
          other.firstCompletedAt == this.firstCompletedAt &&
          other.lastImprovedAt == this.lastImprovedAt);
}

class MissionBestResultsCompanion
    extends UpdateCompanion<MissionBestResultRow> {
  final Value<String> childId;
  final Value<String> missionId;
  final Value<String> worldId;
  final Value<int> bestStars;
  final Value<int?> bestScore;
  final Value<DateTime> firstCompletedAt;
  final Value<DateTime> lastImprovedAt;
  final Value<int> rowid;
  const MissionBestResultsCompanion({
    this.childId = const Value.absent(),
    this.missionId = const Value.absent(),
    this.worldId = const Value.absent(),
    this.bestStars = const Value.absent(),
    this.bestScore = const Value.absent(),
    this.firstCompletedAt = const Value.absent(),
    this.lastImprovedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MissionBestResultsCompanion.insert({
    required String childId,
    required String missionId,
    required String worldId,
    required int bestStars,
    this.bestScore = const Value.absent(),
    required DateTime firstCompletedAt,
    required DateTime lastImprovedAt,
    this.rowid = const Value.absent(),
  }) : childId = Value(childId),
       missionId = Value(missionId),
       worldId = Value(worldId),
       bestStars = Value(bestStars),
       firstCompletedAt = Value(firstCompletedAt),
       lastImprovedAt = Value(lastImprovedAt);
  static Insertable<MissionBestResultRow> custom({
    Expression<String>? childId,
    Expression<String>? missionId,
    Expression<String>? worldId,
    Expression<int>? bestStars,
    Expression<int>? bestScore,
    Expression<DateTime>? firstCompletedAt,
    Expression<DateTime>? lastImprovedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (childId != null) 'child_id': childId,
      if (missionId != null) 'mission_id': missionId,
      if (worldId != null) 'world_id': worldId,
      if (bestStars != null) 'best_stars': bestStars,
      if (bestScore != null) 'best_score': bestScore,
      if (firstCompletedAt != null) 'first_completed_at': firstCompletedAt,
      if (lastImprovedAt != null) 'last_improved_at': lastImprovedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MissionBestResultsCompanion copyWith({
    Value<String>? childId,
    Value<String>? missionId,
    Value<String>? worldId,
    Value<int>? bestStars,
    Value<int?>? bestScore,
    Value<DateTime>? firstCompletedAt,
    Value<DateTime>? lastImprovedAt,
    Value<int>? rowid,
  }) {
    return MissionBestResultsCompanion(
      childId: childId ?? this.childId,
      missionId: missionId ?? this.missionId,
      worldId: worldId ?? this.worldId,
      bestStars: bestStars ?? this.bestStars,
      bestScore: bestScore ?? this.bestScore,
      firstCompletedAt: firstCompletedAt ?? this.firstCompletedAt,
      lastImprovedAt: lastImprovedAt ?? this.lastImprovedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (childId.present) {
      map['child_id'] = Variable<String>(childId.value);
    }
    if (missionId.present) {
      map['mission_id'] = Variable<String>(missionId.value);
    }
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (bestStars.present) {
      map['best_stars'] = Variable<int>(bestStars.value);
    }
    if (bestScore.present) {
      map['best_score'] = Variable<int>(bestScore.value);
    }
    if (firstCompletedAt.present) {
      map['first_completed_at'] = Variable<DateTime>(firstCompletedAt.value);
    }
    if (lastImprovedAt.present) {
      map['last_improved_at'] = Variable<DateTime>(lastImprovedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MissionBestResultsCompanion(')
          ..write('childId: $childId, ')
          ..write('missionId: $missionId, ')
          ..write('worldId: $worldId, ')
          ..write('bestStars: $bestStars, ')
          ..write('bestScore: $bestScore, ')
          ..write('firstCompletedAt: $firstCompletedAt, ')
          ..write('lastImprovedAt: $lastImprovedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RewardTransactionsTable extends RewardTransactions
    with TableInfo<$RewardTransactionsTable, RewardTransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RewardTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<String> childId = GeneratedColumn<String>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES local_children (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    childId,
    type,
    amount,
    sourceType,
    sourceId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reward_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<RewardTransactionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {childId, type, sourceType, sourceId},
  ];
  @override
  RewardTransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RewardTransactionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RewardTransactionsTable createAlias(String alias) {
    return $RewardTransactionsTable(attachedDatabase, alias);
  }
}

class RewardTransactionRow extends DataClass
    implements Insertable<RewardTransactionRow> {
  final String id;
  final String childId;
  final String type;
  final int amount;
  final String sourceType;
  final String sourceId;
  final DateTime createdAt;
  const RewardTransactionRow({
    required this.id,
    required this.childId,
    required this.type,
    required this.amount,
    required this.sourceType,
    required this.sourceId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['child_id'] = Variable<String>(childId);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<int>(amount);
    map['source_type'] = Variable<String>(sourceType);
    map['source_id'] = Variable<String>(sourceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RewardTransactionsCompanion toCompanion(bool nullToAbsent) {
    return RewardTransactionsCompanion(
      id: Value(id),
      childId: Value(childId),
      type: Value(type),
      amount: Value(amount),
      sourceType: Value(sourceType),
      sourceId: Value(sourceId),
      createdAt: Value(createdAt),
    );
  }

  factory RewardTransactionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RewardTransactionRow(
      id: serializer.fromJson<String>(json['id']),
      childId: serializer.fromJson<String>(json['childId']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<int>(json['amount']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'childId': serializer.toJson<String>(childId),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<int>(amount),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceId': serializer.toJson<String>(sourceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RewardTransactionRow copyWith({
    String? id,
    String? childId,
    String? type,
    int? amount,
    String? sourceType,
    String? sourceId,
    DateTime? createdAt,
  }) => RewardTransactionRow(
    id: id ?? this.id,
    childId: childId ?? this.childId,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    sourceType: sourceType ?? this.sourceType,
    sourceId: sourceId ?? this.sourceId,
    createdAt: createdAt ?? this.createdAt,
  );
  RewardTransactionRow copyWithCompanion(RewardTransactionsCompanion data) {
    return RewardTransactionRow(
      id: data.id.present ? data.id.value : this.id,
      childId: data.childId.present ? data.childId.value : this.childId,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RewardTransactionRow(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, childId, type, amount, sourceType, sourceId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RewardTransactionRow &&
          other.id == this.id &&
          other.childId == this.childId &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.sourceType == this.sourceType &&
          other.sourceId == this.sourceId &&
          other.createdAt == this.createdAt);
}

class RewardTransactionsCompanion
    extends UpdateCompanion<RewardTransactionRow> {
  final Value<String> id;
  final Value<String> childId;
  final Value<String> type;
  final Value<int> amount;
  final Value<String> sourceType;
  final Value<String> sourceId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RewardTransactionsCompanion({
    this.id = const Value.absent(),
    this.childId = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RewardTransactionsCompanion.insert({
    required String id,
    required String childId,
    required String type,
    required int amount,
    required String sourceType,
    required String sourceId,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       childId = Value(childId),
       type = Value(type),
       amount = Value(amount),
       sourceType = Value(sourceType),
       sourceId = Value(sourceId),
       createdAt = Value(createdAt);
  static Insertable<RewardTransactionRow> custom({
    Expression<String>? id,
    Expression<String>? childId,
    Expression<String>? type,
    Expression<int>? amount,
    Expression<String>? sourceType,
    Expression<String>? sourceId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (childId != null) 'child_id': childId,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceId != null) 'source_id': sourceId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RewardTransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? childId,
    Value<String>? type,
    Value<int>? amount,
    Value<String>? sourceType,
    Value<String>? sourceId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RewardTransactionsCompanion(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (childId.present) {
      map['child_id'] = Variable<String>(childId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RewardTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChildAchievementsTable extends ChildAchievements
    with TableInfo<$ChildAchievementsTable, ChildAchievementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChildAchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<String> childId = GeneratedColumn<String>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES local_children (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _achievementIdMeta = const VerificationMeta(
    'achievementId',
  );
  @override
  late final GeneratedColumn<String> achievementId = GeneratedColumn<String>(
    'achievement_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _earnedAtMeta = const VerificationMeta(
    'earnedAt',
  );
  @override
  late final GeneratedColumn<DateTime> earnedAt = GeneratedColumn<DateTime>(
    'earned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [childId, achievementId, earnedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'child_achievements';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChildAchievementRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('achievement_id')) {
      context.handle(
        _achievementIdMeta,
        achievementId.isAcceptableOrUnknown(
          data['achievement_id']!,
          _achievementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_achievementIdMeta);
    }
    if (data.containsKey('earned_at')) {
      context.handle(
        _earnedAtMeta,
        earnedAt.isAcceptableOrUnknown(data['earned_at']!, _earnedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_earnedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {childId, achievementId};
  @override
  ChildAchievementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChildAchievementRow(
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_id'],
      )!,
      achievementId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}achievement_id'],
      )!,
      earnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}earned_at'],
      )!,
    );
  }

  @override
  $ChildAchievementsTable createAlias(String alias) {
    return $ChildAchievementsTable(attachedDatabase, alias);
  }
}

class ChildAchievementRow extends DataClass
    implements Insertable<ChildAchievementRow> {
  final String childId;
  final String achievementId;
  final DateTime earnedAt;
  const ChildAchievementRow({
    required this.childId,
    required this.achievementId,
    required this.earnedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['child_id'] = Variable<String>(childId);
    map['achievement_id'] = Variable<String>(achievementId);
    map['earned_at'] = Variable<DateTime>(earnedAt);
    return map;
  }

  ChildAchievementsCompanion toCompanion(bool nullToAbsent) {
    return ChildAchievementsCompanion(
      childId: Value(childId),
      achievementId: Value(achievementId),
      earnedAt: Value(earnedAt),
    );
  }

  factory ChildAchievementRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChildAchievementRow(
      childId: serializer.fromJson<String>(json['childId']),
      achievementId: serializer.fromJson<String>(json['achievementId']),
      earnedAt: serializer.fromJson<DateTime>(json['earnedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'childId': serializer.toJson<String>(childId),
      'achievementId': serializer.toJson<String>(achievementId),
      'earnedAt': serializer.toJson<DateTime>(earnedAt),
    };
  }

  ChildAchievementRow copyWith({
    String? childId,
    String? achievementId,
    DateTime? earnedAt,
  }) => ChildAchievementRow(
    childId: childId ?? this.childId,
    achievementId: achievementId ?? this.achievementId,
    earnedAt: earnedAt ?? this.earnedAt,
  );
  ChildAchievementRow copyWithCompanion(ChildAchievementsCompanion data) {
    return ChildAchievementRow(
      childId: data.childId.present ? data.childId.value : this.childId,
      achievementId: data.achievementId.present
          ? data.achievementId.value
          : this.achievementId,
      earnedAt: data.earnedAt.present ? data.earnedAt.value : this.earnedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChildAchievementRow(')
          ..write('childId: $childId, ')
          ..write('achievementId: $achievementId, ')
          ..write('earnedAt: $earnedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(childId, achievementId, earnedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChildAchievementRow &&
          other.childId == this.childId &&
          other.achievementId == this.achievementId &&
          other.earnedAt == this.earnedAt);
}

class ChildAchievementsCompanion extends UpdateCompanion<ChildAchievementRow> {
  final Value<String> childId;
  final Value<String> achievementId;
  final Value<DateTime> earnedAt;
  final Value<int> rowid;
  const ChildAchievementsCompanion({
    this.childId = const Value.absent(),
    this.achievementId = const Value.absent(),
    this.earnedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChildAchievementsCompanion.insert({
    required String childId,
    required String achievementId,
    required DateTime earnedAt,
    this.rowid = const Value.absent(),
  }) : childId = Value(childId),
       achievementId = Value(achievementId),
       earnedAt = Value(earnedAt);
  static Insertable<ChildAchievementRow> custom({
    Expression<String>? childId,
    Expression<String>? achievementId,
    Expression<DateTime>? earnedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (childId != null) 'child_id': childId,
      if (achievementId != null) 'achievement_id': achievementId,
      if (earnedAt != null) 'earned_at': earnedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChildAchievementsCompanion copyWith({
    Value<String>? childId,
    Value<String>? achievementId,
    Value<DateTime>? earnedAt,
    Value<int>? rowid,
  }) {
    return ChildAchievementsCompanion(
      childId: childId ?? this.childId,
      achievementId: achievementId ?? this.achievementId,
      earnedAt: earnedAt ?? this.earnedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (childId.present) {
      map['child_id'] = Variable<String>(childId.value);
    }
    if (achievementId.present) {
      map['achievement_id'] = Variable<String>(achievementId.value);
    }
    if (earnedAt.present) {
      map['earned_at'] = Variable<DateTime>(earnedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChildAchievementsCompanion(')
          ..write('childId: $childId, ')
          ..write('achievementId: $achievementId, ')
          ..write('earnedAt: $earnedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ProfileDatabase extends GeneratedDatabase {
  _$ProfileDatabase(QueryExecutor e) : super(e);
  $ProfileDatabaseManager get managers => $ProfileDatabaseManager(this);
  late final $LocalParentsTable localParents = $LocalParentsTable(this);
  late final $LocalChildrenTable localChildren = $LocalChildrenTable(this);
  late final $LocalSetupTable localSetup = $LocalSetupTable(this);
  late final $ChildProgressesTable childProgresses = $ChildProgressesTable(
    this,
  );
  late final $MissionAttemptsTable missionAttempts = $MissionAttemptsTable(
    this,
  );
  late final $MissionBestResultsTable missionBestResults =
      $MissionBestResultsTable(this);
  late final $RewardTransactionsTable rewardTransactions =
      $RewardTransactionsTable(this);
  late final $ChildAchievementsTable childAchievements =
      $ChildAchievementsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localParents,
    localChildren,
    localSetup,
    childProgresses,
    missionAttempts,
    missionBestResults,
    rewardTransactions,
    childAchievements,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_children',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('child_progresses', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_children',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('mission_attempts', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_children',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('mission_best_results', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_children',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reward_transactions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_children',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('child_achievements', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$LocalParentsTableCreateCompanionBuilder =
    LocalParentsCompanion Function({
      required String id,
      Value<int> singleton,
      Value<String?> displayName,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LocalParentsTableUpdateCompanionBuilder =
    LocalParentsCompanion Function({
      Value<String> id,
      Value<int> singleton,
      Value<String?> displayName,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$LocalParentsTableReferences
    extends BaseReferences<_$ProfileDatabase, $LocalParentsTable, ParentRow> {
  $$LocalParentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LocalChildrenTable, List<ChildRow>>
  _localChildrenRefsTable(_$ProfileDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.localChildren,
        aliasName: $_aliasNameGenerator(
          db.localParents.id,
          db.localChildren.parentId,
        ),
      );

  $$LocalChildrenTableProcessedTableManager get localChildrenRefs {
    final manager = $$LocalChildrenTableTableManager(
      $_db,
      $_db.localChildren,
    ).filter((f) => f.parentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_localChildrenRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LocalParentsTableFilterComposer
    extends Composer<_$ProfileDatabase, $LocalParentsTable> {
  $$LocalParentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get singleton => $composableBuilder(
    column: $table.singleton,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> localChildrenRefs(
    Expression<bool> Function($$LocalChildrenTableFilterComposer f) f,
  ) {
    final $$LocalChildrenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.localChildren,
      getReferencedColumn: (t) => t.parentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalChildrenTableFilterComposer(
            $db: $db,
            $table: $db.localChildren,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocalParentsTableOrderingComposer
    extends Composer<_$ProfileDatabase, $LocalParentsTable> {
  $$LocalParentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get singleton => $composableBuilder(
    column: $table.singleton,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalParentsTableAnnotationComposer
    extends Composer<_$ProfileDatabase, $LocalParentsTable> {
  $$LocalParentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get singleton =>
      $composableBuilder(column: $table.singleton, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> localChildrenRefs<T extends Object>(
    Expression<T> Function($$LocalChildrenTableAnnotationComposer a) f,
  ) {
    final $$LocalChildrenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.localChildren,
      getReferencedColumn: (t) => t.parentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalChildrenTableAnnotationComposer(
            $db: $db,
            $table: $db.localChildren,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocalParentsTableTableManager
    extends
        RootTableManager<
          _$ProfileDatabase,
          $LocalParentsTable,
          ParentRow,
          $$LocalParentsTableFilterComposer,
          $$LocalParentsTableOrderingComposer,
          $$LocalParentsTableAnnotationComposer,
          $$LocalParentsTableCreateCompanionBuilder,
          $$LocalParentsTableUpdateCompanionBuilder,
          (ParentRow, $$LocalParentsTableReferences),
          ParentRow,
          PrefetchHooks Function({bool localChildrenRefs})
        > {
  $$LocalParentsTableTableManager(
    _$ProfileDatabase db,
    $LocalParentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalParentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalParentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalParentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> singleton = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalParentsCompanion(
                id: id,
                singleton: singleton,
                displayName: displayName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int> singleton = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalParentsCompanion.insert(
                id: id,
                singleton: singleton,
                displayName: displayName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LocalParentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({localChildrenRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (localChildrenRefs) db.localChildren,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (localChildrenRefs)
                    await $_getPrefetchedData<
                      ParentRow,
                      $LocalParentsTable,
                      ChildRow
                    >(
                      currentTable: table,
                      referencedTable: $$LocalParentsTableReferences
                          ._localChildrenRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LocalParentsTableReferences(
                            db,
                            table,
                            p0,
                          ).localChildrenRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.parentId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LocalParentsTableProcessedTableManager =
    ProcessedTableManager<
      _$ProfileDatabase,
      $LocalParentsTable,
      ParentRow,
      $$LocalParentsTableFilterComposer,
      $$LocalParentsTableOrderingComposer,
      $$LocalParentsTableAnnotationComposer,
      $$LocalParentsTableCreateCompanionBuilder,
      $$LocalParentsTableUpdateCompanionBuilder,
      (ParentRow, $$LocalParentsTableReferences),
      ParentRow,
      PrefetchHooks Function({bool localChildrenRefs})
    >;
typedef $$LocalChildrenTableCreateCompanionBuilder =
    LocalChildrenCompanion Function({
      required String id,
      required String parentId,
      required String displayName,
      required int startingAge,
      required String avatarId,
      required String language,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LocalChildrenTableUpdateCompanionBuilder =
    LocalChildrenCompanion Function({
      Value<String> id,
      Value<String> parentId,
      Value<String> displayName,
      Value<int> startingAge,
      Value<String> avatarId,
      Value<String> language,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$LocalChildrenTableReferences
    extends BaseReferences<_$ProfileDatabase, $LocalChildrenTable, ChildRow> {
  $$LocalChildrenTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LocalParentsTable _parentIdTable(_$ProfileDatabase db) =>
      db.localParents.createAlias(
        $_aliasNameGenerator(db.localChildren.parentId, db.localParents.id),
      );

  $$LocalParentsTableProcessedTableManager get parentId {
    final $_column = $_itemColumn<String>('parent_id')!;

    final manager = $$LocalParentsTableTableManager(
      $_db,
      $_db.localParents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ChildProgressesTable, List<ChildProgressRow>>
  _childProgressesRefsTable(_$ProfileDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.childProgresses,
        aliasName: $_aliasNameGenerator(
          db.localChildren.id,
          db.childProgresses.childId,
        ),
      );

  $$ChildProgressesTableProcessedTableManager get childProgressesRefs {
    final manager = $$ChildProgressesTableTableManager(
      $_db,
      $_db.childProgresses,
    ).filter((f) => f.childId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _childProgressesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MissionAttemptsTable, List<MissionAttemptRow>>
  _missionAttemptsRefsTable(_$ProfileDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.missionAttempts,
        aliasName: $_aliasNameGenerator(
          db.localChildren.id,
          db.missionAttempts.childId,
        ),
      );

  $$MissionAttemptsTableProcessedTableManager get missionAttemptsRefs {
    final manager = $$MissionAttemptsTableTableManager(
      $_db,
      $_db.missionAttempts,
    ).filter((f) => f.childId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _missionAttemptsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MissionBestResultsTable,
    List<MissionBestResultRow>
  >
  _missionBestResultsRefsTable(_$ProfileDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.missionBestResults,
        aliasName: $_aliasNameGenerator(
          db.localChildren.id,
          db.missionBestResults.childId,
        ),
      );

  $$MissionBestResultsTableProcessedTableManager get missionBestResultsRefs {
    final manager = $$MissionBestResultsTableTableManager(
      $_db,
      $_db.missionBestResults,
    ).filter((f) => f.childId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _missionBestResultsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RewardTransactionsTable,
    List<RewardTransactionRow>
  >
  _rewardTransactionsRefsTable(_$ProfileDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.rewardTransactions,
        aliasName: $_aliasNameGenerator(
          db.localChildren.id,
          db.rewardTransactions.childId,
        ),
      );

  $$RewardTransactionsTableProcessedTableManager get rewardTransactionsRefs {
    final manager = $$RewardTransactionsTableTableManager(
      $_db,
      $_db.rewardTransactions,
    ).filter((f) => f.childId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _rewardTransactionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ChildAchievementsTable, List<ChildAchievementRow>>
  _childAchievementsRefsTable(_$ProfileDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.childAchievements,
        aliasName: $_aliasNameGenerator(
          db.localChildren.id,
          db.childAchievements.childId,
        ),
      );

  $$ChildAchievementsTableProcessedTableManager get childAchievementsRefs {
    final manager = $$ChildAchievementsTableTableManager(
      $_db,
      $_db.childAchievements,
    ).filter((f) => f.childId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _childAchievementsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LocalChildrenTableFilterComposer
    extends Composer<_$ProfileDatabase, $LocalChildrenTable> {
  $$LocalChildrenTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startingAge => $composableBuilder(
    column: $table.startingAge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarId => $composableBuilder(
    column: $table.avatarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LocalParentsTableFilterComposer get parentId {
    final $$LocalParentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.localParents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalParentsTableFilterComposer(
            $db: $db,
            $table: $db.localParents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> childProgressesRefs(
    Expression<bool> Function($$ChildProgressesTableFilterComposer f) f,
  ) {
    final $$ChildProgressesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.childProgresses,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProgressesTableFilterComposer(
            $db: $db,
            $table: $db.childProgresses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> missionAttemptsRefs(
    Expression<bool> Function($$MissionAttemptsTableFilterComposer f) f,
  ) {
    final $$MissionAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.missionAttempts,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MissionAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.missionAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> missionBestResultsRefs(
    Expression<bool> Function($$MissionBestResultsTableFilterComposer f) f,
  ) {
    final $$MissionBestResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.missionBestResults,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MissionBestResultsTableFilterComposer(
            $db: $db,
            $table: $db.missionBestResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> rewardTransactionsRefs(
    Expression<bool> Function($$RewardTransactionsTableFilterComposer f) f,
  ) {
    final $$RewardTransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rewardTransactions,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardTransactionsTableFilterComposer(
            $db: $db,
            $table: $db.rewardTransactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> childAchievementsRefs(
    Expression<bool> Function($$ChildAchievementsTableFilterComposer f) f,
  ) {
    final $$ChildAchievementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.childAchievements,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildAchievementsTableFilterComposer(
            $db: $db,
            $table: $db.childAchievements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocalChildrenTableOrderingComposer
    extends Composer<_$ProfileDatabase, $LocalChildrenTable> {
  $$LocalChildrenTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startingAge => $composableBuilder(
    column: $table.startingAge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarId => $composableBuilder(
    column: $table.avatarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocalParentsTableOrderingComposer get parentId {
    final $$LocalParentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.localParents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalParentsTableOrderingComposer(
            $db: $db,
            $table: $db.localParents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalChildrenTableAnnotationComposer
    extends Composer<_$ProfileDatabase, $LocalChildrenTable> {
  $$LocalChildrenTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startingAge => $composableBuilder(
    column: $table.startingAge,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avatarId =>
      $composableBuilder(column: $table.avatarId, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$LocalParentsTableAnnotationComposer get parentId {
    final $$LocalParentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.localParents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalParentsTableAnnotationComposer(
            $db: $db,
            $table: $db.localParents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> childProgressesRefs<T extends Object>(
    Expression<T> Function($$ChildProgressesTableAnnotationComposer a) f,
  ) {
    final $$ChildProgressesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.childProgresses,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProgressesTableAnnotationComposer(
            $db: $db,
            $table: $db.childProgresses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> missionAttemptsRefs<T extends Object>(
    Expression<T> Function($$MissionAttemptsTableAnnotationComposer a) f,
  ) {
    final $$MissionAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.missionAttempts,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MissionAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.missionAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> missionBestResultsRefs<T extends Object>(
    Expression<T> Function($$MissionBestResultsTableAnnotationComposer a) f,
  ) {
    final $$MissionBestResultsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.missionBestResults,
          getReferencedColumn: (t) => t.childId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MissionBestResultsTableAnnotationComposer(
                $db: $db,
                $table: $db.missionBestResults,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> rewardTransactionsRefs<T extends Object>(
    Expression<T> Function($$RewardTransactionsTableAnnotationComposer a) f,
  ) {
    final $$RewardTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.rewardTransactions,
          getReferencedColumn: (t) => t.childId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RewardTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.rewardTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> childAchievementsRefs<T extends Object>(
    Expression<T> Function($$ChildAchievementsTableAnnotationComposer a) f,
  ) {
    final $$ChildAchievementsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.childAchievements,
          getReferencedColumn: (t) => t.childId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ChildAchievementsTableAnnotationComposer(
                $db: $db,
                $table: $db.childAchievements,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LocalChildrenTableTableManager
    extends
        RootTableManager<
          _$ProfileDatabase,
          $LocalChildrenTable,
          ChildRow,
          $$LocalChildrenTableFilterComposer,
          $$LocalChildrenTableOrderingComposer,
          $$LocalChildrenTableAnnotationComposer,
          $$LocalChildrenTableCreateCompanionBuilder,
          $$LocalChildrenTableUpdateCompanionBuilder,
          (ChildRow, $$LocalChildrenTableReferences),
          ChildRow,
          PrefetchHooks Function({
            bool parentId,
            bool childProgressesRefs,
            bool missionAttemptsRefs,
            bool missionBestResultsRefs,
            bool rewardTransactionsRefs,
            bool childAchievementsRefs,
          })
        > {
  $$LocalChildrenTableTableManager(
    _$ProfileDatabase db,
    $LocalChildrenTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalChildrenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalChildrenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalChildrenTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> parentId = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<int> startingAge = const Value.absent(),
                Value<String> avatarId = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalChildrenCompanion(
                id: id,
                parentId: parentId,
                displayName: displayName,
                startingAge: startingAge,
                avatarId: avatarId,
                language: language,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String parentId,
                required String displayName,
                required int startingAge,
                required String avatarId,
                required String language,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalChildrenCompanion.insert(
                id: id,
                parentId: parentId,
                displayName: displayName,
                startingAge: startingAge,
                avatarId: avatarId,
                language: language,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LocalChildrenTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                parentId = false,
                childProgressesRefs = false,
                missionAttemptsRefs = false,
                missionBestResultsRefs = false,
                rewardTransactionsRefs = false,
                childAchievementsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (childProgressesRefs) db.childProgresses,
                    if (missionAttemptsRefs) db.missionAttempts,
                    if (missionBestResultsRefs) db.missionBestResults,
                    if (rewardTransactionsRefs) db.rewardTransactions,
                    if (childAchievementsRefs) db.childAchievements,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (parentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.parentId,
                                    referencedTable:
                                        $$LocalChildrenTableReferences
                                            ._parentIdTable(db),
                                    referencedColumn:
                                        $$LocalChildrenTableReferences
                                            ._parentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (childProgressesRefs)
                        await $_getPrefetchedData<
                          ChildRow,
                          $LocalChildrenTable,
                          ChildProgressRow
                        >(
                          currentTable: table,
                          referencedTable: $$LocalChildrenTableReferences
                              ._childProgressesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocalChildrenTableReferences(
                                db,
                                table,
                                p0,
                              ).childProgressesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.childId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (missionAttemptsRefs)
                        await $_getPrefetchedData<
                          ChildRow,
                          $LocalChildrenTable,
                          MissionAttemptRow
                        >(
                          currentTable: table,
                          referencedTable: $$LocalChildrenTableReferences
                              ._missionAttemptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocalChildrenTableReferences(
                                db,
                                table,
                                p0,
                              ).missionAttemptsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.childId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (missionBestResultsRefs)
                        await $_getPrefetchedData<
                          ChildRow,
                          $LocalChildrenTable,
                          MissionBestResultRow
                        >(
                          currentTable: table,
                          referencedTable: $$LocalChildrenTableReferences
                              ._missionBestResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocalChildrenTableReferences(
                                db,
                                table,
                                p0,
                              ).missionBestResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.childId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (rewardTransactionsRefs)
                        await $_getPrefetchedData<
                          ChildRow,
                          $LocalChildrenTable,
                          RewardTransactionRow
                        >(
                          currentTable: table,
                          referencedTable: $$LocalChildrenTableReferences
                              ._rewardTransactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocalChildrenTableReferences(
                                db,
                                table,
                                p0,
                              ).rewardTransactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.childId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (childAchievementsRefs)
                        await $_getPrefetchedData<
                          ChildRow,
                          $LocalChildrenTable,
                          ChildAchievementRow
                        >(
                          currentTable: table,
                          referencedTable: $$LocalChildrenTableReferences
                              ._childAchievementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocalChildrenTableReferences(
                                db,
                                table,
                                p0,
                              ).childAchievementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.childId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LocalChildrenTableProcessedTableManager =
    ProcessedTableManager<
      _$ProfileDatabase,
      $LocalChildrenTable,
      ChildRow,
      $$LocalChildrenTableFilterComposer,
      $$LocalChildrenTableOrderingComposer,
      $$LocalChildrenTableAnnotationComposer,
      $$LocalChildrenTableCreateCompanionBuilder,
      $$LocalChildrenTableUpdateCompanionBuilder,
      (ChildRow, $$LocalChildrenTableReferences),
      ChildRow,
      PrefetchHooks Function({
        bool parentId,
        bool childProgressesRefs,
        bool missionAttemptsRefs,
        bool missionBestResultsRefs,
        bool rewardTransactionsRefs,
        bool childAchievementsRefs,
      })
    >;
typedef $$LocalSetupTableCreateCompanionBuilder =
    LocalSetupCompanion Function({Value<int> id, required bool completed});
typedef $$LocalSetupTableUpdateCompanionBuilder =
    LocalSetupCompanion Function({Value<int> id, Value<bool> completed});

class $$LocalSetupTableFilterComposer
    extends Composer<_$ProfileDatabase, $LocalSetupTable> {
  $$LocalSetupTableFilterComposer({
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

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalSetupTableOrderingComposer
    extends Composer<_$ProfileDatabase, $LocalSetupTable> {
  $$LocalSetupTableOrderingComposer({
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

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalSetupTableAnnotationComposer
    extends Composer<_$ProfileDatabase, $LocalSetupTable> {
  $$LocalSetupTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);
}

class $$LocalSetupTableTableManager
    extends
        RootTableManager<
          _$ProfileDatabase,
          $LocalSetupTable,
          SetupRow,
          $$LocalSetupTableFilterComposer,
          $$LocalSetupTableOrderingComposer,
          $$LocalSetupTableAnnotationComposer,
          $$LocalSetupTableCreateCompanionBuilder,
          $$LocalSetupTableUpdateCompanionBuilder,
          (
            SetupRow,
            BaseReferences<_$ProfileDatabase, $LocalSetupTable, SetupRow>,
          ),
          SetupRow,
          PrefetchHooks Function()
        > {
  $$LocalSetupTableTableManager(_$ProfileDatabase db, $LocalSetupTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSetupTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSetupTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSetupTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> completed = const Value.absent(),
              }) => LocalSetupCompanion(id: id, completed: completed),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required bool completed,
              }) => LocalSetupCompanion.insert(id: id, completed: completed),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalSetupTableProcessedTableManager =
    ProcessedTableManager<
      _$ProfileDatabase,
      $LocalSetupTable,
      SetupRow,
      $$LocalSetupTableFilterComposer,
      $$LocalSetupTableOrderingComposer,
      $$LocalSetupTableAnnotationComposer,
      $$LocalSetupTableCreateCompanionBuilder,
      $$LocalSetupTableUpdateCompanionBuilder,
      (SetupRow, BaseReferences<_$ProfileDatabase, $LocalSetupTable, SetupRow>),
      SetupRow,
      PrefetchHooks Function()
    >;
typedef $$ChildProgressesTableCreateCompanionBuilder =
    ChildProgressesCompanion Function({
      required String childId,
      Value<int> experiencePoints,
      Value<int> stars,
      Value<int> coins,
      Value<int> totalLearningActivitiesCompleted,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ChildProgressesTableUpdateCompanionBuilder =
    ChildProgressesCompanion Function({
      Value<String> childId,
      Value<int> experiencePoints,
      Value<int> stars,
      Value<int> coins,
      Value<int> totalLearningActivitiesCompleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ChildProgressesTableReferences
    extends
        BaseReferences<
          _$ProfileDatabase,
          $ChildProgressesTable,
          ChildProgressRow
        > {
  $$ChildProgressesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LocalChildrenTable _childIdTable(_$ProfileDatabase db) =>
      db.localChildren.createAlias(
        $_aliasNameGenerator(db.childProgresses.childId, db.localChildren.id),
      );

  $$LocalChildrenTableProcessedTableManager get childId {
    final $_column = $_itemColumn<String>('child_id')!;

    final manager = $$LocalChildrenTableTableManager(
      $_db,
      $_db.localChildren,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_childIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChildProgressesTableFilterComposer
    extends Composer<_$ProfileDatabase, $ChildProgressesTable> {
  $$ChildProgressesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get experiencePoints => $composableBuilder(
    column: $table.experiencePoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stars => $composableBuilder(
    column: $table.stars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coins => $composableBuilder(
    column: $table.coins,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalLearningActivitiesCompleted => $composableBuilder(
    column: $table.totalLearningActivitiesCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LocalChildrenTableFilterComposer get childId {
    final $$LocalChildrenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.localChildren,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalChildrenTableFilterComposer(
            $db: $db,
            $table: $db.localChildren,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChildProgressesTableOrderingComposer
    extends Composer<_$ProfileDatabase, $ChildProgressesTable> {
  $$ChildProgressesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get experiencePoints => $composableBuilder(
    column: $table.experiencePoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stars => $composableBuilder(
    column: $table.stars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coins => $composableBuilder(
    column: $table.coins,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalLearningActivitiesCompleted =>
      $composableBuilder(
        column: $table.totalLearningActivitiesCompleted,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocalChildrenTableOrderingComposer get childId {
    final $$LocalChildrenTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.localChildren,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalChildrenTableOrderingComposer(
            $db: $db,
            $table: $db.localChildren,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChildProgressesTableAnnotationComposer
    extends Composer<_$ProfileDatabase, $ChildProgressesTable> {
  $$ChildProgressesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get experiencePoints => $composableBuilder(
    column: $table.experiencePoints,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stars =>
      $composableBuilder(column: $table.stars, builder: (column) => column);

  GeneratedColumn<int> get coins =>
      $composableBuilder(column: $table.coins, builder: (column) => column);

  GeneratedColumn<int> get totalLearningActivitiesCompleted =>
      $composableBuilder(
        column: $table.totalLearningActivitiesCompleted,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$LocalChildrenTableAnnotationComposer get childId {
    final $$LocalChildrenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.localChildren,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalChildrenTableAnnotationComposer(
            $db: $db,
            $table: $db.localChildren,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChildProgressesTableTableManager
    extends
        RootTableManager<
          _$ProfileDatabase,
          $ChildProgressesTable,
          ChildProgressRow,
          $$ChildProgressesTableFilterComposer,
          $$ChildProgressesTableOrderingComposer,
          $$ChildProgressesTableAnnotationComposer,
          $$ChildProgressesTableCreateCompanionBuilder,
          $$ChildProgressesTableUpdateCompanionBuilder,
          (ChildProgressRow, $$ChildProgressesTableReferences),
          ChildProgressRow,
          PrefetchHooks Function({bool childId})
        > {
  $$ChildProgressesTableTableManager(
    _$ProfileDatabase db,
    $ChildProgressesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChildProgressesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChildProgressesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChildProgressesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> childId = const Value.absent(),
                Value<int> experiencePoints = const Value.absent(),
                Value<int> stars = const Value.absent(),
                Value<int> coins = const Value.absent(),
                Value<int> totalLearningActivitiesCompleted =
                    const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChildProgressesCompanion(
                childId: childId,
                experiencePoints: experiencePoints,
                stars: stars,
                coins: coins,
                totalLearningActivitiesCompleted:
                    totalLearningActivitiesCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String childId,
                Value<int> experiencePoints = const Value.absent(),
                Value<int> stars = const Value.absent(),
                Value<int> coins = const Value.absent(),
                Value<int> totalLearningActivitiesCompleted =
                    const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ChildProgressesCompanion.insert(
                childId: childId,
                experiencePoints: experiencePoints,
                stars: stars,
                coins: coins,
                totalLearningActivitiesCompleted:
                    totalLearningActivitiesCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChildProgressesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({childId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (childId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.childId,
                                referencedTable:
                                    $$ChildProgressesTableReferences
                                        ._childIdTable(db),
                                referencedColumn:
                                    $$ChildProgressesTableReferences
                                        ._childIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ChildProgressesTableProcessedTableManager =
    ProcessedTableManager<
      _$ProfileDatabase,
      $ChildProgressesTable,
      ChildProgressRow,
      $$ChildProgressesTableFilterComposer,
      $$ChildProgressesTableOrderingComposer,
      $$ChildProgressesTableAnnotationComposer,
      $$ChildProgressesTableCreateCompanionBuilder,
      $$ChildProgressesTableUpdateCompanionBuilder,
      (ChildProgressRow, $$ChildProgressesTableReferences),
      ChildProgressRow,
      PrefetchHooks Function({bool childId})
    >;
typedef $$MissionAttemptsTableCreateCompanionBuilder =
    MissionAttemptsCompanion Function({
      required String eventId,
      required String childId,
      required String missionId,
      required String worldId,
      Value<int?> score,
      required int starsEarned,
      required int xpAwarded,
      required int coinsAwarded,
      required int attemptNumber,
      required DateTime completedAt,
      Value<int> rowid,
    });
typedef $$MissionAttemptsTableUpdateCompanionBuilder =
    MissionAttemptsCompanion Function({
      Value<String> eventId,
      Value<String> childId,
      Value<String> missionId,
      Value<String> worldId,
      Value<int?> score,
      Value<int> starsEarned,
      Value<int> xpAwarded,
      Value<int> coinsAwarded,
      Value<int> attemptNumber,
      Value<DateTime> completedAt,
      Value<int> rowid,
    });

final class $$MissionAttemptsTableReferences
    extends
        BaseReferences<
          _$ProfileDatabase,
          $MissionAttemptsTable,
          MissionAttemptRow
        > {
  $$MissionAttemptsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LocalChildrenTable _childIdTable(_$ProfileDatabase db) =>
      db.localChildren.createAlias(
        $_aliasNameGenerator(db.missionAttempts.childId, db.localChildren.id),
      );

  $$LocalChildrenTableProcessedTableManager get childId {
    final $_column = $_itemColumn<String>('child_id')!;

    final manager = $$LocalChildrenTableTableManager(
      $_db,
      $_db.localChildren,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_childIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MissionAttemptsTableFilterComposer
    extends Composer<_$ProfileDatabase, $MissionAttemptsTable> {
  $$MissionAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get missionId => $composableBuilder(
    column: $table.missionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get worldId => $composableBuilder(
    column: $table.worldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get starsEarned => $composableBuilder(
    column: $table.starsEarned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xpAwarded => $composableBuilder(
    column: $table.xpAwarded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coinsAwarded => $composableBuilder(
    column: $table.coinsAwarded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptNumber => $composableBuilder(
    column: $table.attemptNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LocalChildrenTableFilterComposer get childId {
    final $$LocalChildrenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.localChildren,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalChildrenTableFilterComposer(
            $db: $db,
            $table: $db.localChildren,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MissionAttemptsTableOrderingComposer
    extends Composer<_$ProfileDatabase, $MissionAttemptsTable> {
  $$MissionAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get missionId => $composableBuilder(
    column: $table.missionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get worldId => $composableBuilder(
    column: $table.worldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get starsEarned => $composableBuilder(
    column: $table.starsEarned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xpAwarded => $composableBuilder(
    column: $table.xpAwarded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coinsAwarded => $composableBuilder(
    column: $table.coinsAwarded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptNumber => $composableBuilder(
    column: $table.attemptNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocalChildrenTableOrderingComposer get childId {
    final $$LocalChildrenTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.localChildren,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalChildrenTableOrderingComposer(
            $db: $db,
            $table: $db.localChildren,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MissionAttemptsTableAnnotationComposer
    extends Composer<_$ProfileDatabase, $MissionAttemptsTable> {
  $$MissionAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get missionId =>
      $composableBuilder(column: $table.missionId, builder: (column) => column);

  GeneratedColumn<String> get worldId =>
      $composableBuilder(column: $table.worldId, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get starsEarned => $composableBuilder(
    column: $table.starsEarned,
    builder: (column) => column,
  );

  GeneratedColumn<int> get xpAwarded =>
      $composableBuilder(column: $table.xpAwarded, builder: (column) => column);

  GeneratedColumn<int> get coinsAwarded => $composableBuilder(
    column: $table.coinsAwarded,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attemptNumber => $composableBuilder(
    column: $table.attemptNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$LocalChildrenTableAnnotationComposer get childId {
    final $$LocalChildrenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.localChildren,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalChildrenTableAnnotationComposer(
            $db: $db,
            $table: $db.localChildren,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MissionAttemptsTableTableManager
    extends
        RootTableManager<
          _$ProfileDatabase,
          $MissionAttemptsTable,
          MissionAttemptRow,
          $$MissionAttemptsTableFilterComposer,
          $$MissionAttemptsTableOrderingComposer,
          $$MissionAttemptsTableAnnotationComposer,
          $$MissionAttemptsTableCreateCompanionBuilder,
          $$MissionAttemptsTableUpdateCompanionBuilder,
          (MissionAttemptRow, $$MissionAttemptsTableReferences),
          MissionAttemptRow,
          PrefetchHooks Function({bool childId})
        > {
  $$MissionAttemptsTableTableManager(
    _$ProfileDatabase db,
    $MissionAttemptsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MissionAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MissionAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MissionAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> eventId = const Value.absent(),
                Value<String> childId = const Value.absent(),
                Value<String> missionId = const Value.absent(),
                Value<String> worldId = const Value.absent(),
                Value<int?> score = const Value.absent(),
                Value<int> starsEarned = const Value.absent(),
                Value<int> xpAwarded = const Value.absent(),
                Value<int> coinsAwarded = const Value.absent(),
                Value<int> attemptNumber = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MissionAttemptsCompanion(
                eventId: eventId,
                childId: childId,
                missionId: missionId,
                worldId: worldId,
                score: score,
                starsEarned: starsEarned,
                xpAwarded: xpAwarded,
                coinsAwarded: coinsAwarded,
                attemptNumber: attemptNumber,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String eventId,
                required String childId,
                required String missionId,
                required String worldId,
                Value<int?> score = const Value.absent(),
                required int starsEarned,
                required int xpAwarded,
                required int coinsAwarded,
                required int attemptNumber,
                required DateTime completedAt,
                Value<int> rowid = const Value.absent(),
              }) => MissionAttemptsCompanion.insert(
                eventId: eventId,
                childId: childId,
                missionId: missionId,
                worldId: worldId,
                score: score,
                starsEarned: starsEarned,
                xpAwarded: xpAwarded,
                coinsAwarded: coinsAwarded,
                attemptNumber: attemptNumber,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MissionAttemptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({childId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (childId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.childId,
                                referencedTable:
                                    $$MissionAttemptsTableReferences
                                        ._childIdTable(db),
                                referencedColumn:
                                    $$MissionAttemptsTableReferences
                                        ._childIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MissionAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$ProfileDatabase,
      $MissionAttemptsTable,
      MissionAttemptRow,
      $$MissionAttemptsTableFilterComposer,
      $$MissionAttemptsTableOrderingComposer,
      $$MissionAttemptsTableAnnotationComposer,
      $$MissionAttemptsTableCreateCompanionBuilder,
      $$MissionAttemptsTableUpdateCompanionBuilder,
      (MissionAttemptRow, $$MissionAttemptsTableReferences),
      MissionAttemptRow,
      PrefetchHooks Function({bool childId})
    >;
typedef $$MissionBestResultsTableCreateCompanionBuilder =
    MissionBestResultsCompanion Function({
      required String childId,
      required String missionId,
      required String worldId,
      required int bestStars,
      Value<int?> bestScore,
      required DateTime firstCompletedAt,
      required DateTime lastImprovedAt,
      Value<int> rowid,
    });
typedef $$MissionBestResultsTableUpdateCompanionBuilder =
    MissionBestResultsCompanion Function({
      Value<String> childId,
      Value<String> missionId,
      Value<String> worldId,
      Value<int> bestStars,
      Value<int?> bestScore,
      Value<DateTime> firstCompletedAt,
      Value<DateTime> lastImprovedAt,
      Value<int> rowid,
    });

final class $$MissionBestResultsTableReferences
    extends
        BaseReferences<
          _$ProfileDatabase,
          $MissionBestResultsTable,
          MissionBestResultRow
        > {
  $$MissionBestResultsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LocalChildrenTable _childIdTable(_$ProfileDatabase db) =>
      db.localChildren.createAlias(
        $_aliasNameGenerator(
          db.missionBestResults.childId,
          db.localChildren.id,
        ),
      );

  $$LocalChildrenTableProcessedTableManager get childId {
    final $_column = $_itemColumn<String>('child_id')!;

    final manager = $$LocalChildrenTableTableManager(
      $_db,
      $_db.localChildren,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_childIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MissionBestResultsTableFilterComposer
    extends Composer<_$ProfileDatabase, $MissionBestResultsTable> {
  $$MissionBestResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get missionId => $composableBuilder(
    column: $table.missionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get worldId => $composableBuilder(
    column: $table.worldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestStars => $composableBuilder(
    column: $table.bestStars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestScore => $composableBuilder(
    column: $table.bestScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firstCompletedAt => $composableBuilder(
    column: $table.firstCompletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastImprovedAt => $composableBuilder(
    column: $table.lastImprovedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LocalChildrenTableFilterComposer get childId {
    final $$LocalChildrenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.localChildren,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalChildrenTableFilterComposer(
            $db: $db,
            $table: $db.localChildren,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MissionBestResultsTableOrderingComposer
    extends Composer<_$ProfileDatabase, $MissionBestResultsTable> {
  $$MissionBestResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get missionId => $composableBuilder(
    column: $table.missionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get worldId => $composableBuilder(
    column: $table.worldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestStars => $composableBuilder(
    column: $table.bestStars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestScore => $composableBuilder(
    column: $table.bestScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firstCompletedAt => $composableBuilder(
    column: $table.firstCompletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastImprovedAt => $composableBuilder(
    column: $table.lastImprovedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocalChildrenTableOrderingComposer get childId {
    final $$LocalChildrenTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.localChildren,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalChildrenTableOrderingComposer(
            $db: $db,
            $table: $db.localChildren,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MissionBestResultsTableAnnotationComposer
    extends Composer<_$ProfileDatabase, $MissionBestResultsTable> {
  $$MissionBestResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get missionId =>
      $composableBuilder(column: $table.missionId, builder: (column) => column);

  GeneratedColumn<String> get worldId =>
      $composableBuilder(column: $table.worldId, builder: (column) => column);

  GeneratedColumn<int> get bestStars =>
      $composableBuilder(column: $table.bestStars, builder: (column) => column);

  GeneratedColumn<int> get bestScore =>
      $composableBuilder(column: $table.bestScore, builder: (column) => column);

  GeneratedColumn<DateTime> get firstCompletedAt => $composableBuilder(
    column: $table.firstCompletedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastImprovedAt => $composableBuilder(
    column: $table.lastImprovedAt,
    builder: (column) => column,
  );

  $$LocalChildrenTableAnnotationComposer get childId {
    final $$LocalChildrenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.localChildren,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalChildrenTableAnnotationComposer(
            $db: $db,
            $table: $db.localChildren,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MissionBestResultsTableTableManager
    extends
        RootTableManager<
          _$ProfileDatabase,
          $MissionBestResultsTable,
          MissionBestResultRow,
          $$MissionBestResultsTableFilterComposer,
          $$MissionBestResultsTableOrderingComposer,
          $$MissionBestResultsTableAnnotationComposer,
          $$MissionBestResultsTableCreateCompanionBuilder,
          $$MissionBestResultsTableUpdateCompanionBuilder,
          (MissionBestResultRow, $$MissionBestResultsTableReferences),
          MissionBestResultRow,
          PrefetchHooks Function({bool childId})
        > {
  $$MissionBestResultsTableTableManager(
    _$ProfileDatabase db,
    $MissionBestResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MissionBestResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MissionBestResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MissionBestResultsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> childId = const Value.absent(),
                Value<String> missionId = const Value.absent(),
                Value<String> worldId = const Value.absent(),
                Value<int> bestStars = const Value.absent(),
                Value<int?> bestScore = const Value.absent(),
                Value<DateTime> firstCompletedAt = const Value.absent(),
                Value<DateTime> lastImprovedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MissionBestResultsCompanion(
                childId: childId,
                missionId: missionId,
                worldId: worldId,
                bestStars: bestStars,
                bestScore: bestScore,
                firstCompletedAt: firstCompletedAt,
                lastImprovedAt: lastImprovedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String childId,
                required String missionId,
                required String worldId,
                required int bestStars,
                Value<int?> bestScore = const Value.absent(),
                required DateTime firstCompletedAt,
                required DateTime lastImprovedAt,
                Value<int> rowid = const Value.absent(),
              }) => MissionBestResultsCompanion.insert(
                childId: childId,
                missionId: missionId,
                worldId: worldId,
                bestStars: bestStars,
                bestScore: bestScore,
                firstCompletedAt: firstCompletedAt,
                lastImprovedAt: lastImprovedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MissionBestResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({childId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (childId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.childId,
                                referencedTable:
                                    $$MissionBestResultsTableReferences
                                        ._childIdTable(db),
                                referencedColumn:
                                    $$MissionBestResultsTableReferences
                                        ._childIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MissionBestResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$ProfileDatabase,
      $MissionBestResultsTable,
      MissionBestResultRow,
      $$MissionBestResultsTableFilterComposer,
      $$MissionBestResultsTableOrderingComposer,
      $$MissionBestResultsTableAnnotationComposer,
      $$MissionBestResultsTableCreateCompanionBuilder,
      $$MissionBestResultsTableUpdateCompanionBuilder,
      (MissionBestResultRow, $$MissionBestResultsTableReferences),
      MissionBestResultRow,
      PrefetchHooks Function({bool childId})
    >;
typedef $$RewardTransactionsTableCreateCompanionBuilder =
    RewardTransactionsCompanion Function({
      required String id,
      required String childId,
      required String type,
      required int amount,
      required String sourceType,
      required String sourceId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$RewardTransactionsTableUpdateCompanionBuilder =
    RewardTransactionsCompanion Function({
      Value<String> id,
      Value<String> childId,
      Value<String> type,
      Value<int> amount,
      Value<String> sourceType,
      Value<String> sourceId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$RewardTransactionsTableReferences
    extends
        BaseReferences<
          _$ProfileDatabase,
          $RewardTransactionsTable,
          RewardTransactionRow
        > {
  $$RewardTransactionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LocalChildrenTable _childIdTable(_$ProfileDatabase db) =>
      db.localChildren.createAlias(
        $_aliasNameGenerator(
          db.rewardTransactions.childId,
          db.localChildren.id,
        ),
      );

  $$LocalChildrenTableProcessedTableManager get childId {
    final $_column = $_itemColumn<String>('child_id')!;

    final manager = $$LocalChildrenTableTableManager(
      $_db,
      $_db.localChildren,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_childIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RewardTransactionsTableFilterComposer
    extends Composer<_$ProfileDatabase, $RewardTransactionsTable> {
  $$RewardTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LocalChildrenTableFilterComposer get childId {
    final $$LocalChildrenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.localChildren,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalChildrenTableFilterComposer(
            $db: $db,
            $table: $db.localChildren,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RewardTransactionsTableOrderingComposer
    extends Composer<_$ProfileDatabase, $RewardTransactionsTable> {
  $$RewardTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocalChildrenTableOrderingComposer get childId {
    final $$LocalChildrenTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.localChildren,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalChildrenTableOrderingComposer(
            $db: $db,
            $table: $db.localChildren,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RewardTransactionsTableAnnotationComposer
    extends Composer<_$ProfileDatabase, $RewardTransactionsTable> {
  $$RewardTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$LocalChildrenTableAnnotationComposer get childId {
    final $$LocalChildrenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.localChildren,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalChildrenTableAnnotationComposer(
            $db: $db,
            $table: $db.localChildren,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RewardTransactionsTableTableManager
    extends
        RootTableManager<
          _$ProfileDatabase,
          $RewardTransactionsTable,
          RewardTransactionRow,
          $$RewardTransactionsTableFilterComposer,
          $$RewardTransactionsTableOrderingComposer,
          $$RewardTransactionsTableAnnotationComposer,
          $$RewardTransactionsTableCreateCompanionBuilder,
          $$RewardTransactionsTableUpdateCompanionBuilder,
          (RewardTransactionRow, $$RewardTransactionsTableReferences),
          RewardTransactionRow,
          PrefetchHooks Function({bool childId})
        > {
  $$RewardTransactionsTableTableManager(
    _$ProfileDatabase db,
    $RewardTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RewardTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RewardTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RewardTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> childId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardTransactionsCompanion(
                id: id,
                childId: childId,
                type: type,
                amount: amount,
                sourceType: sourceType,
                sourceId: sourceId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String childId,
                required String type,
                required int amount,
                required String sourceType,
                required String sourceId,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => RewardTransactionsCompanion.insert(
                id: id,
                childId: childId,
                type: type,
                amount: amount,
                sourceType: sourceType,
                sourceId: sourceId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RewardTransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({childId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (childId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.childId,
                                referencedTable:
                                    $$RewardTransactionsTableReferences
                                        ._childIdTable(db),
                                referencedColumn:
                                    $$RewardTransactionsTableReferences
                                        ._childIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RewardTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$ProfileDatabase,
      $RewardTransactionsTable,
      RewardTransactionRow,
      $$RewardTransactionsTableFilterComposer,
      $$RewardTransactionsTableOrderingComposer,
      $$RewardTransactionsTableAnnotationComposer,
      $$RewardTransactionsTableCreateCompanionBuilder,
      $$RewardTransactionsTableUpdateCompanionBuilder,
      (RewardTransactionRow, $$RewardTransactionsTableReferences),
      RewardTransactionRow,
      PrefetchHooks Function({bool childId})
    >;
typedef $$ChildAchievementsTableCreateCompanionBuilder =
    ChildAchievementsCompanion Function({
      required String childId,
      required String achievementId,
      required DateTime earnedAt,
      Value<int> rowid,
    });
typedef $$ChildAchievementsTableUpdateCompanionBuilder =
    ChildAchievementsCompanion Function({
      Value<String> childId,
      Value<String> achievementId,
      Value<DateTime> earnedAt,
      Value<int> rowid,
    });

final class $$ChildAchievementsTableReferences
    extends
        BaseReferences<
          _$ProfileDatabase,
          $ChildAchievementsTable,
          ChildAchievementRow
        > {
  $$ChildAchievementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LocalChildrenTable _childIdTable(_$ProfileDatabase db) =>
      db.localChildren.createAlias(
        $_aliasNameGenerator(db.childAchievements.childId, db.localChildren.id),
      );

  $$LocalChildrenTableProcessedTableManager get childId {
    final $_column = $_itemColumn<String>('child_id')!;

    final manager = $$LocalChildrenTableTableManager(
      $_db,
      $_db.localChildren,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_childIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChildAchievementsTableFilterComposer
    extends Composer<_$ProfileDatabase, $ChildAchievementsTable> {
  $$ChildAchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LocalChildrenTableFilterComposer get childId {
    final $$LocalChildrenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.localChildren,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalChildrenTableFilterComposer(
            $db: $db,
            $table: $db.localChildren,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChildAchievementsTableOrderingComposer
    extends Composer<_$ProfileDatabase, $ChildAchievementsTable> {
  $$ChildAchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocalChildrenTableOrderingComposer get childId {
    final $$LocalChildrenTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.localChildren,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalChildrenTableOrderingComposer(
            $db: $db,
            $table: $db.localChildren,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChildAchievementsTableAnnotationComposer
    extends Composer<_$ProfileDatabase, $ChildAchievementsTable> {
  $$ChildAchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get earnedAt =>
      $composableBuilder(column: $table.earnedAt, builder: (column) => column);

  $$LocalChildrenTableAnnotationComposer get childId {
    final $$LocalChildrenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.localChildren,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalChildrenTableAnnotationComposer(
            $db: $db,
            $table: $db.localChildren,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChildAchievementsTableTableManager
    extends
        RootTableManager<
          _$ProfileDatabase,
          $ChildAchievementsTable,
          ChildAchievementRow,
          $$ChildAchievementsTableFilterComposer,
          $$ChildAchievementsTableOrderingComposer,
          $$ChildAchievementsTableAnnotationComposer,
          $$ChildAchievementsTableCreateCompanionBuilder,
          $$ChildAchievementsTableUpdateCompanionBuilder,
          (ChildAchievementRow, $$ChildAchievementsTableReferences),
          ChildAchievementRow,
          PrefetchHooks Function({bool childId})
        > {
  $$ChildAchievementsTableTableManager(
    _$ProfileDatabase db,
    $ChildAchievementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChildAchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChildAchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChildAchievementsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> childId = const Value.absent(),
                Value<String> achievementId = const Value.absent(),
                Value<DateTime> earnedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChildAchievementsCompanion(
                childId: childId,
                achievementId: achievementId,
                earnedAt: earnedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String childId,
                required String achievementId,
                required DateTime earnedAt,
                Value<int> rowid = const Value.absent(),
              }) => ChildAchievementsCompanion.insert(
                childId: childId,
                achievementId: achievementId,
                earnedAt: earnedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChildAchievementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({childId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (childId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.childId,
                                referencedTable:
                                    $$ChildAchievementsTableReferences
                                        ._childIdTable(db),
                                referencedColumn:
                                    $$ChildAchievementsTableReferences
                                        ._childIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ChildAchievementsTableProcessedTableManager =
    ProcessedTableManager<
      _$ProfileDatabase,
      $ChildAchievementsTable,
      ChildAchievementRow,
      $$ChildAchievementsTableFilterComposer,
      $$ChildAchievementsTableOrderingComposer,
      $$ChildAchievementsTableAnnotationComposer,
      $$ChildAchievementsTableCreateCompanionBuilder,
      $$ChildAchievementsTableUpdateCompanionBuilder,
      (ChildAchievementRow, $$ChildAchievementsTableReferences),
      ChildAchievementRow,
      PrefetchHooks Function({bool childId})
    >;

class $ProfileDatabaseManager {
  final _$ProfileDatabase _db;
  $ProfileDatabaseManager(this._db);
  $$LocalParentsTableTableManager get localParents =>
      $$LocalParentsTableTableManager(_db, _db.localParents);
  $$LocalChildrenTableTableManager get localChildren =>
      $$LocalChildrenTableTableManager(_db, _db.localChildren);
  $$LocalSetupTableTableManager get localSetup =>
      $$LocalSetupTableTableManager(_db, _db.localSetup);
  $$ChildProgressesTableTableManager get childProgresses =>
      $$ChildProgressesTableTableManager(_db, _db.childProgresses);
  $$MissionAttemptsTableTableManager get missionAttempts =>
      $$MissionAttemptsTableTableManager(_db, _db.missionAttempts);
  $$MissionBestResultsTableTableManager get missionBestResults =>
      $$MissionBestResultsTableTableManager(_db, _db.missionBestResults);
  $$RewardTransactionsTableTableManager get rewardTransactions =>
      $$RewardTransactionsTableTableManager(_db, _db.rewardTransactions);
  $$ChildAchievementsTableTableManager get childAchievements =>
      $$ChildAchievementsTableTableManager(_db, _db.childAchievements);
}
