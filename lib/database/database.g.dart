// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  HabitationDao? _habitationDaoInstance;

  WaterSourceFilterDao? _waterSourceFilterDaoInstance;

  SchemeDao? _schemeDaoInstance;

  SourcesDao? _sourcesDaoInstance;

  LabDao? _labDaoInstance;

  ParameterDao? _parameterDaoInstance;

  LabInchargeDao? _labInchargeDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `habitation` (`habitationId` INTEGER NOT NULL, `villageId` INTEGER NOT NULL, `habitationName` TEXT NOT NULL, PRIMARY KEY (`habitationId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `WaterSourceFilter` (`id` INTEGER NOT NULL, `sourceType` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Scheme` (`SchemeId` INTEGER NOT NULL, `SourceType` INTEGER NOT NULL, `VillageId` INTEGER NOT NULL, `SchemeName` TEXT NOT NULL, PRIMARY KEY (`SchemeId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Sources` (`location_id` INTEGER NOT NULL, `SourceType` INTEGER NOT NULL, `SourceTypeCategoryId` INTEGER NOT NULL, `SchemeId` INTEGER NOT NULL, `VillageId` INTEGER NOT NULL, `HabitationId` INTEGER NOT NULL, `Is_fhtc` INTEGER NOT NULL, `location_name` TEXT NOT NULL, PRIMARY KEY (`location_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Lab` (`lab_id` INTEGER NOT NULL, `stateid` INTEGER NOT NULL, `lab_name` TEXT NOT NULL, `is_wtp` INTEGER NOT NULL, PRIMARY KEY (`lab_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Parameter` (`ParameterId` INTEGER NOT NULL, `stateid` INTEGER NOT NULL, `lab_name` TEXT NOT NULL, `lab_id` INTEGER NOT NULL, `is_wtp` INTEGER NOT NULL, `dept_rate` INTEGER NOT NULL, `ParameterName` TEXT NOT NULL, PRIMARY KEY (`ParameterId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `LabIncharge` (`lab_id` INTEGER NOT NULL, `stateid` INTEGER NOT NULL, `lab_name` TEXT NOT NULL, `lab_address` TEXT NOT NULL, `LabIncharge` TEXT NOT NULL, PRIMARY KEY (`lab_id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  HabitationDao get habitationDao {
    return _habitationDaoInstance ??= _$HabitationDao(database, changeListener);
  }

  @override
  WaterSourceFilterDao get waterSourceFilterDao {
    return _waterSourceFilterDaoInstance ??=
        _$WaterSourceFilterDao(database, changeListener);
  }

  @override
  SchemeDao get schemeDao {
    return _schemeDaoInstance ??= _$SchemeDao(database, changeListener);
  }

  @override
  SourcesDao get sourcesDao {
    return _sourcesDaoInstance ??= _$SourcesDao(database, changeListener);
  }

  @override
  LabDao get labDao {
    return _labDaoInstance ??= _$LabDao(database, changeListener);
  }

  @override
  ParameterDao get parameterDao {
    return _parameterDaoInstance ??= _$ParameterDao(database, changeListener);
  }

  @override
  LabInchargeDao get labInchargeDao {
    return _labInchargeDaoInstance ??=
        _$LabInchargeDao(database, changeListener);
  }
}

class _$HabitationDao extends HabitationDao {
  _$HabitationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _habitationTableInsertionAdapter = InsertionAdapter(
            database,
            'habitation',
            (HabitationTable item) => <String, Object?>{
                  'habitationId': item.habitationId,
                  'villageId': item.villageId,
                  'habitationName': item.habitationName
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<HabitationTable> _habitationTableInsertionAdapter;

  @override
  Future<List<HabitationTable>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM habitation',
        mapper: (Map<String, Object?> row) => HabitationTable(
            row['habitationId'] as int,
            row['villageId'] as int,
            row['habitationName'] as String));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM habitation');
  }

  @override
  Future<void> insertHabitation(HabitationTable habitation) async {
    await _habitationTableInsertionAdapter.insert(
        habitation, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAll(List<HabitationTable> habitations) async {
    await _habitationTableInsertionAdapter.insertList(
        habitations, OnConflictStrategy.replace);
  }
}

class _$WaterSourceFilterDao extends WaterSourceFilterDao {
  _$WaterSourceFilterDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _waterSourceFilterInsertionAdapter = InsertionAdapter(
            database,
            'WaterSourceFilter',
            (WaterSourceFilter item) => <String, Object?>{
                  'id': item.id,
                  'sourceType': item.sourceType
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WaterSourceFilter> _waterSourceFilterInsertionAdapter;

  @override
  Future<List<WaterSourceFilter>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM WaterSourceFilter',
        mapper: (Map<String, Object?> row) =>
            WaterSourceFilter(row['id'] as int, row['sourceType'] as String));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM WaterSourceFilter');
  }

  @override
  Future<void> insertWaterSource(WaterSourceFilter waterSourceFilter) async {
    await _waterSourceFilterInsertionAdapter.insert(
        waterSourceFilter, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertAll(List<WaterSourceFilter> waterSources) async {
    await _waterSourceFilterInsertionAdapter.insertList(
        waterSources, OnConflictStrategy.abort);
  }
}

class _$SchemeDao extends SchemeDao {
  _$SchemeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _schemeEntityInsertionAdapter = InsertionAdapter(
            database,
            'Scheme',
            (SchemeEntity item) => <String, Object?>{
                  'SchemeId': item.SchemeId,
                  'SourceType': item.SourceType,
                  'VillageId': item.VillageId,
                  'SchemeName': item.SchemeName
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SchemeEntity> _schemeEntityInsertionAdapter;

  @override
  Future<List<SchemeEntity>> getAllSchemes() async {
    return _queryAdapter.queryList('SELECT * FROM Scheme',
        mapper: (Map<String, Object?> row) => SchemeEntity(
            SchemeId: row['SchemeId'] as int,
            SourceType: row['SourceType'] as int,
            VillageId: row['VillageId'] as int,
            SchemeName: row['SchemeName'] as String));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM SchemeEntity');
  }

  @override
  Future<void> insertAllSchemes(List<SchemeEntity> schemes) async {
    await _schemeEntityInsertionAdapter.insertList(
        schemes, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAll(List<SchemeEntity> waterSources) async {
    await _schemeEntityInsertionAdapter.insertList(
        waterSources, OnConflictStrategy.abort);
  }
}

class _$SourcesDao extends SourcesDao {
  _$SourcesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _sourcesEntityInsertionAdapter = InsertionAdapter(
            database,
            'Sources',
            (SourcesEntity item) => <String, Object?>{
                  'location_id': item.location_id,
                  'SourceType': item.SourceType,
                  'SourceTypeCategoryId': item.SourceTypeCategoryId,
                  'SchemeId': item.SchemeId,
                  'VillageId': item.VillageId,
                  'HabitationId': item.HabitationId,
                  'Is_fhtc': item.Is_fhtc,
                  'location_name': item.location_name
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SourcesEntity> _sourcesEntityInsertionAdapter;

  @override
  Future<List<SourcesEntity>> getAllSources() async {
    return _queryAdapter.queryList('SELECT * FROM Sources',
        mapper: (Map<String, Object?> row) => SourcesEntity(
            location_id: row['location_id'] as int,
            SourceType: row['SourceType'] as int,
            SourceTypeCategoryId: row['SourceTypeCategoryId'] as int,
            SchemeId: row['SchemeId'] as int,
            VillageId: row['VillageId'] as int,
            HabitationId: row['HabitationId'] as int,
            Is_fhtc: row['Is_fhtc'] as int,
            location_name: row['location_name'] as String));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM SourcesEntity');
  }

  @override
  Future<void> insertAllSources(List<SourcesEntity> sources) async {
    await _sourcesEntityInsertionAdapter.insertList(
        sources, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAll(List<SourcesEntity> waterSources) async {
    await _sourcesEntityInsertionAdapter.insertList(
        waterSources, OnConflictStrategy.abort);
  }
}

class _$LabDao extends LabDao {
  _$LabDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _labEntityInsertionAdapter = InsertionAdapter(
            database,
            'Lab',
            (LabEntity item) => <String, Object?>{
                  'lab_id': item.lab_id,
                  'stateid': item.stateid,
                  'lab_name': item.lab_name,
                  'is_wtp': item.is_wtp
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LabEntity> _labEntityInsertionAdapter;

  @override
  Future<List<LabEntity>> getAllLabs() async {
    return _queryAdapter.queryList('SELECT * FROM Lab',
        mapper: (Map<String, Object?> row) => LabEntity(
            lab_id: row['lab_id'] as int,
            stateid: row['stateid'] as int,
            lab_name: row['lab_name'] as String,
            is_wtp: row['is_wtp'] as int));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM LabEntity');
  }

  @override
  Future<void> insertAllLabs(List<LabEntity> labs) async {
    await _labEntityInsertionAdapter.insertList(
        labs, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAll(List<LabEntity> waterSources) async {
    await _labEntityInsertionAdapter.insertList(
        waterSources, OnConflictStrategy.abort);
  }
}

class _$ParameterDao extends ParameterDao {
  _$ParameterDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _parameterEntityInsertionAdapter = InsertionAdapter(
            database,
            'Parameter',
            (ParameterEntity item) => <String, Object?>{
                  'ParameterId': item.ParameterId,
                  'stateid': item.stateid,
                  'lab_name': item.lab_name,
                  'lab_id': item.lab_id,
                  'is_wtp': item.is_wtp,
                  'dept_rate': item.dept_rate,
                  'ParameterName': item.ParameterName
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ParameterEntity> _parameterEntityInsertionAdapter;

  @override
  Future<List<ParameterEntity>> getAllParameters() async {
    return _queryAdapter.queryList('SELECT * FROM Parameter',
        mapper: (Map<String, Object?> row) => ParameterEntity(
            ParameterId: row['ParameterId'] as int,
            stateid: row['stateid'] as int,
            lab_name: row['lab_name'] as String,
            lab_id: row['lab_id'] as int,
            is_wtp: row['is_wtp'] as int,
            dept_rate: row['dept_rate'] as int,
            ParameterName: row['ParameterName'] as String));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM ParameterEntity');
  }

  @override
  Future<void> insertAllParameters(List<ParameterEntity> params) async {
    await _parameterEntityInsertionAdapter.insertList(
        params, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAll(List<ParameterEntity> waterSources) async {
    await _parameterEntityInsertionAdapter.insertList(
        waterSources, OnConflictStrategy.abort);
  }
}

class _$LabInchargeDao extends LabInchargeDao {
  _$LabInchargeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _labInchargeEntityInsertionAdapter = InsertionAdapter(
            database,
            'LabIncharge',
            (LabInchargeEntity item) => <String, Object?>{
                  'lab_id': item.lab_id,
                  'stateid': item.stateid,
                  'lab_name': item.lab_name,
                  'lab_address': item.lab_address,
                  'LabIncharge': item.LabIncharge
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LabInchargeEntity> _labInchargeEntityInsertionAdapter;

  @override
  Future<List<LabInchargeEntity>> getAllLabIncharges() async {
    return _queryAdapter.queryList('SELECT * FROM LabIncharge',
        mapper: (Map<String, Object?> row) => LabInchargeEntity(
            lab_id: row['lab_id'] as int,
            stateid: row['stateid'] as int,
            lab_name: row['lab_name'] as String,
            lab_address: row['lab_address'] as String,
            LabIncharge: row['LabIncharge'] as String));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM LabInchargeEntity');
  }

  @override
  Future<void> insertAllLabIncharges(List<LabInchargeEntity> incharges) async {
    await _labInchargeEntityInsertionAdapter.insertList(
        incharges, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAll(List<LabInchargeEntity> waterSources) async {
    await _labInchargeEntityInsertionAdapter.insertList(
        waterSources, OnConflictStrategy.abort);
  }
}
