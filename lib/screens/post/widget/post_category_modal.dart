import 'package:flutter/material.dart';

class PostCategoryModal extends StatelessWidget {
  const PostCategoryModal({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> quickPost = [
      {
        'icon': Icons.flash_on,
        'title': 'Đăng nhanh bằng AI',
        'subtitle': 'Bạn quay sản phẩm, AI tạo tin đăng',
        'onTap': () {
          Navigator.pop(context);
          // TODO: Add quick post logic
        },
      },
    ];

    final List<Map<String, dynamic>> categories = [
      {'icon': Icons.apartment, 'title': 'Phòng trọ'},
      {'icon': Icons.electric_scooter, 'title': 'Cửa hàng'},
      {'icon': Icons.devices_other, 'title': 'Ship hàng'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const Center(
              child: Text(
                'Danh mục',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 12),
                const Text(
                  'ĐĂNG TIN NHANH',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...quickPost.map((item) => GestureDetector(
                      onTap: item['onTap'],
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          border: Border.all(color: Colors.orange.shade100),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(item['icon'], color: Colors.orange),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    item['subtitle'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                    )),
                const Text(
                  'CHỌN DANH MỤC',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...categories.map((item) => ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: Icon(item['icon'], color: Colors.black),
                      title: Text(item['title']),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
