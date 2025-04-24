import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vnua_service/components/divider_list_tile.dart';
import 'package:vnua_service/components/network_image_with_loader.dart';
import 'package:vnua_service/constants.dart';
import 'package:vnua_service/route/route_constants.dart';
import 'package:vnua_service/screens/profile/services/user_service.dart';

import '../components/profile_card.dart';
import '../components/profile_menu_item_list_tile.dart';
import '../../widgets/custom_bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>?> _futureUser;
  bool _isLoading = true;
  final userService = UserService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("userId");
    print("User ID từ SharedPreferences: $userId");

    if (userId != null) {
      _futureUser = UserService().getUserById(userId);
      final avatarB64 = await userService.getUserAvatar(userId);
      _futureUser.then((user) {
        print("Thông tin người dùng: $user");
      }).catchError((e) {
        print("Lỗi khi lấy người dùng: $e");
      });
    } else {
      _futureUser = Future.error("Không tìm thấy người dùng trong local");
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onTabTapped(BuildContext context, int index) {
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

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("userId");

    Navigator.pushNamedAndRemoveUntil(context, logInScreenRoute, (route) => false);
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Đăng xuất"),
        content: const Text("Bạn có chắc chắn muốn đăng xuất không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Huỷ"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout(context);
            },
            child: const Text("Đăng xuất"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<Map<String, dynamic>?>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Không có dữ liệu người dùng'));
          }

          final user = snapshot.data!;
          final name = user['fullName'] ?? 'Chưa có tên';
          final email = user['email'] ?? 'Chưa có email';
          final avatarB64 = user['b64'] ?? '';
          final imageSrc = avatarB64.isNotEmpty
              ? 'data:image/png;base64,$avatarB64'
              : 'https://i.imgur.com/IXnwbLk.png';

          return ListView(
            children: [
              ProfileCard(
                name: name,
                email: email,
                imageSrc: imageSrc,
                press: () {
                  Navigator.pushNamed(context, userInfoScreenRoute);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text("Tài khoản", style: Theme.of(context).textTheme.titleSmall),
              ),
              const SizedBox(height: defaultPadding / 2),
              ProfileMenuListTile(
                text: "Quản lý tin đăng",
                svgSrc: "assets/icons/Order.svg",
                press: () {
                  Navigator.pushNamed(context, managePostRoute);
                },
              ),
              ProfileMenuListTile(
                text: "Nạp tiền",
                svgSrc: "assets/icons/Return.svg",
                press: () {},
              ),
              ProfileMenuListTile(
                text: "Yêu thích",
                svgSrc: "assets/icons/Wishlist.svg",
                press: () {},
              ),
              ProfileMenuListTile(
                text: "Địa chỉ",
                svgSrc: "assets/icons/Address.svg",
                press: () {
                  Navigator.pushNamed(context, addressesScreenRoute);
                },
              ),
              ProfileMenuListTile(
                text: "Thanh toán",
                svgSrc: "assets/icons/card.svg",
                press: () {
                  Navigator.pushNamed(context, emptyPaymentScreenRoute);
                },
              ),
              ProfileMenuListTile(
                text: "Ví",
                svgSrc: "assets/icons/Wallet.svg",
                press: () {
                  Navigator.pushNamed(context, walletScreenRoute);
                },
              ),
              const SizedBox(height: defaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding / 2),
                child: Text("Cá nhân hoá", style: Theme.of(context).textTheme.titleSmall),
              ),
              DividerListTileWithTrilingText(
                svgSrc: "assets/icons/Notification.svg",
                title: "Thông báo",
                trilingText: "Tắt",
                press: () {
                  Navigator.pushNamed(context, enableNotificationScreenRoute);
                },
              ),
              ProfileMenuListTile(
                text: "Tuỳ chỉnh",
                svgSrc: "assets/icons/Preferences.svg",
                press: () {
                  Navigator.pushNamed(context, preferencesScreenRoute);
                },
              ),
              const SizedBox(height: defaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding / 2),
                child: Text("Cài đặt", style: Theme.of(context).textTheme.titleSmall),
              ),
              ProfileMenuListTile(
                text: "Ngôn ngữ",
                svgSrc: "assets/icons/Language.svg",
                press: () {
                  Navigator.pushNamed(context, selectLanguageScreenRoute);
                },
              ),
              ProfileMenuListTile(
                text: "Vị trí",
                svgSrc: "assets/icons/Location.svg",
                press: () {},
              ),
              const SizedBox(height: defaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding / 2),
                child: Text("Trợ giúp & Hỗ trợ", style: Theme.of(context).textTheme.titleSmall),
              ),
              ProfileMenuListTile(
                text: "Trợ giúp",
                svgSrc: "assets/icons/Help.svg",
                press: () {
                  Navigator.pushNamed(context, getHelpScreenRoute);
                },
              ),
              ProfileMenuListTile(
                text: "Câu hỏi thường gặp",
                svgSrc: "assets/icons/FAQ.svg",
                press: () {},
                isShowDivider: false,
              ),
              const SizedBox(height: defaultPadding),
              ListTile(
                onTap: () {
                  _confirmLogout(context);
                },
                minLeadingWidth: 24,
                leading: SvgPicture.asset(
                  "assets/icons/Logout.svg",
                  height: 24,
                  width: 24,
                  colorFilter: const ColorFilter.mode(errorColor, BlendMode.srcIn),
                ),
                title: const Text(
                  "Đăng xuất",
                  style: TextStyle(color: errorColor, fontSize: 14, height: 1),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 4,
        onTap: (index) => _onTabTapped(context, index),
      ),
    );
  }
}
