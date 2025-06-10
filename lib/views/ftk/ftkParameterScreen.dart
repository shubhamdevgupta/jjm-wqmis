import 'package:flutter/material.dart';

class WaterQualityParameterCard extends StatelessWidget {
  final int index;
  final String parameterName;
  final String measurementUnit;
  final String acceptableLimit;
  final String permissibleLimit;
  final int? selectedValue;
  final ValueChanged<int?> onChanged;

  const WaterQualityParameterCard({
    super.key,
    required this.index,
    required this.parameterName,
    required this.measurementUnit,
    required this.acceptableLimit,
    required this.permissibleLimit,
    required this.selectedValue,
    required this.onChanged,
  });

  Color _getBorderColor() {
    switch (selectedValue) {
      case 1:
        return Colors.green;
      case 0:
        return Colors.red;
      case 2:
        return Colors.blue;
      default:
        return Colors.grey.shade300;
    }
  }
  List<Color> _getGradientColors() {
    switch (selectedValue) {
      case 1: // Yes
        return [Colors.green.shade100, Colors.green.shade200];
      case 0: // No
        return [Colors.red.shade100, Colors.red.shade200];
      case 2: // Not Tested
        return [Colors.blue.shade100, Colors.blue.shade200];
      default:
        return [Colors.grey.shade100, Colors.grey.shade200];
    }
  }
  Color _getIconColor() {
    switch (selectedValue) {
      case 1:
        return Colors.green.shade700;
      case 0:
        return Colors.red.shade700;
      case 2:
        return Colors.blue.shade700;
      default:
        return Colors.grey.shade600;
    }
  }
  Color _getLabelColor() {
    switch (selectedValue) {
      case 1:
        return Colors.green.shade100;
      case 0:
        return Colors.red.shade100;
      case 2:
        return Colors.blue.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getLabelTextColor() {
    switch (selectedValue) {
      case 1:
        return Colors.green.shade800;
      case 0:
        return Colors.red.shade800;
      case 2:
        return Colors.blue.shade800;
      default:
        return Colors.black54;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getBorderColor(), width: 2),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title with index
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getLabelColor(),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  ' ${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: _getLabelTextColor(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  parameterName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Measurement info section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _getGradientColors(),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _getBorderColor(), width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(Icons.straighten, "Measurement Unit", measurementUnit),
                const SizedBox(height: 6),
                _infoRow(Icons.check_circle_outline, "Acceptable Limit", acceptableLimit),
                const SizedBox(height: 6),
                _infoRow(Icons.warning_amber_outlined, "Permissible Limit", permissibleLimit),
              ],
            ),
          ),


          const SizedBox(height: 16),

          /// Selection buttons
          Row(
            children: [
              _buildChoiceButton("Yes", 1, Colors.green),
              _buildChoiceButton("No", 0, Colors.red),
              _buildChoiceButton("Not Tested", 2, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _getIconColor(), size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              children: [
                TextSpan(
                  text: "$label: ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceButton(String label, int value, Color color) {
    final bool isSelected = selectedValue == value;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? color : Colors.grey.shade100,
            foregroundColor: isSelected ? Colors.white : Colors.black87,
            elevation: isSelected ? 3 : 0,
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: isSelected ? color : Colors.grey.shade300,
                width: 1.2,
              ),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          onPressed: () => onChanged(value),
          child: Text(label, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
