import 'package:jjm_wqmis/database/Entities/labincharge_table.dart';

class LabInchargeModel {
  final int stateId;
  final int labId;
  final String labName;
  final String labAddress;
  final String labIncharge;

  LabInchargeModel({
    required this.stateId,
    required this.labId,
    required this.labName,
    required this.labAddress,
    required this.labIncharge,
  });

  factory LabInchargeModel.fromJson(Map<String, dynamic> json) {
    return LabInchargeModel(
      stateId: json['stateid'],
      labId: json['lab_id'],
      labName: json['lab_name'],
      labAddress: json['lab_address'],
      labIncharge: json['LabIncharge'],
    );
  }
  LabInchargeEntity toEntity(){
    return LabInchargeEntity(lab_id: labId, stateid: stateId, lab_name: labName, lab_address: labAddress, LabIncharge: labIncharge);

  }
}
