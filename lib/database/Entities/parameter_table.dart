import 'package:floor/floor.dart';

@Entity(tableName: 'Parameter')
class ParameterEntity {
  @PrimaryKey()
  final int ParameterId;
  final int stateid;
  final String lab_name;
  final int lab_id;
  final int is_wtp;
  final int dept_rate;
  final String ParameterName;

  ParameterEntity({
    required this.ParameterId,
    required this.stateid,
    required this.lab_name,
    required this.lab_id,
    required this.is_wtp,
    required this.dept_rate,
    required this.ParameterName,
  });
}
