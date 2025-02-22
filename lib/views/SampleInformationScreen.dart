// Flutter layout for the 'Sample Information' form
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/CustomDropdown.dart';

void main() {
  runApp(Sampleinformationscreen());
}

class Sampleinformationscreen extends StatefulWidget {
  @override
  _Sampleinformationscreen createState() => _Sampleinformationscreen();
}

class _Sampleinformationscreen extends State<Sampleinformationscreen> {
  String? selectedDistrict;

  int? _selectedSource;
  int? _selectedSubSource;
  int? _selectedPwsType;

  String _selectedWaterSource =
      'Location : TUBEWELL [ Source type : Deep Tubewell ]';
  String _currentDateTime =
      DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now());

  List<String> districtList = [
    'Agra',
    'Aligarh',
    'Amethi',
    'Ayodhya',
    'Bareilly',
    'Gorakhpur',
    'Lucknow',
    'Varanasi',
    'Kanpur',
    'Meerut'
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sample collection form'),
          backgroundColor: Colors.blue[700],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  margin: EdgeInsets.all(0),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select village / habitaton',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'State *',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.0),
                                    child: DropdownButtonFormField<String>(
                                      value: 'Uttar Pradesh',
                                      // Set the initial value
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                      ),
                                      items: [
                                        DropdownMenuItem(
                                          value: 'Uttar Pradesh',
                                          child: Text('Uttar Pradesh'),
                                        ),
                                      ],
                                      onChanged: null,
                                      // Disable the dropdown
                                      dropdownColor: Colors.white,
                                      isExpanded: true,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconEnabledColor: Colors.grey,
                                      // Grey out the icon to indicate it's disabled
                                      iconDisabledColor: Colors.grey,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomDropdown(
                                    title: "District *",
                                    value: selectedDistrict,
                                    items: districtList,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDistrict = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomDropdown(
                                    title: "Block *",
                                    value: selectedDistrict,
                                    items: districtList,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDistrict = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomDropdown(
                                    title: "GP *",
                                    value: selectedDistrict,
                                    items: districtList,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDistrict = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        CustomDropdown(
                          title: "Village *",
                          value: selectedDistrict,
                          items: districtList,
                          onChanged: (value) {
                            setState(() {
                              selectedDistrict = value;
                            });
                          },
                        ),
                        SizedBox(height: 12),
                        CustomDropdown(
                          title: "Habitation *",
                          value: selectedDistrict,
                          items: districtList,
                          onChanged: (value) {
                            setState(() {
                              selectedDistrict = value;
                            });
                          },
                        ),
                        SizedBox(height: 12),
                        CustomDropdown(
                          title: "Select Scheme",
                          value: selectedDistrict,
                          items: districtList,
                          onChanged: (value) {
                            setState(() {
                              selectedDistrict = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Please select the location of source from where sample is taken:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 12),
                        Flexible(
                          child: DropdownButtonFormField<int>(
                            value: _selectedSource,
                            isExpanded: true,
                            // Ensures the dropdown takes full width inside Flexible
                            decoration: InputDecoration(
                              labelText: 'Select Source',
                              labelStyle: TextStyle(color: Colors.blueAccent),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 2),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 1,
                                child: Text(
                                  'Sources of Schemes (Raw water)',
                                  overflow: TextOverflow
                                      .ellipsis, // Adds "..." if text is too long
                                ),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text('WTP of PWS schemes (Treatment)'),
                              ),
                              DropdownMenuItem(
                                value: 3,
                                child: Text('Storage Structure (ESR/GSR)'),
                              ),
                              DropdownMenuItem(
                                value: 4,
                                child: Text('Households /school /AWCs'),
                              ),
                              DropdownMenuItem(
                                value: 5,
                                child: Text(
                                  'Handpumps and other private sources',
                                  overflow: TextOverflow
                                      .ellipsis, // Adds "..." if text is too long
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedSource = value;
                                _selectedSubSource = null;
                                _selectedPwsType = null;
                              });
                            },
                          ),
                        ),

                        SizedBox(height: 16),
                        // First Visibility Widget with Border
                        Visibility(
                          visible: _selectedSource == 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.blueAccent, width: 1.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(10),
                            // Inner padding
                            margin: EdgeInsets.only(top: 12),
                            // Spacing from the previous widget
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Align text to the left
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
                              border: Border.all(
                                  color: Colors.blueAccent, width: 1.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(10),
                            // Inner padding
                            margin: EdgeInsets.only(top: 12),
                            // Spacing from the first container
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
                            value: selectedDistrict,
                            items: districtList,
                            onChanged: (value) {
                              setState(() {
                                selectedDistrict = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                        Visibility(
                          visible: _selectedPwsType != null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                            children: [
                              Text(
                                'Date & Time of Sample Collection *',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8), // Add some spacing
                              InkWell(
                                onTap: () async {
                                  // Open Date Picker for Present and Past Dates Only
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(), // Start from today
                                    firstDate: DateTime(2000), // Set the earliest selectable date
                                    lastDate: DateTime.now(), // Disallow future dates
                                  );

                                  if (pickedDate != null) {
                                    // Check if the selected date is today
                                    bool isToday = pickedDate.isAtSameMomentAs(DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day,
                                    ));

                                    // Open Time Picker
                                    TimeOfDay? pickedTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    if (pickedTime != null) {
                                      // Combine Date and Time
                                      DateTime combinedDateTime = DateTime(
                                        pickedDate.year,
                                        pickedDate.month,
                                        pickedDate.day,
                                        pickedTime.hour,
                                        pickedTime.minute,
                                      );

                                      // Check if the selected date and time is valid
                                      if (isToday && combinedDateTime.isAfter(DateTime.now())) {
                                        // Show error if time is in the future for today
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text('Future time is not allowed for today.'),
                                          backgroundColor: Colors.red,
                                        ));
                                      } else {
                                        // Format Date and Time with AM/PM
                                        String formattedDateTime = DateFormat('yyyy/MM/dd hh:mm a')
                                            .format(combinedDateTime);

                                        // Save to State and Update UI
                                        setState(() {
                                          _currentDateTime = formattedDateTime;
                                        });
                                      }
                                    }
                                  }
                                },
                                child: IgnorePointer(
                                  // Makes the field non-editable but tappable
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
