import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vnua_service/screens/auth/components/sign_up_form.dart';
import 'package:vnua_service/route/route_constants.dart';
import 'package:vnua_service/screens/auth/services/auth_service.dart';
import 'package:vnua_service/screens/auth/views/otp/otp_verification_screen.dart'; // Popup OTP
import '../../../constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> formData = {};
  bool _isChecked = false;
  bool _isLoading = false;

  final AuthService authService = AuthService();

  void _showOtpDialog(String email) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => OTPVerificationScreen(email: email),
    );
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    final result = await authService.register(
      formData['fullName']!,
      formData['email']!,
      formData['password']!,
      formData['address'] ?? 'Chưa đưược cập nhật',
      formData['phone'] ?? 'Chưa được cập nhật',
    );

    setState(() => _isLoading = false);

    if (result["success"] == true && result["data"] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng ký thành công! Vui lòng kiểm tra email để nhập OTP.")),
      );
      _showOtpDialog(formData['email']!);
    } else {
      final error = result["error"];
      String errorMessage;

      if (error is String) {
        errorMessage = error;
      } else if (error is Map<String, dynamic>) {
        errorMessage = error.values.join('\n');
      } else {
        errorMessage = 'Đăng ký thất bại';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      "Chúng ta hãy bắt đầu nhé!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(offset: Offset(3, 3), blurRadius: 10, color: Colors.black54),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            SignUpForm(formKey: _formKey, formData: formData),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Checkbox(
                                  value: _isChecked,
                                  onChanged: (value) {
                                    setState(() => _isChecked = value ?? false);
                                  },
                                ),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      text: "Tôi đồng ý với",
                                      children: [
                                        TextSpan(
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () => Navigator.pushNamed(context, termsOfServicesScreenRoute),
                                          text: " Điều khoản dịch vụ ",
                                          style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
                                        ),
                                        const TextSpan(text: "& Chính sách bảo mật."),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isChecked ? const Color(0xFF6A11CB) : Colors.grey,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                ),
                                onPressed: _isChecked && !_isLoading ? _handleRegister : null,
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text("Tiếp tục", style: TextStyle(fontSize: 18, color: Colors.white)),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Bạn có tài khoản chưa?"),
                                TextButton(
                                  onPressed: () => Navigator.pushNamed(context, logInScreenRoute),
                                  child: const Text("Đăng nhập", style: TextStyle(color: Colors.blue)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
