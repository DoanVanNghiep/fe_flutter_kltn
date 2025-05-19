import 'package:flutter/material.dart';
import 'package:vnua_service/screens/home/views/home_banner_and_feature_section.dart';
import 'package:vnua_service/screens/search_motel/components/accomodation_screen.dart';
import 'package:vnua_service/screens/search_motel/components/post_screen.dart';
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
  String _searchKeyword = "";

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
                // const SizedBox(height: 20),
                const HomeBannerAndFeatureSection(),
                const SizedBox(height: 20),
                AccomodationScreen(
                    searchKeyword: _searchKeyword), // truyền từ khóa
                const SizedBox(height: 20),
                PostScreen(searchKeyword: _searchKeyword),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
