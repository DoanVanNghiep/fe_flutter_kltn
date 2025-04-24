import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../url.dart';

class UserService {
  static const String _baseUrl = "${AppConfig.baseUrl}";

  // ✅ Hàm lấy thông tin user theo ID, có xác thực token
  Future<Map<String, dynamic>?> getUserById(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        print("⚠️ Không có token, cần đăng nhập lại!");
        return null;
      }

      final response = await http.get(
        Uri.parse("$_baseUrl/user/$id"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("📡 Gọi API /user/$id – Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
        jsonDecode(utf8.decode(response.bodyBytes));

        print("📌 Dữ liệu người dùng:");
        print(jsonEncode(data));

        return data;
      } else if (response.statusCode == 401) {
        print("❌ Token không hợp lệ hoặc không đủ quyền!");
        return null;
      } else {
        throw Exception("Lỗi khi lấy thông tin người dùng: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Lỗi kết nối hoặc xử lý dữ liệu: $e");
      return null;
    }
  }

  Future<String?> getUserAvatar(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        print("⚠️ Token không tồn tại. Cần đăng nhập.");
        return null;
      }

      final response = await http.get(
        Uri.parse("$_baseUrl/user/$id/avatar"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("📡 Gọi GET /user/$id/avatar – Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData =
        jsonDecode(utf8.decode(response.bodyBytes));

        final base64Image = jsonData['data'];

        return base64Image;
      } else if (response.statusCode == 401) {
        print("❌ Token không hợp lệ hoặc hết hạn!");
        return null;
      } else {
        throw Exception("Lỗi API avatar: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Lỗi khi gọi API avatar: $e");
      return null;
    }
  }

  Future<bool> updateUser({
    required int id,
    required String fullName,
    required String email,
    required String phone,
    required String address,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        throw Exception("Token không tồn tại, cần đăng nhập lại");
      }

      final Map<String, dynamic> requestBody = {
        "id": id,
        "fullName": fullName,
        "email": email,
        "phone": phone,
        "address": address,
      };

      final response = await http.put(
        Uri.parse("$_baseUrl"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("✅ Cập nhật thành công: ${response.body}");
        return true;
      } else {
        print("❌ Cập nhật thất bại: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Lỗi khi gọi API updateUser: $e");
      return false;
    }
  }
}
