import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AddressMapInput extends StatefulWidget {
  final TextEditingController controller;

  const AddressMapInput({super.key, required this.controller});

  @override
  State<AddressMapInput> createState() => _AddressMapInputState();
}

class _AddressMapInputState extends State<AddressMapInput> {
  Timer? _debounce;
  WebViewController? _webViewController;
  String? encodedAddress;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(seconds: 1), () {
      final encoded = Uri.encodeComponent(value);
      setState(() => encodedAddress = encoded);
      _webViewController?.loadRequest(Uri.parse('https://www.google.com/maps?q=$encoded&output=embed'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          decoration: const InputDecoration(labelText: 'Địa chỉ cụ thể *'),
          onChanged: _onChanged,
        ),
        if (encodedAddress != null)
          Container(
            height: 300,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: WebViewWidget(controller: _webViewController!),
            ),
          ),
      ],
    );
  }
}
