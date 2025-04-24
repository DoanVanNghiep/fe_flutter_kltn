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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: OffersCarouselAndCategories()),

            // Danh sách phòng phổ biến
            const SliverToBoxAdapter(child: PopularProducts()),

            // Ưu đãi hot trong tuần
            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: defaultPadding * 1.5),
              sliver: SliverToBoxAdapter(child: FlashSale()),
            ),

            // Banner "Phòng mới giá tốt"
            SliverToBoxAdapter(
              child: Column(
                children: [
                  BannerSStyle1(
                    title: "Phòng mới\nGiá tốt",
                    subtitle: "ƯU ĐÃI ĐẶC BIỆT",
                    discountParcent: 20,
                    press: () {
                      Navigator.pushNamed(context, logInScreenRoute);
                    },
                  ),
                  const SizedBox(height: defaultPadding / 4),
                ],
              ),
            ),

            // Phòng trọ được đánh giá cao
            const SliverToBoxAdapter(child: BestSellers()),

            // Khu vực được tìm kiếm nhiều
            const SliverToBoxAdapter(child: MostPopular()),

            // Banner "Khu vực hot"
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: defaultPadding * 1.5),
                  BannerSStyle5(
                    title: "Khu vực\nHOT",
                    subtitle: "GIẢM 50%",
                    bottomText: "Ưu đãi đặc biệt".toUpperCase(),
                    press: () {
                      Navigator.pushNamed(context, onSaleScreenRoute);
                    },
                  ),
                  const SizedBox(height: defaultPadding / 4),
                ],
              ),
            ),

            // Lặp lại danh sách phòng nổi bật
            const SliverToBoxAdapter(child: BestSellers()),
          ],
        ),
      ),
    );
  }
}
