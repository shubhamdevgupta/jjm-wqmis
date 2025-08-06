import 'package:drift/drift.dart';
import 'package:drift/native.dart'; // For NativeDatabase
import 'package:jjm_wqmis/database/dao/habitation_dao.dart';
import 'package:jjm_wqmis/database/dao/lab_dao.dart';
import 'package:jjm_wqmis/database/dao/lab_incharge_dao.dart';
import 'package:jjm_wqmis/database/dao/parameter_dao.dart';
import 'package:jjm_wqmis/database/dao/scheme_dao.dart';
import 'package:jjm_wqmis/database/dao/source_dao.dart';
import 'package:jjm_wqmis/database/dao/water_source_filter_dao.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'app_database.g.dart'; // ✅ This line is required!



// 1. Habitations Table
class Habitations extends Table {
  IntColumn get habitationId => integer()(); // PK
  TextColumn get habitationName => text()();
  IntColumn get villageId => integer()();

  @override
  Set<Column> get primaryKey => {habitationId};
}

// 2. Water Source Filter Table
class WaterSourceFilters extends Table {
  IntColumn get id => integer()(); // PK
  TextColumn get sourceType => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// 3. Schemes Table
class Schemes extends Table {
  IntColumn get schemeId => integer()(); // PK
  TextColumn get schemeName => text()();
  IntColumn get villageId => integer()();
  IntColumn get sourceType => integer()();

  @override
  Set<Column> get primaryKey => {schemeId};
}

// 4. Sources Table
class Sources extends Table {
  IntColumn get locationId => integer()(); // PK
  TextColumn get locationName => text()();
  IntColumn get sourceType => integer()();
  IntColumn get sourceTypeCategoryId => integer()();
  IntColumn get schemeId => integer()();
  IntColumn get villageId => integer()();
  IntColumn get habitationId => integer()();
  BoolColumn get isFhtc => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {locationId};
}

// 5. Labs Table
class Labs extends Table {
  IntColumn get labId => integer()(); // PK
  TextColumn get labName => text()();
  IntColumn get stateId => integer()();
  BoolColumn get isWtp => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {labId};
}

// 6. Parameters Table
class Parameters extends Table {
  IntColumn get parameterId => integer()(); // PK
  TextColumn get parameterName => text()();
  IntColumn get labId => integer()();
  TextColumn get labName => text()(); // optional for offline view
  IntColumn get stateId => integer()();
  BoolColumn get isWtp => boolean().withDefault(const Constant(false))();
  IntColumn get deptRate => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {parameterId, labId}; // Composite key
}

// 7. Lab Incharges Table
class LabIncharges extends Table {
  IntColumn get labId => integer()(); // PK
  TextColumn get labName => text()();
  TextColumn get labAddress => text()();
  TextColumn get labIncharge => text()();
  IntColumn get stateId => integer()();

  @override
  Set<Column> get primaryKey => {labId};
}

@DriftDatabase(
  tables: [
    Habitations,
    WaterSourceFilters,
    Schemes,
    Sources,
    Labs,
    Parameters,
    LabIncharges,
  ],
  daos: [
    HabitationDao,
    SchemeDao,
    SourceDao,
    WaterSourceFilterDao,
    LabDao,
    ParameterDao,
    LabInchargeDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}
// 🔽 Native connection initializer for SQLite

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.sqlite'));
    return NativeDatabase(file);
  });
}

