import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vnua_service/components/network_image_with_loader.dart';

import '../../../../constants.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.name,
    required this.email,
    required this.imageSrc,
    this.proLableText = "Pro",
    this.isPro = false,
    this.press,
    this.isShowHi = true,
    this.isShowArrow = true,
  });

  final String name, email, imageSrc;
  final String proLableText;
  final bool isPro, isShowHi, isShowArrow;
  final VoidCallback? press;

  bool get _isBase64 => imageSrc.startsWith("data:image");

  @override
  Widget build(BuildContext context) {
    Widget avatar;

    if (_isBase64) {
      try {
        final base64Str = imageSrc.split(',').last;
        avatar = CircleAvatar(
          radius: 28,
          backgroundImage: MemoryImage(base64Decode(base64Str)),
        );
      } catch (e) {
        print("❌ Lỗi giải mã ảnh base64: $e");
        avatar = const CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        );
      }
    } else {
      avatar = CircleAvatar(
        radius: 28,
        backgroundColor: Colors.grey[200],
        child: NetworkImageWithLoader(
          imageSrc,
          radius: 100,
        ),
      );
    }

    return ListTile(
      onTap: press,
      leading: avatar,
      title: Row(
        children: [
          Text(
            isShowHi ? "Hi, $name" : name,
            style: const TextStyle(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: defaultPadding / 2),
          if (isPro)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding / 2, vertical: defaultPadding / 4),
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius:
                BorderRadius.all(Radius.circular(defaultBorderRadious)),
              ),
              child: Text(
                proLableText,
                style: const TextStyle(
                  fontFamily: grandisExtendedFont,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 0.7,
                  height: 1,
                ),
              ),
            ),
        ],
      ),
      subtitle: Text(email),
      trailing: isShowArrow
          ? SvgPicture.asset(
        "assets/icons/miniRight.svg",
        color: Theme.of(context).iconTheme.color!.withOpacity(0.4),
      )
          : null,
    );
  }
}
