import 'dart:async';
import 'package:flutter/material.dart';

class HomeBannerAndFeatureSection extends StatefulWidget {
  const HomeBannerAndFeatureSection({super.key});

  @override
  State<HomeBannerAndFeatureSection> createState() =>
      _HomeBannerAndFeatureSectionState();
}

class _HomeBannerAndFeatureSectionState
    extends State<HomeBannerAndFeatureSection> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  late Timer _timer;
  int _currentPage = 0;

  final List<String> bannerImages = List.generate(
    5,
    (index) => 'https://picsum.photos/800/300?random=$index',
  );

  // đưa ảnh của mình vào thì thay bằng
  /**final List<String> bannerImages = [
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
    'assets/images/banner4.jpg',
    'assets/images/banner5.jpg',
  ];
  */
  final List<Map<String, String>> featureList = [
    {
      'label': 'Nạp Đồng Tốt',
      'route': '/topup',
      'image': 'https://img.icons8.com/ios-filled/50/money.png'
    },
    {
      'label': 'Gói Pro',
      'route': '/pro',
      'image': 'https://img.icons8.com/ios-filled/50/money.png',
    },
    {
      'label': 'Thu mua ô tô',
      'route': '/buycar',
      'image': 'https://img.icons8.com/ios-filled/50/money.png',
    },
    {
      'label': 'Đặt xe chính hãng',
      'route': '/officialcar',
      'image': 'https://img.icons8.com/ios-filled/50/money.png',
    },
    {
      'label': 'Thu mua máy cũ',
      'route': '/buyused',
      'image': 'https://img.icons8.com/ios-filled/50/money.png',
    },
    {
      'label': 'Bất động sản',
      'route': '/realestate',
      'image': 'https://img.icons8.com/ios-filled/50/money.png',
    },
    {
      'label': 'Xe cộ',
      'route': '/vehicles',
      'image': 'https://img.icons8.com/ios-filled/50/money.png',
    },
    {
      'label': 'Đồ điện tử',
      'route': '/electronics',
      'image': 'https://img.icons8.com/ios-filled/50/money.png',
    },
    {
      'label': 'Đồ nội thất',
      'route': '/furniture',
      'image': 'https://img.icons8.com/ios-filled/50/money.png',
    },
    {
      'label': 'Việc làm',
      'route': '/jobs',
      'image': 'https://img.icons8.com/ios-filled/50/money.png',
    },
    {
      'label': 'Thú cưng',
      'route': '/pets',
      'image': 'https://img.icons8.com/ios-filled/50/money.png',
    },
    {
      'label': 'Tủ lạnh, máy giặt',
      'route': '/appliances',
      'image': 'https://img.icons8.com/ios-filled/50/money.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= bannerImages.length) {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        bannerImages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.white : Colors.white54,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Chia feature list thành nhóm 12 (2 hàng x 6)
    List<List<Map<String, String>>> chunkedFeatureList = [];
    for (int i = 0; i < featureList.length; i += 12) {
      chunkedFeatureList.add(
        featureList.sublist(
          i,
          i + 12 > featureList.length ? featureList.length : i + 12,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔽 Carousel ảnh + indicator
        SizedBox(
          height: 200,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: bannerImages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.network(
                      bannerImages[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                },
              ),
              Positioned(bottom: 10, child: _buildIndicator()),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8),
          child: Text(
            "Khám phá danh mục",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        // 🔽 Danh mục 2 dòng x 6, nhưng mỗi dòng chỉ hiện 4 icon và có thể cuộn ngang
        SizedBox(
          height: 180,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: List.generate(2, (rowIndex) {
                return Row(
                  children: List.generate(featureList.length, (colIndex) {
                    // Tính index của item theo dòng
                    int itemIndex = rowIndex + colIndex * 2;

                    // Nếu index vượt quá thì return rỗng
                    if (itemIndex >= featureList.length)
                      return const SizedBox();

                    final feature = featureList[itemIndex];
                    final imageUrl = feature['image'];
                    return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: GestureDetector(
                          onTap: () {
                            final route = feature[''];
                            if (route != null && route.isNotEmpty) {
                              Navigator.pushNamed(context, route);
                            }
                          },
                          child: SizedBox(
                            width: 110,
                            child: Column(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: imageUrl != null
                                      ? (imageUrl.startsWith('http')
                                          ? Image.network(imageUrl,
                                              width: 28,
                                              height: 28,
                                              color: Colors.black)
                                          : Image.asset(imageUrl,
                                              width: 28,
                                              height: 28,
                                              color: Colors.black))
                                      : const Icon(Icons.star_border),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  feature['label']!,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ));
                  }),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
