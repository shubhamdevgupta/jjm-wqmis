class AllLabResponse {
  final bool? disabled;
  final String? group;
  final bool? selected;
  final String? text;
  final String? value;

  AllLabResponse({
     this.disabled,
     this.group,
     this.selected,
     this.text,
     this.value,
  });

  factory AllLabResponse.fromJson(Map<String, dynamic> json) {
    return AllLabResponse(
      disabled: json['Disabled'],
      group: json['Group'],
      selected: json['Selected'],
      text: json['Text'],
      value: json['Value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Disabled': disabled,
      'Group': group,
      'Selected': selected,
      'Text': text,
      'Value': value,
    };
  }

  @override
  String toString() {
    return 'WaterAnalysisLab(disabled: $disabled, group: $group, selected: $selected, text: "$text", value: "$value")';
  }
}

List<AllLabResponse> parseLabs(List<dynamic> jsonList) {
  return jsonList.map((json) => AllLabResponse.fromJson(json)).toList();
}
