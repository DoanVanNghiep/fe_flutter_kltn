import 'package:flutter/material.dart';

class SelectLanguageScreen extends StatelessWidget {
  final void Function(Locale) onLocaleChange;

  const SelectLanguageScreen({super.key, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chọn ngôn ngữ")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("🇻🇳 Tiếng Việt"),
            onTap: () {
              onLocaleChange(const Locale('vi'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("🇺🇸 English"),
            onTap: () {
              onLocaleChange(const Locale('en'));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
