import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateTimePicker extends StatefulWidget {
  final Function(String) onDateTimeSelected;
  final String? textTitle;

  const CustomDateTimePicker({
    super.key,
    required this.onDateTimeSelected,
    this.textTitle = "Date & Time of Sample Collection *",
  });

  @override
  _CustomDateTimePickerState createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyParent();
    });
  }

  void _notifyParent() {
    final formatted = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(_selectedDateTime);
    widget.onDateTimeSelected(formatted);
  }

  @override
  Widget build(BuildContext context) {
    final displayText = DateFormat('dd MMM yyyy, hh:mm a').format(_selectedDateTime);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((widget.textTitle ?? "").isNotEmpty)
            Text(
              widget.textTitle!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
                fontFamily: 'OpenSans',
              ),
            ),
          const SizedBox(height: 8),
          InkWell(
            onTap: null, // Tap disabled – does nothing
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.blueGrey),
                  const SizedBox(width: 10),
                  Text(
                    displayText,
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
        ],
      ),
    );
  }
}
