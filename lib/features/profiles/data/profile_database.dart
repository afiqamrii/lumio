import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'profile_database.g.dart';

@DataClassName('ParentRow')
class LocalParents extends Table {
  TextColumn get id => text()();
  IntColumn get singleton =>
      integer().withDefault(const Constant(1)).unique()();
  TextColumn get displayName => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  List<String> get customConstraints => ['CHECK (singleton = 1)'];
}

@DataClassName('ChildRow')
class LocalChildren extends Table {
  TextColumn get id => text()();
  TextColumn get parentId => text().references(LocalParents, #id)();
  TextColumn get displayName => text().withLength(min: 1, max: 160)();
  IntColumn get startingAge => integer()();
  TextColumn get avatarId => text()();
  TextColumn get language => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  List<String> get customConstraints => [
    'CHECK (starting_age BETWEEN 5 AND 9)',
    "CHECK (language IN ('en', 'ms'))",
    "CHECK (avatar_id IN ('spark', 'sun', 'moon', 'leaf'))",
  ];
}

@DataClassName('SetupRow')
class LocalSetup extends Table {
  IntColumn get id => integer()();
  BoolColumn get completed => boolean()();
  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  List<String> get customConstraints => ['CHECK (id = 1)'];
}

@DataClassName('ChildProgressRow')
class ChildProgresses extends Table {
  TextColumn get childId =>
      text().references(LocalChildren, #id, onDelete: KeyAction.cascade)();
  IntColumn get experiencePoints => integer().withDefault(const Constant(0))();
  IntColumn get stars => integer().withDefault(const Constant(0))();
  IntColumn get coins => integer().withDefault(const Constant(0))();
  IntColumn get totalLearningActivitiesCompleted =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {childId};
  @override
  List<String> get customConstraints => [
    'CHECK (experience_points >= 0)',
    'CHECK (stars >= 0)',
    'CHECK (coins >= 0)',
    'CHECK (total_learning_activities_completed >= 0)',
  ];
}

@DataClassName('MissionAttemptRow')
class MissionAttempts extends Table {
  TextColumn get eventId => text()();
  TextColumn get childId =>
      text().references(LocalChildren, #id, onDelete: KeyAction.cascade)();
  TextColumn get missionId => text()();
  TextColumn get worldId => text()();
  IntColumn get score => integer().nullable()();
  IntColumn get starsEarned => integer()();
  IntColumn get xpAwarded => integer()();
  IntColumn get coinsAwarded => integer()();
  IntColumn get attemptNumber => integer()();
  DateTimeColumn get completedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {eventId};
  @override
  List<String> get customConstraints => [
    'CHECK (stars_earned BETWEEN 1 AND 3)',
    'CHECK (score IS NULL OR score BETWEEN 0 AND 100)',
    'CHECK (xp_awarded >= 0)',
    'CHECK (coins_awarded >= 0)',
    'CHECK (attempt_number >= 1)',
  ];
}

@DataClassName('MissionBestResultRow')
class MissionBestResults extends Table {
  TextColumn get childId =>
      text().references(LocalChildren, #id, onDelete: KeyAction.cascade)();
  TextColumn get missionId => text()();
  TextColumn get worldId => text()();
  IntColumn get bestStars => integer()();
  IntColumn get bestScore => integer().nullable()();
  DateTimeColumn get firstCompletedAt => dateTime()();
  DateTimeColumn get lastImprovedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {childId, missionId};
  @override
  List<String> get customConstraints => [
    'CHECK (best_stars BETWEEN 1 AND 3)',
    'CHECK (best_score IS NULL OR best_score BETWEEN 0 AND 100)',
  ];
}

@DataClassName('RewardTransactionRow')
class RewardTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get childId =>
      text().references(LocalChildren, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => text()();
  IntColumn get amount => integer()();
  TextColumn get sourceType => text()();
  TextColumn get sourceId => text()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {childId, type, sourceType, sourceId},
  ];
  @override
  List<String> get customConstraints => [
    "CHECK (type IN ('coinEarned', 'coinSpent'))",
    'CHECK (amount > 0)',
  ];
}

@DataClassName('ChildAchievementRow')
class ChildAchievements extends Table {
  TextColumn get childId =>
      text().references(LocalChildren, #id, onDelete: KeyAction.cascade)();
  TextColumn get achievementId => text()();
  DateTimeColumn get earnedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {childId, achievementId};
}

@DriftDatabase(
  tables: [
    LocalParents,
    LocalChildren,
    LocalSetup,
    ChildProgresses,
    MissionAttempts,
    MissionBestResults,
    RewardTransactions,
    ChildAchievements,
  ],
)
class ProfileDatabase extends _$ProfileDatabase {
  ProfileDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'lumio_profiles'));
  ProfileDatabase.sandbox() : super(driftDatabase(name: 'lumio_profiles_qa'));
  @override
  int get schemaVersion => 2;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(childProgresses);
        await migrator.createTable(missionAttempts);
        await migrator.createTable(missionBestResults);
        await migrator.createTable(rewardTransactions);
        await migrator.createTable(childAchievements);
      }
    },
    beforeOpen: (_) async => customStatement('PRAGMA foreign_keys = ON'),
  );
}
