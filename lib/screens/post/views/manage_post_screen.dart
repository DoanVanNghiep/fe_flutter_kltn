// Quản lý tin đăng
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:vnua_service/screens/post/service/posts_service.dart';

class ManagePostsScreen extends StatefulWidget {
  const ManagePostsScreen({super.key});

  @override
  State<ManagePostsScreen> createState() => _ManagePostsScreenState();
}

class _ManagePostsScreenState extends State<ManagePostsScreen> {
  int currentTab = 0;
  int currentPage = 0;
  final int limit = 10;
  bool isLoading = true;
  bool hasMore = true;
  List<dynamic> allPosts = [];

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    } catch (e) {
      return "Không rõ";
    }
  }

  final tabs = [
    "Tất cả",
    "Đang hiển thị",
    "Đang ẩn",
    "Đang chờ duyệt",
    "Từ chối"
  ];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts({bool loadMore = false}) async {
    if (loadMore && !hasMore) return;

    if (!loadMore) {
      setState(() {
        isLoading = true;
        currentPage = 0;
        hasMore = true;
        allPosts.clear();
      });
    }

    final posts = await PostsService().getPostsByUser(
      start: currentPage * limit,
      limit: limit,
    );

    setState(() {
      if (posts.length < limit) hasMore = false;
      allPosts.addAll(posts);
      isLoading = false;
      currentPage++;
    });
  }

  List<dynamic> get filteredPosts {
    return allPosts.where((post) {
      final isApproved = post["approved"] == true;
      final isNotApproved = post["notApproved"] == true;
      final isDeleted = post["del"] == true;

      switch (currentTab) {
        case 1:
          return isApproved && !isNotApproved && !isDeleted; // Đang hiển thị
        case 2:
          return isDeleted; // Đang ẩn
        case 3:
          return isApproved && isNotApproved && !isDeleted; // Chờ duyệt
        case 4:
          return !isApproved && !isDeleted; // Bị từ chối
        default:
          return true; // Tất cả
      }
    }).toList();
  }

  String getPostStatus(Map<String, dynamic> post) {
    final isApproved = post["approved"] == true;
    final isNotApproved = post["notApproved"] == true;
    final isDeleted = post["del"] == true;

    if (isDeleted) return "Đã ẩn";
    if (isApproved && !isNotApproved) return "Đang hiển thị";
    if (isApproved && isNotApproved) return "Đang chờ duyệt";
    if (!isApproved) return "Bị từ chối";
    return "Không xác định";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý tin đăng",
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.notifications_none)),
        ],
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(tabs.length, (index) {
                  final selected = currentTab == index;
                  return GestureDetector(
                    onTap: () => setState(() => currentTab = index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        children: [
                          Text(
                            tabs[index],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: selected ? Colors.teal : Colors.grey,
                            ),
                          ),
                          if (selected)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              height: 3,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const Divider(height: 1),

          // Danh sách bài viết
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredPosts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/empty-post.png", width: 120),
                            const SizedBox(height: 12),
                            const Text("Không tìm thấy tin đăng",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 6),
                            const Text(
                                "Không có bài viết nào trong trạng thái này"),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                // Điều hướng đăng tin
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text("Đăng tin"),
                            )
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: filteredPosts.length +
                            ((hasMore && filteredPosts.length > 5) ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < filteredPosts.length) {
                            final post = filteredPosts[index];
                            final b64Image = post['userDTO']?['b64'];
                            Uint8List? imageBytes;
                            if (b64Image != null &&
                                b64Image is String &&
                                b64Image.isNotEmpty) {
                              try {
                                imageBytes = base64Decode(b64Image);
                              } catch (_) {
                                imageBytes = null;
                              }
                            }

                            final statusText = getPostStatus(post);

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    // Ảnh
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: imageBytes != null
                                          ? Image.memory(imageBytes,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover)
                                          : Image.asset(
                                              "assets/images/room_default.jpg",
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover),
                                    ),
                                    const SizedBox(width: 12),

                                    // Tiêu đề và trạng thái
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              post["title"] ??
                                                  "Không có tiêu đề",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 4),
                                          Text("Trạng thái: $statusText",
                                              style: const TextStyle(
                                                  color: Colors.grey)),
                                          const SizedBox(height: 4),
                                          if (post["createAt"] != null)
                                            Text(
                                              "Ngày tạo: ${formatDate(post["createAt"])}",
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                        ],
                                      ),
                                    ),

                                    // Hành động
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.teal),
                                          onPressed: () {
                                            // Navigator.push(
                                            //   context,
                                            //   // MaterialPageRoute(
                                            //   //   builder: (_) => UpdatePostScreen(postId: post["id"]),
                                            //   // ),
                                            // );
                                          },
                                        ),
                                        if (statusText != "Đang chờ duyệt" &&
                                            statusText != "Bị từ chối")
                                          IconButton(
                                            icon: Icon(
                                              post["del"] == true
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.redAccent,
                                            ),
                                            onPressed: () async {
                                              final updated =
                                                  await PostsService()
                                                      .togglePostVisibility(
                                                          post["id"]);
                                              if (updated) {
                                                setState(() {
                                                  post["del"] =
                                                      !(post["del"] == true);
                                                });
                                              }
                                            },
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () => fetchPosts(loadMore: true),
                                  child: const Text("Tải thêm"),
                                ),
                              ),
                            );
                          }
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
