import 'package:flutter/material.dart';
import 'package:vnua_service/screens/home/views/home_screen.dart';
import 'package:vnua_service/route/screen_export.dart';
import 'package:vnua_service/screens/widgets/custom_bottom_nav.dart'; // Thêm file này

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentTab = 0;
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      MotelSearchScreen(),
      ManagePostsScreen(),
      HomeScreen(), // Đăng bài (nút giữa)
      NotificationScreen(),
      ProfileScreen(),
    ];

    _tabController = TabController(vsync: this, length: screens.length);
    _tabController.addListener(() {
      if (_tabController.index != 2) {
        setState(() {
          currentTab = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    if (index != 2) {
      setState(() {
        currentTab = index;
        _tabController.animateTo(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          null, // Không cần vì đã có trong CustomBottomNavigationBar
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentTab,
        onTap: _onTabSelected,
      ),
    );
  }
}
