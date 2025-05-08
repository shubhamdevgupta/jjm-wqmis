import 'package:flutter/material.dart';

import 'AppStyles.dart';

class CustomDropdown extends StatefulWidget {
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final String title;
  final ValueChanged<String?>? onChanged;
  final String? appBarTitle;
  final bool showSearchBar;

  const CustomDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.title,
    required this.onChanged,
    this.appBarTitle,
    this.showSearchBar = true,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value ?? '';
  }
  @override
  void didUpdateWidget(covariant CustomDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() {
        selectedValue = widget.value ?? '';
      });
    }
  }
  void _openSearchDialog() {
    if (widget.items.isEmpty) return; // Prevent opening when list is empty
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Search',
      pageBuilder: (context, anim1, anim2) {
        return _SearchDialog(
          items: widget.items,
          onItemSelected: (value) {
            setState(() {
              selectedValue = value;
            });
            widget.onChanged?.call(value);
          },
          appBarTitle: widget.appBarTitle,
          showSearchBar: widget.showSearchBar,
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(anim1),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String label = "--Select--";
    if (selectedValue != null && selectedValue!.isNotEmpty) {
      final matchedItem = widget.items.firstWhere(
            (item) => item.value == selectedValue,
        orElse: () => DropdownMenuItem(value: '', child: const Text('')),
      );
      label = (matchedItem.child as Text).data ?? "--Select--";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty)
          RichText(
            text: TextSpan(
              text: widget.title.replaceAll('*', ''),
                style: AppStyles.textStyleBoldBlack16,
              children: widget.title.contains('*')
                  ? const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold, fontFamily: 'OpenSans',
                  ),
                ),
              ]
                  : [],
            ),
          ),
        const SizedBox(height: 8),
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
                    label,
                    style: TextStyle(
                      fontSize: 16, fontFamily: 'OpenSans',
                      color: (selectedValue == null || selectedValue!.isEmpty)
                          ? Colors.black54
                          : Colors.black,
                    ),
                    maxLines: 1,
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

// Fullscreen searchable dropdown
class _SearchDialog extends StatefulWidget {
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String> onItemSelected;
  final String? appBarTitle;
  final bool showSearchBar;

  const _SearchDialog({
    Key? key,
    required this.items,
    required this.onItemSelected,
    this.appBarTitle,
    this.showSearchBar = true,
  }) : super(key: key);

  @override
  __SearchDialogState createState() => __SearchDialogState();
}

class __SearchDialogState extends State<_SearchDialog> {
  late List<DropdownMenuItem<String>> filteredItems;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = widget.items.where((item) {
        final label = (item.child as Text).data ?? '';
        return label.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.appBarTitle ?? "Select Item", style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color:
            Colors.white, // Dark text for better readability
            fontFamily: 'OpenSans'

        ),),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (widget.showSearchBar)
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  onChanged: _filterItems,
                ),
              ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: widget.showSearchBar
                    ? filteredItems.length
                    : widget.items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = widget.showSearchBar
                      ? filteredItems[index]
                      : widget.items[index];
                  return ListTile(
                    title: Text((item.child as Text).data ?? ''),
                    onTap: () {
                      widget.onItemSelected(item.value!);
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
