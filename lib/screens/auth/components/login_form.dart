import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vnua_service/generated/l10n.dart';
import 'package:vnua_service/screens/auth/services/auth_service.dart';
import 'package:vnua_service/route/route_constants.dart';

class LogInForm extends StatefulWidget {
  const LogInForm({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  _LogInFormState createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _submitLogin() async {
    if (!widget.formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final response = await _authService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.containsKey("error")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response["error"],
              style: const TextStyle(color: Colors.red)),
          backgroundColor: Colors.black87,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(S.current.generated_login_successful,
                style: const TextStyle(color: Colors.green))),
      );

      // Điều hướng đến HomeScreen
      Navigator.pushNamed(context, LayoutScreenRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // Email Input
          TextFormField(
            controller: _emailController,
            validator: (value) =>
                value!.isEmpty ? S.current.generated_enter_email_address : null,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: S.current.generated_email_address,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: SvgPicture.asset(
                  "assets/icons/Message.svg",
                  height: 24,
                  width: 24,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Password Input
          TextFormField(
            controller: _passwordController,
            validator: (value) =>
                value!.isEmpty ? S.current.generated_enter_password : null,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: S.current.generated_password,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: SvgPicture.asset(
                  "assets/icons/Lock.svg",
                  height: 24,
                  width: 24,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, passwordRecoveryScreenRoute),
              child: Text(S.current.generated_forgot_password,
                  style: const TextStyle(color: Colors.blue)),
            ),
          ),
          // Login Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A11CB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: _isLoading ? null : _submitLogin,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(S.current.generated_login,
                      style:
                          const TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
