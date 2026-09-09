import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TestingDateTimePicker extends StatelessWidget {
  final String title;

  final DateTime? selectedDateTime;

  final DateTime firstDate;
  final DateTime lastDate;

  final DateTime? minimumDateTime;

  final ValueChanged<DateTime> onChanged;

  final bool enabled;

  const TestingDateTimePicker({
    super.key,
    required this.title,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
    this.selectedDateTime,
    this.minimumDateTime,
    this.enabled = true,
  });

  DateTime _dateOnly(DateTime value) {
    return DateTime(
      value.year,
      value.month,
      value.day,
    );
  }

  Future<void> _pickDateTime(
      BuildContext context,
      ) async {
    if (!enabled) {
      return;
    }

    final calendarFirstDate =
    _dateOnly(firstDate);

    final calendarLastDate =
    _dateOnly(lastDate);

    DateTime initialDate =
        selectedDateTime ?? calendarLastDate;

    // ------------------------------------------------------------
    // Keep initial date inside calendar range
    // ------------------------------------------------------------

    if (initialDate.isBefore(calendarFirstDate)) {
      initialDate = calendarFirstDate;
    }

    if (initialDate.isAfter(calendarLastDate)) {
      initialDate = calendarLastDate;
    }

    // ------------------------------------------------------------
    // DATE PICKER
    // ------------------------------------------------------------

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: calendarFirstDate,
      lastDate: calendarLastDate,
      helpText: title,
    );

    if (pickedDate == null || !context.mounted) {
      return;
    }

    // ------------------------------------------------------------
    // TIME PICKER
    // ------------------------------------------------------------

    final initialTime = selectedDateTime != null
        ? TimeOfDay.fromDateTime(
      selectedDateTime!,
    )
        : TimeOfDay.now();

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime == null || !context.mounted) {
      return;
    }

    // ------------------------------------------------------------
    // FINAL DATETIME
    // ------------------------------------------------------------

    final result = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // ------------------------------------------------------------
    // TESTING MINIMUM GAP
    // ------------------------------------------------------------

    if (minimumDateTime != null &&
        result.isBefore(minimumDateTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sample testing time must be at least 5 minutes after sample collection.',
          ),
        ),
      );

      return;
    }

    // ------------------------------------------------------------
    // TESTING WINDOW START
    // ------------------------------------------------------------

    if (result.isBefore(firstDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Selected date is outside the allowed testing window.',
          ),
        ),
      );

      return;
    }

    // ------------------------------------------------------------
    // FUTURE DATE/TIME
    // ------------------------------------------------------------

    if (result.isAfter(lastDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Future date and time cannot be selected.',
          ),
        ),
      );

      return;
    }

    // ------------------------------------------------------------
    // SUCCESS
    // ------------------------------------------------------------

    onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final displayText = selectedDateTime == null
        ? 'Select date & time'
        : DateFormat(
      'dd MMM yyyy, hh:mm a',
    ).format(selectedDateTime!);

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
            fontFamily: 'OpenSans',
          ),
        ),

        const SizedBox(height: 8),

        InkWell(
          onTap: enabled
              ? () => _pickDateTime(context)
              : null,
          borderRadius:
          BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            padding:
            const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: enabled
                  ? Colors.grey[100]
                  : Colors.grey[200],
              borderRadius:
              BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  color: enabled
                      ? Colors.blueGrey
                      : Colors.grey,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    displayText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w500,
                      color: enabled
                          ? Colors.black87
                          : Colors.grey,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),

                const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blueGrey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}