import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vnua_service/generated/l10n.dart';
import 'package:vnua_service/res/color.dart';
import 'package:vnua_service/route/route_constants.dart';
import 'package:vnua_service/screens/post/widget/post_category_modal.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
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
      builder: (context) => const PostCategoryModal(),
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
            selectedItemColor: AppColors.secondary400,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: [
              _buildNavItem(
                  "assets/icons/house.svg", S.current.generated_home, 0),
              _buildNavItem("assets/icons/search.svg",
                  S.current.generated_manage_listings, 1),
              _buildLogoItem(),
              _buildNavItem("assets/icons/bell-dot.svg",
                  S.current.generated_notifications, 3),
              _buildNavItem(
                  "assets/icons/user.svg", S.current.generated_account, 4),
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
                  colors: [AppColors.secondary400, AppColors.secondary600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary400,
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

  BottomNavigationBarItem _buildNavItem(
      String svgPath, String label, int index) {
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
        colorFilter:
            const ColorFilter.mode(AppColors.secondary400, BlendMode.srcIn),
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
