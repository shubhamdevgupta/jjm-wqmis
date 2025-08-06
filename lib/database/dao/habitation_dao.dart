import 'package:drift/drift.dart';
import '../app_database.dart';


@DriftAccessor(tables: [Habitations])
class HabitationDao extends DatabaseAccessor<AppDatabase> with _$HabitationDaoMixin {
  HabitationDao(AppDatabase db) : super(db);

  Future<void> insertAll(List<HabitationsCompanion> habitations) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(habitationsTable, habitations);
    });
  }

  Future<List<Habitation>> getAll() => select(habitationsTable).get();

  Stream<List<Habitation>> watchAll() => select(habitationsTable).watch();

  Future<void> clear() async {
    await delete(habitationsTable).go();
  }
}
