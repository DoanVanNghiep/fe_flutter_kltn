import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../constants.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    super.key,
    required this.formKey,
    required this.formData,
  });

  final GlobalKey<FormState> formKey;
  final Map<String, String> formData;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            onSaved: (name) => formData['fullName'] = name!,
            validator: (value) => value!.isEmpty ? 'Tên không được để trống' : null,
            decoration: InputDecoration(
              hintText: "Tên người dùng",
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset("assets/icons/Person.svg", height: 24, width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.3),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            onSaved: (email) => formData['email'] = email!,
            validator: (value) => value!.isEmpty ? 'Email không được để trống' : null,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Địa chỉ Email",
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset("assets/icons/Message.svg", height: 24, width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.3),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            onSaved: (pass) => formData['password'] = pass!,
            validator: (value) => value!.length < 6 ? 'Mật khẩu phải từ 6 ký tự trở lên' : null,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Mật khẩu",
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset("assets/icons/Lock.svg", height: 24, width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.3),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
