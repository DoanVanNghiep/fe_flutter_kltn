import 'package:flutter/material.dart';

class SearchHistoryScreen extends StatefulWidget {
  final List<String> searchHistory;
  final List<String> suggestionList;

  const SearchHistoryScreen({
    super.key,
    required this.searchHistory,
    required this.suggestionList,
  });

  @override
  State<SearchHistoryScreen> createState() => _SearchHistoryScreenState();
}

class _SearchHistoryScreenState extends State<SearchHistoryScreen> {
  final TextEditingController _controller = TextEditingController();
  String query = '';

  @override
  Widget build(BuildContext context) {
    // Lọc suggestion theo query
    final filteredSuggestions = widget.suggestionList
        .where((s) => s.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.chevron_left, size: 30),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Tìm quận, đường...',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        query = value;
                      });
                    },
                    onSubmitted: (value) {
                      Navigator.pop(context, value);
                    },
                  ),
                ),
                if (_controller.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      setState(() => query = '');
                    },
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Huỷ", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          if (query.isEmpty) ...[
            const Text("Tìm quanh đây", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            const Text("Lịch sử tìm kiếm", style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 8),
            ...widget.searchHistory.map(
                  (item) => ListTile(
                leading: const Icon(Icons.access_time, color: Colors.grey),
                title: Text(item),
                onTap: () => Navigator.pop(context, item),
              ),
            ),
          ] else ...[
            const Text("Tìm quanh đây", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            const Text("Gợi ý", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            ...filteredSuggestions.map(
                  (item) => ListTile(
                leading: const Icon(Icons.search, color: Colors.grey),
                title: Text(item),
                onTap: () => Navigator.pop(context, item),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
