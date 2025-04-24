import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vnua_service/screens/profile/services/user_service.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("userId");

    if (userId != null) {
      final user = await UserService().getUserById(userId);
      setState(() {
        userData = user;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Hồ sơ", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Navigate to edit screen
            },
            child: const Text(
              "Chỉnh sửa",
              style: TextStyle(color: Colors.blueAccent, fontSize: 16),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
          ? const Center(child: Text("Không tìm thấy thông tin người dùng"))
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            Center(child: _buildAvatar(userData!['b64'])),
            const SizedBox(height: 12),
            Center(
              child: Text(
                userData!['fullName'] ?? '',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Center(
              child: Text(
                userData!['email'] ?? '',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            _infoRow("Họ và tên", userData!['fullName'] ?? ''),
            _infoRow("Số dư", userData!['fullName'] ?? ''),
            _infoRow("Số điện thoại", userData!['phone'] ?? 'Not set'),
            _infoRow("Địa chỉ", userData!['address'] ?? 'Not set'),
            _infoRow("Email", userData!['email'] ?? ''),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Mật khẩu", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () {
                      // Navigate to change password screen
                    },
                    child: const Text(
                      "Thay đổi mật khẩu",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildAvatar(String? base64) {
    if (base64 != null && base64.isNotEmpty) {
      try {
        return CircleAvatar(
          radius: 40,
          backgroundImage: MemoryImage(base64Decode(base64)),
        );
      } catch (e) {
        return const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        );
      }
    } else {
      return const CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage("https://i.imgur.com/IXnwbLk.png"),
      );
    }
  }
}
