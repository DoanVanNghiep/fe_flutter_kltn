import 'package:flutter/material.dart';
import 'package:vnua_service/screens/post/service/posts_service.dart';
import 'mini_motel_card.dart';

class ExploreSection extends StatefulWidget {
  final String searchKeyword;

  const ExploreSection({super.key, this.searchKeyword = ""});

  @override
  State<ExploreSection> createState() => _ExploreSectionState();
}

class _ExploreSectionState extends State<ExploreSection> {
  final PostsService _postsService = PostsService();
  List<dynamic> _posts = [];
  List<dynamic> _filteredPosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final posts = await _postsService.getAllPosts();
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String removeDiacritics(String str) {
    const withDiacritics =
        'áàảãạâấầẩẫậăắằẳẵặđéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵ';
    const withoutDiacritics =
        'aaaaaaaaaaaaaaaaadeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyy';

    for (int i = 0; i < withDiacritics.length; i++) {
      str = str.replaceAll(withDiacritics[i], withoutDiacritics[i]);
    }
    return str;
  }

  void _applySearchFilter() {
    final rawKeyword = widget.searchKeyword.toLowerCase();
    final keyword = removeDiacritics(rawKeyword).trim();

    if (keyword.isEmpty) {
      _filteredPosts = [..._posts];
    } else {
      final keywordWords =
          keyword.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

      _filteredPosts = _posts.where((post) {
        final addressRaw = (post['accomodationDTO']?['address'] ?? '')
            .toString()
            .toLowerCase();
        final priceRaw =
            (post['accomodationDTO']?['price'] ?? '').toString().toLowerCase();

        final address = removeDiacritics(addressRaw);
        final price = removeDiacritics(priceRaw);

        return keywordWords
            .any((word) => address.contains(word) || price.contains(word));
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    _applySearchFilter();

    if (_filteredPosts.isEmpty) {
      return Center(
        child: Text(
          'Không tìm thấy kết quả cho "${widget.searchKeyword}"',
          style: const TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.searchKeyword.trim().isEmpty)
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Gợi ý cho bạn",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        if (widget.searchKeyword.trim().isEmpty) const SizedBox(height: 12),
        ..._buildRows(_filteredPosts),
      ],
    );
  }

  List<Widget> _buildRows(List<dynamic> posts) {
    List<Widget> rows = [];

    for (int i = 0; i < posts.length; i += 2) {
      final first = posts[i];
      final second = i + 1 < posts.length ? posts[i + 1] : null;

      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Expanded(child: MiniMotelCard(post: first)),
              const SizedBox(width: 10),
              Expanded(
                child: second != null
                    ? MiniMotelCard(post: second)
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      );
    }

    return rows;
  }
}
