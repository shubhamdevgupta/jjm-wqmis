import 'package:flutter/material.dart';

class WaterQualityParameterCard extends StatelessWidget {
  final int index;
  final String parameterName;
  final String measurementInfo;
  final int? selectedValue;
  final ValueChanged<int?> onChanged;

  const WaterQualityParameterCard({
    super.key,
    required this.index,
    required this.parameterName,
    required this.measurementInfo,
    required this.selectedValue,
    required this.onChanged,
  });

  /// Determines background color based on selected value
  Color _getCardBackgroundColor() {
    if (selectedValue == 1) {
      return Colors.green.withOpacity(0.8);
    } else if (selectedValue == 0) {
      return Colors.red.withOpacity(0.8);
    } else if (selectedValue == -1) {
      return Colors.blue.withOpacity(0.8);
    } else {
      // default not selected
      return Colors.white.withOpacity(0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color cardBackgroundColor = _getCardBackgroundColor();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                Text("${index + 1}.",
                    style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(parameterName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600,color: Colors.black)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(measurementInfo,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,color: Colors.black)),
            const SizedBox(height: 12),

            // Radio options
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;
                return Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 4,
                  runSpacing: 2,
                  direction: isMobile ? Axis.vertical : Axis.horizontal,
                  children: [
                    _buildRadioOption(1, "Yes", Colors.black),
                    _buildRadioOption(0, "No", Colors.black),
                    _buildRadioOption(-1, "Not tested", Colors.black),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(int value, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<int>(
          value: value,
          groupValue: selectedValue,
          onChanged: onChanged,
          activeColor: color,
        ),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}
