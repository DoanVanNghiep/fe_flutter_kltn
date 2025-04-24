import 'package:flutter/material.dart';
import '../components/header_section.dart';
import '../components/price_range_section.dart';
import '../components/motel_card_list.dart';
import '../components/explore_section.dart';
import '../../widgets/custom_bottom_nav.dart';
import 'package:vnua_service/route/route_constants.dart';

class MotelSearchScreen extends StatefulWidget {
  const MotelSearchScreen({super.key});

  @override
  State<MotelSearchScreen> createState() => _MotelSearchScreenState();
}

class _MotelSearchScreenState extends State<MotelSearchScreen> {
  int _currentIndex = 1;
  String _searchKeyword = "";

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, homeScreenRoute);
        break;
      case 1:
        Navigator.pushNamed(context, motelSearchRoute);
        break;
      case 3:
        Navigator.pushNamed(context, notificationOptionsScreenRoute);
        break;
      case 4:
        Navigator.pushNamed(context, profileScreenRoute);
        break;
    }
  }

  // callback khi người dùng chọn từ khóa tìm kiếm
  void _handleSearch(String keyword) {
    setState(() {
      _searchKeyword = keyword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                PriceRangeSection(onSearch: _handleSearch), // truyền callback
                const SizedBox(height: 20),
                ExploreSection(searchKeyword: _searchKeyword), // truyền từ khóa
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
