import 'dart:async';
import 'package:floor/floor.dart';
import 'package:jjm_wqmis/database/Dao/labDao.dart';
import 'package:jjm_wqmis/database/Dao/labinchargeDao.dart';
import 'package:jjm_wqmis/database/Dao/parameterDao.dart';
import 'package:jjm_wqmis/database/Dao/schemeDao.dart';
import 'package:jjm_wqmis/database/Dao/sourceDao.dart';
import 'package:jjm_wqmis/database/Entities/lab_table.dart';
import 'package:jjm_wqmis/database/Entities/labincharge_table.dart';
import 'package:jjm_wqmis/database/Entities/parameter_table.dart';
import 'package:jjm_wqmis/database/Entities/scheme_table.dart';
import 'package:jjm_wqmis/database/Entities/source_table.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';

import 'package:jjm_wqmis/database/Dao/habitationDao.dart';
import 'package:jjm_wqmis/database/Dao/watersourcefilterDao.dart';
import 'package:jjm_wqmis/database/Entities/habitation_table.dart';
import 'package:jjm_wqmis/database/Entities/watersourcefilter_table.dart';

// Import the generated file
part 'package:jjm_wqmis/database.g.dart'; // VERY IMPORTANT!
@Database(
  version: 1,
  entities: [
    HabitationTable,
    WaterSourceFilter,
    SchemeEntity,
    SourcesEntity,
    LabEntity,
    ParameterEntity,
    LabInchargeEntity,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  HabitationDao get habitationDao;
  WaterSourceFilterDao get waterSourceFilterDao;
  SchemeDao get schemeDao;
  SourcesDao get sourcesDao;
  LabDao get labDao;
  ParameterDao get parameterDao;
  LabInchargeDao get labInchargeDao;

  // ✅ Add this method
  static AppDatabase? _instance;

  static Future<AppDatabase> getDatabase() async {
    if (_instance != null) return _instance!;

    final dbPath = await sqflite.getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    _instance = await $FloorAppDatabase.databaseBuilder(path).build();
    return _instance!;
  }
}
