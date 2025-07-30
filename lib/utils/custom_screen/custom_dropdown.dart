import 'package:flutter/material.dart';
import 'package:jjm_wqmis/utils/app_style.dart';

class CustomDropdown extends StatefulWidget {
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final String title;
  final ValueChanged<String?>? onChanged;
  final String? appBarTitle;
  final bool showSearchBar;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.title,
    required this.onChanged,
    this.appBarTitle,
    this.showSearchBar = true,
  });
  static void openSearchDialog<T>({
    required BuildContext context,
    required String title,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    String? appBarTitle,
    bool showSearchBar = true,
  }) {
    if (items.isEmpty) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Search',
      pageBuilder: (context, anim1, anim2) {
        return _SearchDialog<T>(
          items: items,
          onItemSelected: (selected) {
            onChanged.call(selected);
          },
          appBarTitle: appBarTitle ?? title,
          showSearchBar: showSearchBar,
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

  @override
  Widget build(BuildContext context) {
    String label = "--Select--";
    try {
      if (selectedValue != null && selectedValue!.isNotEmpty) {
        final matchedItem = widget.items.firstWhere(
              (item) => item.value == selectedValue,
          orElse: () => const DropdownMenuItem(value: '', child: Text('--Select--')),
        );

        if (matchedItem.child is Text) {
          final childText = matchedItem.child as Text;
          if (childText.data != null && childText.data!.trim().isNotEmpty) {
            label = childText.data!;
          }
        }
      }
    } catch (_) {
      label = "--Select--";
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
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ]
                  : [],
            ),
          ),
        const SizedBox(height: 8),
        GestureDetector(
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
                      fontSize: 16,
                      fontFamily: 'OpenSans',
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

// Search dialog component
class _SearchDialog<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T> onItemSelected;
  final String? appBarTitle;
  final bool showSearchBar;

  const _SearchDialog({
    required this.items,
    required this.onItemSelected,
    this.appBarTitle,
    this.showSearchBar = true,
  });

  @override
  __SearchDialogState<T> createState() => __SearchDialogState<T>();
}


class __SearchDialogState<T> extends State<_SearchDialog<T>> {
  late List<DropdownMenuItem<T>> filteredItems;
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
    final itemsToShow = widget.showSearchBar ? filteredItems : widget.items;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.appBarTitle ?? "Select Item",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'OpenSans',
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.close,color: Colors.white,),
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                itemCount: itemsToShow.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = itemsToShow[index];
                  return ListTile(
                    title: item.child,
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
