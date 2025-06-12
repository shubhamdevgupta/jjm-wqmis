import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final bool isRequired;
  final TextEditingController controller; // Added controller

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.isRequired = false,
    required this.controller, // Required parameter for text controller
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
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16, fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
            ),
            children: isRequired
                ? [
              const TextSpan(
                text: '*', // Add a red asterisk
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18, fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
                : [],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: controller, // Assign controller here
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
