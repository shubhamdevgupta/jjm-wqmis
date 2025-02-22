
import 'package:flutter/material.dart';

class Watertestingscreen extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String title; // Added title parameter
  final ValueChanged<String?>? onChanged;

  const Watertestingscreen({
    Key? key,
     this.value,
    required this.items,
    required this.title, // Initialize title
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(children: [

      ],
    );
  }
}