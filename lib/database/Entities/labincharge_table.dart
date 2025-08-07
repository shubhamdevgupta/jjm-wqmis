import 'package:floor/floor.dart';

@Entity(tableName: 'LabIncharge')
class LabInchargeEntity {
  @PrimaryKey()
  final int lab_id;
  final int stateid;
  final String lab_name;
  final String lab_address;
  final String LabIncharge;

  LabInchargeEntity({
    required this.lab_id,
    required this.stateid,
    required this.lab_name,
    required this.lab_address,
    required this.LabIncharge,
  });
}
