import 'package:flutter/material.dart';
import '../components/password_recovery_form.dart';
import 'package:vnua_service/route/route_constants.dart';
import '../services/auth_service.dart';


class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔙 **Nút quay lại**
                    IconButton(
                      icon: const Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(3, 3),  // Độ dịch chuyển bóng
                              blurRadius: 10,         // Độ mờ của bóng
                              color: Colors.black54,  // Màu bóng
                            ),
                          ],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Quên mật khẩu!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(3, 3),  // Độ dịch chuyển bóng
                            blurRadius: 10,         // Độ mờ của bóng
                            color: Colors.black54,  // Màu bóng
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    const Text(
                      "Hãy nhập chính xác địa chỉ Email của bạn",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(3, 3),  // Độ dịch chuyển bóng
                              blurRadius: 10,         // Độ mờ của bóng
                              color: Colors.black54,  // Màu bóng
                            ),
                          ],
                        ),
                    ),
                    const SizedBox(height: 20),
                    const PasswordRecoveryForm(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
