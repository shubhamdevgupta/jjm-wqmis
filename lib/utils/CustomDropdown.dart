import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
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
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value ?? ''; // Initialize with the passed value or an empty string
  }

  void _openSearchDialog() {
    if (widget.items.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return _SearchDialog(
            items: widget.items,
            onItemSelected: (value) {
              setState(() {
                selectedValue = value;
              });
              widget.onChanged?.call(value);
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with asterisk handling
        Visibility(
          visible: widget.title.isNotEmpty,
          child: RichText(
            text: TextSpan(
              text: widget.title.contains('*')
                  ? widget.title.replaceAll('*', '')
                  : widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              children: widget.title.contains('*')
                  ? const [
                TextSpan(
                  text: ' *',
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
        ),
        const SizedBox(height: 8), // Space between title and dropdown

        // Custom Dropdown UI
        GestureDetector(
          onTap: _openSearchDialog,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Display selected value, with ellipsis if too long
                Flexible(
                  child: Text(
                    selectedValue == null || selectedValue!.isEmpty
                        ? "--Select--" // If no value is selected
                        : widget.items
                        .firstWhere(
                          (item) => item.value == selectedValue,
                      orElse: () => DropdownMenuItem(value: '', child: const Text('')),
                    )
                        .child
                        .toString()
                        .replaceAll("Text(", "")
                        .replaceAll(")", ""),
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedValue == null || selectedValue!.isEmpty ? Colors.black54 : Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Apply ellipsis ONLY for selected value
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.black),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Search Dialog for searching through dropdown items
class _SearchDialog extends StatefulWidget {
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String> onItemSelected;

  const _SearchDialog({
    Key? key,
    required this.items,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  __SearchDialogState createState() => __SearchDialogState();
}

class __SearchDialogState extends State<_SearchDialog> {
  late List<DropdownMenuItem<String>> filteredItems;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = widget.items
          .where((item) => item.value!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text("Select Item", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: _filterItems,
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: filteredItems.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredItems[index].child.toString()),
                    onTap: () {
                      widget.onItemSelected(filteredItems[index].value!);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
