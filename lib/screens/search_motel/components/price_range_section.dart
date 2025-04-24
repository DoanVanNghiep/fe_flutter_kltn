import 'package:flutter/material.dart';
import 'search_history_screen.dart';
import '../../search_motel/services/provinces_service.dart';

class PriceRangeSection extends StatefulWidget {
  final void Function(String searchKeyword)? onSearch;

  const PriceRangeSection({super.key, this.onSearch});

  @override
  State<PriceRangeSection> createState() => _PriceRangeSectionState();
}

class _PriceRangeSectionState extends State<PriceRangeSection> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _searchHistory = [
    "Giá 3 tr",
    "M28 3TR",
    "3tr",
    "Gia Lâm, Hà Nội",
    "Hà Nội",
  ];

  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    final suggestions = await ProvinceService.getAllLocationNames();
    setState(() {
      _suggestions = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade100,
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            readOnly: true,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchHistoryScreen(
                    searchHistory: _searchHistory,
                    suggestionList: _suggestions,
                  ),
                ),
              );
              if (result != null) {
                setState(() {
                  _searchController.text = result;
                });
                // Gọi callback khi người dùng chọn từ khóa
                widget.onSearch?.call(result);
              }
            },
            decoration: InputDecoration(
              hintText: "Tìm quận, đường...",
              hintStyle: const TextStyle(fontSize: 14),
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
