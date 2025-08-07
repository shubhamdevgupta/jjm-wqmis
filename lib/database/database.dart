import 'dart:async';
import 'package:floor/floor.dart';
import 'package:jjm_wqmis/database/Dao/habitationDao.dart';
import 'package:jjm_wqmis/database/Dao/watersourcefilterDao.dart';
import 'package:jjm_wqmis/database/Entities/habitation_table.dart';
import 'package:jjm_wqmis/database/Entities/watersourcefilter_table.dart';

import 'package:sqflite/sqflite.dart' as sqflite;
part 'database.g.dart';      // ✅ correct (matches file name)


@Database(version: 1, entities: [Habitation, WaterSourceFilter])
abstract class AppDatabase extends FloorDatabase {
  HabitationDao get habitationDao;
  WaterSourceFilterDao get waterSourceFilterDao;
}
