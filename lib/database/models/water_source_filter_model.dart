import 'package:jjm_wqmis/database/Entities/watersourcefilter_table.dart';

class WaterSourceFilterModel {
  final int id;
  final String sourceType;

  WaterSourceFilterModel({
    required this.id,
    required this.sourceType,
  });

  factory WaterSourceFilterModel.fromJson(Map<String, dynamic> json) {
    return WaterSourceFilterModel(
      id: json['Id'],
      sourceType: json['SourceType'],
    );
  }

   WaterSourceFilter toEntity(){
    return WaterSourceFilter(id, sourceType);

   }
}
