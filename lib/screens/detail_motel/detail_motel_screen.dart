import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:vnua_service/screens/post/service/posts_service.dart';

class MotelDetailScreen extends StatefulWidget {
  final int postId;

  const MotelDetailScreen({super.key, required this.postId});

  @override
  State<MotelDetailScreen> createState() => _MotelDetailScreenState();
}

class _MotelDetailScreenState extends State<MotelDetailScreen> {
  final PostsService _postsService = PostsService();
  Map<String, dynamic>? postData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPostDetail();
  }

  Future<void> _loadPostDetail() async {
    try {
      final data = await _postsService.getPostById(widget.postId);

      if (data != null && data.isNotEmpty) {
        setState(() {
          postData = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          postData = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Lỗi khi load chi tiết bài đăng: $e");
      setState(() {
        postData = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (postData == null || postData!.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Không tìm thấy tin đăng.",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    final accommodation = postData!['accomodationDTO'] ?? {};
    final user = postData!['userDTO'] ?? {};

    final Uint8List? imageBytes = user['b64'] != null
        ? base64Decode(user['b64'])
        : null;

    final price = (accommodation['price'] ?? 0) ~/ 1000000;
    final address = accommodation['address'] ?? '';
    final acreage = accommodation['acreage']?.toDouble() ?? 0.0;
    final fullName = user['fullName'] ?? '';
    final phone = user['phone'] ?? '';
    final title = postData!['title'] ?? '';
    final createdAt = postData!['createAt']?.toString().split('T').first ?? '';
    final description = postData!['content'] ?? '';

    final utilities = <String>[
      if (accommodation['internet'] == true) "Wifi",
      if (accommodation['toilet'] == true) "WC riêng",
      if (accommodation['parking'] == true) "Giữ xe",
      if (accommodation['time'] == true) "Tự do",
      if (accommodation['kitchen'] == true) "Bếp",
      if (accommodation['airConditioner'] == true) "Điều hoà",
      if (accommodation['refrigerator'] == true) "Tủ lạnh",
      if (accommodation['washer'] == true) "Máy giặt",
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('$price triệu/tháng', style: const TextStyle(color: Colors.blue)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        actions: const [Icon(Icons.favorite_border, color: Colors.blue)],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            imageBytes != null
                ? Image.memory(imageBytes, height: 200, width: double.infinity, fit: BoxFit.cover)
                : Image.asset('assets/images/room_default.jpg', height: 200, width: double.infinity, fit: BoxFit.cover),
            Container(
              color: const Color(0xFFF8F8F8),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
                  const SizedBox(height: 8),

                  _infoRow(Icons.location_on, address),
                  _infoRow(Icons.phone, "$phone - $fullName"),
                  _infoRow(Icons.square_foot, "Diện tích ${acreage.toStringAsFixed(0)} m²"),
                  _infoRow(Icons.access_time, createdAt),

                  const SizedBox(height: 12),
                  Text("Tiện ích phòng (${utilities.length})", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 16,
                    runSpacing: 10,
                    children: utilities.map((item) {
                      final icon = _getUtilityIcon(item);
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, color: Colors.blue),
                          const SizedBox(height: 4),
                          Text(item, style: const TextStyle(fontSize: 12)),
                        ],
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),
                  const Text("Mô tả chi tiết", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(description, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Expanded(child: Text(content, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  IconData _getUtilityIcon(String name) {
    switch (name.toLowerCase()) {
      case 'wifi': return Icons.wifi;
      case 'wc riêng': return Icons.wc;
      case 'giữ xe': return Icons.two_wheeler;
      case 'tự do': return Icons.timer;
      case 'bếp': return Icons.kitchen;
      case 'điều hoà': return Icons.ac_unit;
      case 'tủ lạnh': return Icons.kitchen_outlined;
      case 'máy giặt': return Icons.local_laundry_service;
      default: return Icons.check_circle_outline;
    }
  }
}
