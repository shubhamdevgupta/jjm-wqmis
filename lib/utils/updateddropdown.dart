import 'package:flutter/material.dart';

class UpdateCustomSearchableDropdown extends StatefulWidget {
  final String? selectedValue;
  final List<Map<String, String>> items;
  final String hint;
  final String appBarTitle;
  final Function(String?) onChanged;

  const UpdateCustomSearchableDropdown({
    super.key,
    this.selectedValue,
    required this.items,
    required this.hint,
    required this.appBarTitle,
    required this.onChanged,
  });

  @override
  State<UpdateCustomSearchableDropdown> createState() => _UpdateCustomSearchableDropdownState();
}

class _UpdateCustomSearchableDropdownState extends State<UpdateCustomSearchableDropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedValue;
  }

  void _openSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return _SearchDialog(
          items: widget.items,
          onItemSelected: (value) {
            setState(() {
              selectedValue = value;
            });
            widget.onChanged(value);
          },
          appBarTitle: widget.appBarTitle ?? "Select Item",
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final selectedItem = widget.items.firstWhere(
          (item) => item['schemeId'] == selectedValue,
      orElse: () => {},
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with required star if needed
        if (widget.hint.isNotEmpty)
          RichText(
            text: TextSpan(
              text: widget.hint.replaceAll('*', ''),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black, fontFamily: 'OpenSans',),
              children: widget.hint.contains('*')
                  ? const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'OpenSans',),
                ),
              ]
                  : [],
            ),
          ),
        const SizedBox(height: 6),
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
                Flexible(
                  child: Text(
                    selectedItem['schemeName'] ?? "--Select--",
                    style: TextStyle(
                      fontSize: 16, fontFamily: 'OpenSans',
                      color: selectedItem.isEmpty ? Colors.black54 : Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
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

class _SearchDialog extends StatefulWidget {
  final List<Map<String, String>> items;
  final ValueChanged<String> onItemSelected;
  final String appBarTitle;

  const _SearchDialog({
    required this.items,
    required this.onItemSelected,
    required this.appBarTitle,
  });

  @override
  State<_SearchDialog> createState() => _SearchDialogState();
}


class _SearchDialogState extends State<_SearchDialog> {
  List<Map<String, String>> filteredItems = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = widget.items
          .where((item) => item['schemeName']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle, style: const TextStyle(color: Colors.white, fontFamily: 'OpenSans',)),
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: _filterItems,
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredItems.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredItems[index]['schemeName'] ?? ''),
                  onTap: () {
                    widget.onItemSelected(filteredItems[index]['schemeId']!);
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
