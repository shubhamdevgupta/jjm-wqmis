import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/CustomDropdown.dart';

class Rawwatersourceselection extends StatefulWidget {
  final Function(int?) onSourceChanged;
  final Function(int?) onSubSourceChanged;
  final Function(int?) onPwsTypeChanged;
  final Function(String?) onWaterSourceChanged;
  final List<String> districtList;

  Rawwatersourceselection({
    required this.onSourceChanged,
    required this.onSubSourceChanged,
    required this.onPwsTypeChanged,
    required this.onWaterSourceChanged,
    required this.districtList,
  });

  @override
  _WaterSourceSelectionState createState() => _WaterSourceSelectionState();
}

class _WaterSourceSelectionState extends State<Rawwatersourceselection> {
  int? _selectedSource;
  int? _selectedSubSource;
  int? _selectedPwsType;
  String? _selectedWaterSource;
  String _currentDateTime = DateFormat('yyyy/MM/dd hh:mm a').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        // First Visibility Widget with Border
        Visibility(
          visible: _selectedSource == 1,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Sub-Source:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: _selectedSubSource,
                      onChanged: (value) {
                        setState(() {
                          _selectedSubSource = value as int?;
                          widget.onSubSourceChanged(_selectedSubSource);
                        });
                      },
                    ),
                    Text('Ground water sources (GW)')
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 2,
                      groupValue: _selectedSubSource,
                      onChanged: (value) {
                        setState(() {
                          _selectedSubSource = value as int?;
                          widget.onSubSourceChanged(_selectedSubSource);
                        });
                      },
                    ),
                    Text('Surface water sources (SW)')
                  ],
                ),
              ],
            ),
          ),
        ),
        // Second Visibility Widget with Border
        Visibility(
          visible: _selectedSubSource != null,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PWS Type:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: _selectedPwsType,
                      onChanged: (value) {
                        setState(() {
                          _selectedPwsType = value as int?;
                          widget.onPwsTypeChanged(_selectedPwsType);
                        });
                      },
                    ),
                    Text('PWS with FHTC'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 2,
                      groupValue: _selectedPwsType,
                      onChanged: (value) {
                        setState(() {
                          _selectedPwsType = value as int?;
                          widget.onPwsTypeChanged(_selectedPwsType);
                        });
                      },
                    ),
                    Text('PWS without FHTC'),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Visibility(
          visible: _selectedPwsType != null,
          child: CustomDropdown(
            title: "Select Water Source *",
            value: _selectedWaterSource,
            items: widget.districtList,
            onChanged: (value) {
              setState(() {
                _selectedWaterSource = value;
                widget.onWaterSourceChanged(_selectedWaterSource);
              });
            },
          ),
        ),
        SizedBox(height: 16),
        Visibility(
          visible: _selectedPwsType != null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date & Time of Sample Collection *',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      DateTime combinedDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );

                      if (combinedDateTime.isBefore(DateTime.now()) ||
                          combinedDateTime.isAtSameMomentAs(DateTime.now())) {
                        String formattedDateTime = DateFormat('yyyy/MM/dd hh:mm a')
                            .format(combinedDateTime);

                        setState(() {
                          _currentDateTime = formattedDateTime;
                        });
                      }
                    }
                  }
                },
                child: IgnorePointer(
                  child: TextFormField(
                    controller: TextEditingController(text: _currentDateTime),
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Select Date & Time',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
