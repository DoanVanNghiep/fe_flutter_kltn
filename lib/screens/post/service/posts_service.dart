import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vnua_service/url.dart';

class PostsService {
  static const String _baseUrl = "${AppConfig.baseUrl}/api";

  // Tất cả bài đăng
  Future<List<dynamic>> getAllPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        return [];
      }

      final response = await http.get(
        Uri.parse("$_baseUrl/posts"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        if (data.containsKey("data") && data["data"].containsKey("items")) {
          return data["data"]["items"];
        } else {
          return [];
        }
      } else if (response.statusCode == 401) {
        return [];
      } else {
        throw Exception("Lỗi khi tải tin đăng: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  // Xem thông tin bài đăng theo Id
  Future<Map<String, dynamic>?> getPostById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) return null;

    final response = await http.get(
      Uri.parse("$_baseUrl/post/$id"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data["data"]; // postDTO
    } else {
      throw Exception("Lỗi khi tải chi tiết tin đăng: ${response.statusCode}");
    }
  }

  // Tạo một tin đăng
  Future<Map<String, dynamic>?> createPost(Map<String, dynamic> postData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) return null;

      final response = await http.post(
        Uri.parse("$_baseUrl/post"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data["data"]; // Trả về dữ liệu bài viết đã tạo
      } else {
        print("Lỗi khi đăng tin: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception khi gọi API đăng tin: $e");
      return null;
    }
  }

  //Lấy danh sách tin đăng của một người dùng
  Future<List<dynamic>> getPostsByUser({int start = 0, int limit = 5}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final userId = prefs.getInt("userId"); // đảm bảo bạn đã lưu userId khi đăng nhập

      if (token == null || userId == null) {
        return [];
      }

      final uri = Uri.parse("$_baseUrl/posts/$userId")
          .replace(queryParameters: {
        'start': '$start',
        'limit': '$limit',
      });

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data.containsKey("data") && data["data"].containsKey("items")) {
          return data["data"]["items"];
        } else {
          return [];
        }
      } else {
        print("Lỗi khi lấy danh sách tin đăng của user: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Exception trong getPostsByUser: $e");
      return [];
    }
  }

  // Ẩn/Mở khóa một tin đăng
  Future<bool> togglePostVisibility(int postId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) return false;

      final response = await http.put(
        Uri.parse("$_baseUrl/post/hide/$postId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Lỗi khi ẩn/mở khóa tin đăng: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception trong togglePostVisibility: $e");
      return false;
    }
  }

  // Update một tin đăng
  Future<Map<String, dynamic>?> updatePostWithImages(
      int id,
      Map<String, dynamic> updatePostRequest,
      List<File> imageFiles,
      ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) return null;

      var uri = Uri.parse("$_baseUrl/post/$id");

      var request = http.MultipartRequest("PUT", uri);
      request.headers['Authorization'] = "Bearer $token";

      // Phần body thông tin dưới dạng JSON string
      request.fields['updatePostRequest'] = jsonEncode(updatePostRequest);

      // Thêm ảnh (nếu có)
      for (var img in imageFiles) {
        final fileName = img.path.split("/").last;
        request.files.add(await http.MultipartFile.fromPath(
          'images', // hoặc 'images[]' tùy backend
          img.path,
          filename: fileName,
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        return decoded['data'];
      } else {
        print("❌ Lỗi cập nhật bài + ảnh: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Exception updatePostWithImages: $e");
      return null;
    }
  }

}
