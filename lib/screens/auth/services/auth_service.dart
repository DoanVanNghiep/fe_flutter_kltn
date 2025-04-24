import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vnua_service/url.dart';

class AuthService {
  static const String _baseUrl = "${AppConfig.baseUrl}/auth";

  // Đăng ký tài khoản mới
  Future<Map<String, dynamic>> register(String fullName, String email, String password, String address, String phone) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fullName": fullName,
          "email": email,
          "password": password,
          "address": address,
          "phone": phone,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"error": "Lỗi đăng ký: $e"};
    }
  }

  // Xác thực tài khoản bằng OTP
  Future<String> verifyAccount(String email, String otp) async {
    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/verify-account"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "otp": otp}),
      );

      final responseData = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && responseData["success"] == true) {
        return responseData["data"] ?? "Xác thực thành công!";
      }
      return responseData["error"] ?? "Lỗi xác thực!";
    } catch (e) {
      return "OTP sai hãy nhập lại.";
    }
  }

  // Gửi lại mã OTP
  Future<String> regenerateOTP(String email) async {
    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/regenerate-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final responseData = jsonDecode(response.body);
      return responseData["message"] ?? "Mã OTP đã được gửi lại!";
    } catch (e) {
      return "Lỗi gửi lại OTP: $e";
    }
  }

  // Đăng nhập
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200 && responseData["success"] == true) {
        final token = responseData["data"]?["token"] ?? "";
        final userId = responseData["data"]?["id"];
        final name = responseData["data"]?["fullName"];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);
        await prefs.setInt("userId", userId);
        await prefs.setString("name", name);


        print("✅ Đăng nhập thành công! Token: $token");

        print("Token hiện tại: ${prefs.getString("token")}");
        print("id hiện tại: ${prefs.getInt("userId")}");


        return {"success": true, "data": responseData["data"]};
      }

      return {"error": responseData["message"] ?? "Đăng nhập thất bại!"};
    } catch (e) {
      return {"error": "Lỗi hệ thống: $e"};
    }
  }

  // Gửi email để lấy OTP
  Future<String> requestOtp(String email) async {
    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/regenerate-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final responseData = jsonDecode(response.body);
      return responseData["message"] ?? "Đã gửi mã thành công!";
    } catch (e) {
      return "Lỗi gửi OTP: $e";
    }
  }

  // Gửi yêu cầu quên mật khẩu (Gửi OTP đến Email)
  Future<String> forgotPassword(String email) async {
    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/forgot-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData["success"] == true) {
        return responseData["data"] ?? "OTP đã được gửi!";
      } else {
        throw Exception(responseData["message"] ?? "Lỗi khi gửi OTP!");
      }
    } catch (e) {
      return "Lỗi gửi OTP: $e";
    }
  }

  // Xác thực OTP và đặt lại mật khẩu mới
  Future<String> resetPassword(String email, String otp, String newPassword) async {
    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/forgot-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "otp": otp, "password": newPassword}),
      );

      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      return responseData["data"] ?? "Đặt lại mật khẩu thành công!";
    } catch (e) {
      return "Lỗi khi đặt lại mật khẩu: $e";
    }
  }


  // Đăng xuất
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("userId");
    await prefs.remove("name");

    // Chuyển về màn hình login hoặc splash
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

}
