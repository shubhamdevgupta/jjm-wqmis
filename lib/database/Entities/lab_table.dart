import 'package:floor/floor.dart';

@Entity(tableName: 'Lab')
class LabEntity {
  @PrimaryKey()
  final int lab_id;
  final int stateid;
  final String lab_name;
  final int is_wtp;

  LabEntity({
    required this.lab_id,
    required this.stateid,
    required this.lab_name,
    required this.is_wtp,
  });
}
