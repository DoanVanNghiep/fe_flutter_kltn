import 'package:flutter/material.dart';
import 'package:vnua_service/generated/l10n.dart';
import 'package:vnua_service/res/color.dart';
import 'package:vnua_service/route/route_constants.dart' as router;

class PriceRangeSection extends StatefulWidget {
  final void Function(String searchKeyword)? onSearch;

  const PriceRangeSection({super.key, this.onSearch});

  @override
  State<PriceRangeSection> createState() => _PriceRangeSectionState();
}

class _PriceRangeSectionState extends State<PriceRangeSection> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Nền trắng toàn màn hình bên dưới khi focus
        if (_isFocused)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                _focusNode.unfocus();
              },
              child: Container(
                color: Colors.white,
              ),
            ),
          ),
        // Thanh tìm kiếm
        Container(
          width: double.infinity, // <-- chiếm toàn bộ bề ngang
          color: AppColors.secondary400,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _searchController,
                    onChanged: (value) {
                      widget.onSearch?.call(value);
                    },
                    decoration: InputDecoration(
                      hintText: S.current.generated_search_rental_rooms,
                      hintStyle: const TextStyle(fontSize: 14),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none, size: 20),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      router.notificationsScreenRoute,
                      (route) => false,
                    );
                  },
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chat_bubble_outline, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
