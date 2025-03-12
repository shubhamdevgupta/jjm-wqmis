import 'package:flutter/material.dart';

class CustomSearchableDropdown extends StatefulWidget {
  final String? value;
  final List<String> items;
  final String title;
  final ValueChanged<String?>? onChanged;

  const CustomSearchableDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.title,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomSearchableDropdownState createState() =>
      _CustomSearchableDropdownState();
}

class _CustomSearchableDropdownState extends State<CustomSearchableDropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  void _openSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SearchDialog(
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        RichText(
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
                ? [
              const TextSpan(
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
        const SizedBox(height: 8),

        // Custom Dropdown Button with Search
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
                // Selected Value - Show ellipsis if too long
                Flexible(
                  child: Text(
                    selectedValue ?? "- Select -",
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedValue == null ? Colors.black54 : Colors.black,
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

// Custom Full-Screen Search Dialog with Dividers
class SearchDialog extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String> onItemSelected;

  const SearchDialog({
    Key? key,
    required this.items,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  late List<String> filteredItems;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select an Item"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Search Field
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

          // List of Filtered Items
          Expanded(
            child: ListView.separated(
              itemCount: filteredItems.length,
              separatorBuilder: (context, index) => const Divider(), // Adds a divider
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    filteredItems[index],
                    maxLines: null, // Show full text in list
                  ),
                  onTap: () {
                    widget.onItemSelected(filteredItems[index]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
