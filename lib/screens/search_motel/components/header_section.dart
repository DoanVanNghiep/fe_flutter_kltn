import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderSection extends StatefulWidget {
  const HeaderSection({super.key});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString("name") ?? "User";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "👋 Xin chào, $_userName",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Row(
          children: [
            Icon(Icons.location_on, color: Colors.blue),
            Text("Vị trí"),
          ],
        ),
      ],
    );
  }
}
