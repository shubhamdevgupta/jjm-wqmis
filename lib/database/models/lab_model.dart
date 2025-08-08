import 'package:jjm_wqmis/database/Entities/lab_table.dart';

class LabModel {
  final int stateId;
  final String labName;
  final int labId;
  final int isWtp;

  LabModel({
    required this.stateId,
    required this.labName,
    required this.labId,
    required this.isWtp,
  });

  factory LabModel.fromJson(Map<String, dynamic> json) {
    return LabModel(
      stateId: json['stateid'],
      labName: json['lab_name'],
      labId: json['lab_id'],
      isWtp: json['is_wtp'],
    );
  }

  LabEntity toEntity(){
    return LabEntity(lab_id: labId, stateid: stateId, lab_name: labName, is_wtp: isWtp);
  }

}
