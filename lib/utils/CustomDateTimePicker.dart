import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateTimePicker extends StatefulWidget {
  final Function(String) onDateTimeSelected;

  const CustomDateTimePicker({super.key, required this.onDateTimeSelected});

  @override
  _CustomDateTimePickerState createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  String _selectedDateTime = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setCurrentDateTime();
    });  }

  void _setCurrentDateTime() {
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(now);

    _selectedDateTime = formattedDateTime;

    Future.delayed(Duration.zero, () {
      widget.onDateTimeSelected(_selectedDateTime);
    });
  }



  Future<void> _selectDateTime(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: now, // Restrict future dates
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now), // Default to current time
      );

      if (pickedTime != null) {
        DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        if (combinedDateTime.isAfter(now)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Future time is not allowed.'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          String formattedDateTime =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(combinedDateTime);

          setState(() {
            _selectedDateTime = formattedDateTime;
          });

          widget.onDateTimeSelected(_selectedDateTime);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Date & Time of Sample Collection *',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
              fontFamily: 'OpenSans',
            ),
          ),
          const SizedBox(height: 8),
          IgnorePointer( // 👈 disables taps inside
            child: InkWell(
              onTap: () => _selectDateTime(context), // This will be ignored
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.blueGrey),
                    const SizedBox(width: 10),
                    Text(
                      _selectedDateTime,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }
}
