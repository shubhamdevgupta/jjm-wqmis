import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateTimePicker extends StatefulWidget {
  final Function(String) onDateTimeSelected;
  final String initialValue;

  const CustomDateTimePicker({
    Key? key,
    required this.onDateTimeSelected,
    this.initialValue = '',
  }) : super(key: key);

  @override
  _CustomDateTimePickerState createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  String _selectedDateTime = '';

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialValue;
  }

  Future<void> _selectDateTime(BuildContext context) async {
    // Open Date Picker for Present and Past Dates Only
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Start from today
      firstDate: DateTime(2000),   // Set the earliest selectable date
      lastDate: DateTime.now(),    // Disallow future dates
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Future time is not allowed for today.'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          // Format Date and Time with AM/PM
          String formattedDateTime =
          DateFormat('yyyy/MM/dd hh:mm a').format(combinedDateTime);

          // Save to State and Update UI
          setState(() {
            _selectedDateTime = formattedDateTime;
          });

          // Pass the selected date and time back to the parent widget
          widget.onDateTimeSelected(_selectedDateTime);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date & Time of Sample Collection *',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _selectDateTime(context),
            child: IgnorePointer(
              child: TextFormField(
                controller: TextEditingController(text: _selectedDateTime),
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: 'Select Date & Time',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
