import 'package:flutter/material.dart';
import 'package:vnua_service/components/Banner/S/banner_s_style_1.dart';
import 'package:vnua_service/components/Banner/S/banner_s_style_5.dart';
import 'package:vnua_service/constants.dart';
import 'package:vnua_service/route/route_constants.dart';

import '../components/best_sellers.dart';
import '../components/flash_sale.dart';
import '../components/most_popular.dart';
import '../components/offer_carousel_and_categories.dart';
import '../components/popular_products.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: OffersCarouselAndCategories()),
            const SliverToBoxAdapter(child: PopularProducts()),
            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: defaultPadding * 1.5),
              sliver: SliverToBoxAdapter(child: FlashSale()),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  BannerSStyle1(
                    title: "Phòng mới\nGiá tốt",
                    subtitle: "ƯU ĐÃI ĐẶC BIỆT",
                    discountParcent: 20,
                    press: () {},
                  ),
                  const SizedBox(height: defaultPadding / 4),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: BestSellers()),
            const SliverToBoxAdapter(child: MostPopular()),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: defaultPadding * 1.5),
                  BannerSStyle5(
                    title: "Khu vực\nHOT",
                    subtitle: "GIẢM 50%",
                    bottomText: "ƯU ĐÃI ĐẶC BIỆT",
                    press: () {},
                  ),
                  const SizedBox(height: defaultPadding / 4),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: BestSellers()),
          ],
        ),
      ),
    );
  }
}
