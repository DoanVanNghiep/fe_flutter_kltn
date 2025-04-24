import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:vnua_service/screens/detail_motel/detail_motel_screen.dart';

class MiniMotelCard extends StatelessWidget {
  final dynamic post;

  const MiniMotelCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final title = post['title'] ?? 'Không có tiêu đề';
    final postId = post['id'];
    final imageString = post['imageStrings'];

    final accommodation = post['accomodationDTO'] ?? {};
    final address = accommodation['address'] ?? 'Đang cập nhật';
    final area = accommodation['acreage']?.toString() ?? '0';
    final price = accommodation['price'] != null
        ? '${((accommodation['price'] as num) / 1000000).toStringAsFixed(1)} triệu /1 tháng'
        : 'Liên hệ';


    final imageBase64 = imageString;
    Uint8List? imageBytes;
    if (imageBase64 != null && imageBase64 is String && imageBase64.isNotEmpty) {
      imageBytes = base64Decode(imageBase64);
    }

    return GestureDetector(
      onTap: () {
        if (postId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MotelDetailScreen(postId: postId),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: imageBytes != null
                  ? Image.memory(
                imageBytes,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                'assets/images/room_default.jpg',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Nội dung
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.square_foot, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('$area m²', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          address,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
