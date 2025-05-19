import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vnua_service/screens/post/service/posts_service.dart';

class PostScreen extends StatefulWidget {
  final String searchKeyword;

  const PostScreen({super.key, this.searchKeyword = ""});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
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
        final titleRaw = (post['title'] ?? '').toString().toLowerCase();
        final contentRaw = (post['content'] ?? '').toString().toLowerCase();

        final title = removeDiacritics(titleRaw);
        final content = removeDiacritics(contentRaw);

        return keywordWords
            .any((word) => title.contains(word) || content.contains(word));
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

    final limitedPosts = widget.searchKeyword.trim().isEmpty
        ? _filteredPosts.take(4).toList()
        : _filteredPosts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.searchKeyword.trim().isEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tin đăng dành cho bạn",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        const SizedBox(height: 12),
        ..._buildPostCards(limitedPosts),
      ],
    );
  }

  List<Widget> _buildPostCards(List<dynamic> posts) {
    return posts.map((post) {
      final title = post['title'] ?? '';
      final fullName = post['userDTO']?['fullName'] ?? '';
      final imageUrl =
          (post['imageStrings'] != null && post['imageStrings'].isNotEmpty)
              ? post['imageStrings'][0]
              : null;
      final createdAt = post['createAt'];
      final date = createdAt != null
          ? DateFormat('dd/MM/yyyy').format(DateTime.parse(createdAt))
          : '';

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: Image.network(
                    imageUrl,
                    width: 120,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Nguồn: $fullName",
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black54),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        date,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
