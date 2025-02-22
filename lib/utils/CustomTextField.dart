import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final bool isRequired;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: labelText.contains('*')
                ? labelText.replaceAll('*', '')
                : labelText, // Use the title as-is if no asterisk is present
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            children: labelText.contains('*')
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            ),
          ),
        ),
      ],
    );
  }
}
