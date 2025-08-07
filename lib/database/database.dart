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

import 'package:jjm_wqmis/database/Dao/habitationDao.dart';
import 'package:jjm_wqmis/database/Dao/watersourcefilterDao.dart';
import 'package:jjm_wqmis/database/Entities/habitation_table.dart';
import 'package:jjm_wqmis/database/Entities/watersourcefilter_table.dart';



part 'database.g.dart'; // auto-generated file

@Database(
  version: 1,
  entities: [
    Habitation,
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

  // ✅ Add these DAO getters
  SchemeDao get schemeDao;
  SourcesDao get sourcesDao;
  LabDao get labDao;
  ParameterDao get parameterDao;
  LabInchargeDao get labInchargeDao;
}

//for updation flutter pub run build_runner build --delete-conflicting-outputs