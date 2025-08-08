import 'package:jjm_wqmis/database/models/habitation_model.dart';
import 'package:jjm_wqmis/database/models/lab_incharge_model.dart';
import 'package:jjm_wqmis/database/models/lab_model.dart';
import 'package:jjm_wqmis/database/models/parameter_model.dart';
import 'package:jjm_wqmis/database/models/scheme_model.dart';
import 'package:jjm_wqmis/database/models/source_model.dart';
import 'package:jjm_wqmis/database/models/water_source_filter_model.dart';

class MasterVillageData {
  final List<HabitationModel> habitations;
  final List<WaterSourceFilterModel> waterSourceFilters;
  final List<SchemeModel> schemes;
  final List<SourceModel> sources;
  final List<LabModel> labs;
  final List<ParameterModel> parameters;
  final List<LabInchargeModel> labIncharges;

  MasterVillageData({
    required this.habitations,
    required this.waterSourceFilters,
    required this.schemes,
    required this.sources,
    required this.labs,
    required this.parameters,
    required this.labIncharges,
  });

  factory MasterVillageData.fromJson(Map<String, dynamic> json) {
    return MasterVillageData(
      habitations: (json['habitations'] as List<dynamic>)
          .map((e) => HabitationModel.fromJson(e))
          .toList(),
      waterSourceFilters: (json['water_source_filter'] as List<dynamic>)
          .map((e) => WaterSourceFilterModel.fromJson(e))
          .toList(),
      schemes: (json['Scheme'] as List<dynamic>)
          .map((e) => SchemeModel.fromJson(e))
          .toList(),
      sources: (json['Sources'] as List<dynamic>)
          .map((e) => SourceModel.fromJson(e))
          .toList(),
      labs: (json['Lab'] as List<dynamic>)
          .map((e) => LabModel.fromJson(e))
          .toList(),
      parameters: (json['Parameter'] as List<dynamic>)
          .map((e) => ParameterModel.fromJson(e))
          .toList(),
      labIncharges: (json['LabIncharge'] as List<dynamic>)
          .map((e) => LabInchargeModel.fromJson(e))
          .toList(),
    );
  }
}