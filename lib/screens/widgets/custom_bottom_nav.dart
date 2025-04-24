import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vnua_service/route/route_constants.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _iconIndex = 0;
  late Timer _timer;

  final List<IconData> _icons = [
    Icons.edit,
    Icons.add_circle_outline,
    Icons.create,
    Icons.post_add,
    Icons.cloud_upload,
  ];

  @override
  void initState() {
    super.initState();
    _startIconRotation();
  }

  void _startIconRotation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _iconIndex = (_iconIndex + 1) % _icons.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _showCategoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildCategoryList(),
    );
  }

  Widget _buildCategoryList() {
    final List<Map<String, dynamic>> categories = [
      {'icon': Icons.apartment, 'title': 'Phòng trọ'},
      {'icon': Icons.storefront, 'title': 'Cửa hàng'},
      {'icon': Icons.local_shipping, 'title': 'Ship hàng'},
    ];

    return Container(
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.tealAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const Center(
              child: Text(
                "Danh mục tin đăng",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Danh mục dạng lưới
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 0.9,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: categories.map((item) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      if (item['title'] == 'Phòng trọ') {
                        Navigator.pushNamed(context, createPostRoute);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.teal.shade100),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item['icon'], size: 34, color: Colors.teal),
                          const SizedBox(height: 8),
                          Text(
                            item['title'],
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: widget.currentIndex,
            onTap: (index) {
              if (index != 2) widget.onTap(index);
            },
            selectedItemColor: Colors.teal,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: [
              _buildNavItem("assets/icons/house.svg", "Trang chủ", 0),
              _buildNavItem("assets/icons/search.svg", "Tìm trọ", 1),
              _buildLogoItem(),
              _buildNavItem("assets/icons/bell-dot.svg", "Thông báo", 3),
              _buildNavItem("assets/icons/user.svg", "Tài khoản", 4),
            ],
          ),
        ),
        Positioned(
          top: -20,
          child: GestureDetector(
            onTap: () => _showCategoryModal(context),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade400, Colors.teal.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(_icons[_iconIndex], color: Colors.white, size: 32),
            ),
          ),
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(String svgPath, String label, int index) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        svgPath,
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
      ),
      activeIcon: SvgPicture.asset(
        svgPath,
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Colors.teal, BlendMode.srcIn),
      ),
      label: label,
    );
  }

  BottomNavigationBarItem _buildLogoItem() {
    return const BottomNavigationBarItem(
      icon: SizedBox.shrink(),
      label: 'Đăng tin',
    );
  }
}
