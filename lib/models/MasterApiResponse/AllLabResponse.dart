class Alllabresponse {
  final bool disabled;
  final String? group;
  final bool selected;
  final String text;
  final String value;

  Alllabresponse({
    required this.disabled,
    required this.group,
    required this.selected,
    required this.text,
    required this.value,
  });

  factory Alllabresponse.fromJson(Map<String, dynamic> json) {
    return Alllabresponse(
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

List<Alllabresponse> parseLabs(List<dynamic> jsonList) {
  return jsonList.map((json) => Alllabresponse.fromJson(json)).toList();
}
