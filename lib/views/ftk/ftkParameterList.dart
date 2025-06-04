import 'package:flutter/material.dart';

import 'ftkParameterScreen.dart';

class FtkParameterListScreen extends StatefulWidget {
  const FtkParameterListScreen({super.key});

  @override
  State<FtkParameterListScreen> createState() =>
      _FtkParameterListScreenState();
}

class _FtkParameterListScreenState extends State<FtkParameterListScreen> {
  final List<Map<String, String>> _staticParameters = [
    {
      "name": "Free Residual Chlorine",
      "info": "Unit: mg/l | Acceptable: 0.2 | Permissible: 1",
    },
    {
      "name": "pH",
      "info": "Acceptable: 6.5–8.5 | Permissible: No Relaxation",
    },
    {
      "name": "Turbidity",
      "info": "Unit: NTU | Acceptable: 1 | Permissible: 5",
    },
  ];

  late List<int?> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = List.filled(_staticParameters.length, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Water Quality Parameters")),
      body: ListView.builder(
        itemCount: _staticParameters.length,
        itemBuilder: (context, index) {
          final param = _staticParameters[index];
          return WaterQualityParameterCard(
            index: index,
            parameterName: param['name'] ?? 'Unknown',
            measurementInfo: param['info'] ?? '',
            selectedValue: _selectedValues[index],
            onChanged: (val) {
              setState(() {
                _selectedValues[index] = val;
              });
            },
          );
        },
      ),
    );
  }
}
