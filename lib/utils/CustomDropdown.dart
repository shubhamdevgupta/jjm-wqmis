/*
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final String title;
  final ValueChanged<String?>? onChanged;

  const CustomDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.title,
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
        ),
        SizedBox(height: 8), // Space between title and dropdown
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.blueAccent),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blueGrey, width: 2),
            ),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.redAccent,width: 2)
            ),
            contentPadding:
            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          ),
          items: items,
          onChanged: onChanged,
          dropdownColor: Colors.white,
          isExpanded: true,
          
          style: TextStyle(color: Colors.black, fontSize: 16),
          icon: Icon(Icons.arrow_drop_down),
          borderRadius: BorderRadius.circular(8),
          hint: Text('-select-'),
        ),
      ],
    );
  }
}
*/
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final String title;
  final ValueChanged<String?>? onChanged;

  const CustomDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.title,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns the title to the left
      children: [
        // RichText for the title and asterisk handling
        RichText(
          text: TextSpan(
            text: title.contains('*')
                ? title.replaceAll('*', '') // Remove '*' from title
                : title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            children: title.contains('*')
                ? [
              TextSpan(
                text: ' *', // Add red asterisk to indicate required field
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
                : [],
          ),
        ),
        const SizedBox(height: 8), // Space between title and dropdown
        // Updated UI for dropdown button with card and rounded corners
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.black),  // Change label color to black
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.grey, width: 1),  // Grey border when not focused
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey, width: 1),  // Grey border when focused
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.redAccent, width: 2),  // Red border for error state
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              fillColor: Colors.white,  // Set background color to white
              filled: true,  // Ensures background color is applied
            ),
            items: items,
            onChanged: onChanged,
            dropdownColor: Colors.white,  // Set dropdown color to white
            isExpanded: true,
            style: TextStyle(color: Colors.black, fontSize: 16),  // Set text color to black
            icon: Icon(Icons.arrow_drop_down, color: Colors.black),  // Set icon color to black
            borderRadius: BorderRadius.circular(5),
            hint: Text(
              "select",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54 ,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // Apply ellipsis ONLY for selected value
            ),  // Placeholder color to be more readable
          ),
        )


      ],
    );
  }
}
/*

Text(
"select",
style: TextStyle(
fontSize: 16,
color: selectedValue == null ? Colors.black54 : Colors.black,
),
maxLines: 1,
overflow: TextOverflow.ellipsis, // Apply ellipsis ONLY for selected value
)*/
