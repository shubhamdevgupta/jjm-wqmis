import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String title; // Added title parameter
  final ValueChanged<String?>? onChanged;

  const CustomDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.title, // Initialize title
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns the title to the left
      children: [
        RichText(
          text: TextSpan(
            text: title.contains('*')
                ? title.replaceAll('*', '')
                : title, // Use the title as-is if no asterisk is present
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            children: title.contains('*')
                ? [
              TextSpan(
                text: ' *', // Add a red asterisk with a space before it
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
                : [], // If no asterisk, don't add any children
          ),
        )
        ,
        SizedBox(height: 5), // Space between title and dropdown
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.blueAccent),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blueAccent, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blueAccent, width: 2),
            ),
            contentPadding:
            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          ))
              .toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white,
          isExpanded: true,
          style: TextStyle(color: Colors.black, fontSize: 16),
          icon: Icon(Icons.arrow_drop_down),
          iconEnabledColor: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }
}
