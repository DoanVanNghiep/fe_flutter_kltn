import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:vnua_service/screens/auth/services/auth_service.dart';
import 'package:vnua_service/route/route_constants.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;

  const OTPVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  final AuthService authService = AuthService();

  bool _isLoading = false;
  int _secondsRemaining = 120;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() {});
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void verifyOTP() async {
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đủ 6 chữ số OTP.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await authService.verifyAccount(widget.email, otp);
      setState(() => _isLoading = false);

      if (response.toLowerCase().contains('thành công')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response)),
        );
        Navigator.pushNamedAndRemoveUntil(context, logInScreenRoute, (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Mã OTP không đúng hoặc đã hết hạn. Vui lòng thử lại.")),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi xác thực OTP: $e")),
      );
    }
  }


  void resendOTP() async {
    final response = await authService.regenerateOTP(widget.email);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response)),
    );

    setState(() {
      _secondsRemaining = 120;
    });
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    final canInputOTP = _secondsRemaining > 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 30, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
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
              Text(
                'Mã OTP đã được gửi tới email:\n${widget.email}',
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  shadows: [
                    Shadow(offset: Offset(3, 3), blurRadius: 10, color: Colors.black54),
                  ],
                ),

              ),
              const SizedBox(height: 30),
              Center(
                child: AbsorbPointer(
                  absorbing: !canInputOTP,
                  child: Opacity(
                    opacity: canInputOTP ? 1 : 0.4,
                    child: Pinput(
                      length: 6,
                      controller: otpController,
                      defaultPinTheme: PinTheme(
                        width: 56,
                        height: 56,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: canInputOTP
                    ? Text(
                  "Mã hết hạn sau: ${_secondsRemaining ~/ 60}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}",
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                )
                    : const Text(
                  "Mã OTP đã hết hạn. Vui lòng gửi lại.",
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: resendOTP,
                      child: const Text('Gửi lại'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canInputOTP ? const Color(0xFF6A11CB) : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _isLoading || !canInputOTP ? null : verifyOTP,
                      child: _isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                          : const Text('Xác nhận'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
