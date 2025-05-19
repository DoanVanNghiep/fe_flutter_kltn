import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vnua_service/screens/post/service/posts_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String? selectedMotelType = 'PHONG_TRO';
  String? selectedGender;
  int? selectedDistrictId;
  bool loading = false;

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _priceController = TextEditingController();
  final _acreageController = TextEditingController();
  final _electricController = TextEditingController();
  final _waterController = TextEditingController();
  final _addressController = TextEditingController();

  final List<XFile> images = [];
  final List<Map<String, dynamic>> districts = [
    {'id': 1, 'name': 'An Đào'},
    {'id': 4, 'name': 'Đào Nguyên'},
    {'id': 5, 'name': 'Cửu Việt'},
    {'id': 6, 'name': 'Thành Chung'},
    {'id': 7, 'name': 'Ngô Xuân Quảng'},
    {'id': 8, 'name': 'Vinhomes Ocean Park'},
    {'id': 9, 'name': 'Khác'},
  ];

  final Map<String, bool> features = {
    'interior': false,
    'airConditioner': false,
    'heater': false,
    'internet': false,
    'toilet': false,
    'time': false,
    'parking': false,
    'security': false,
    'owner': false,
    'kitchen': false,
  };

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> picked = await picker.pickMultiImage();
    if (picked.length <= 8) {
      setState(() => images.addAll(picked));
    }
  }

  void submitPost() async {
    if (_titleController.text.isEmpty ||
        _contentController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _acreageController.text.isEmpty ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Vui lòng nhập đầy đủ thông tin bắt buộc')),
      );
      return;
    }

    setState(() => loading = true);

    try {
      // Tạm thời lấy path ảnh để test (cần upload ảnh sau nếu backend yêu cầu)
      List<String> imagePaths = images.map((x) => x.path).toList();

      final Map<String, dynamic> postData = {
        "title": _titleController.text,
        "content": _contentController.text,
        "images": images.map((x) => x.path).toList(),
        "accomodation": {
          "price": int.tryParse(_priceController.text) ?? 0,
          "acreage": int.tryParse(_acreageController.text) ?? 0,
          "address": _addressController.text,
          "motel": selectedMotelType,
          "gender": selectedMotelType == 'O_GHEP'
              ? (selectedGender == 'true'
                  ? true
                  : selectedGender == 'false'
                      ? false
                      : null)
              : null,
          "districtId": selectedDistrictId ?? 9,
          "electricPrice": int.tryParse(_electricController.text) ?? 0,
          "waterPrice": int.tryParse(_waterController.text) ?? 0,
          "airConditioner": features["airConditioner"] ?? false,
          "heater": features["heater"] ?? false,
          "internet": features["internet"] ?? false,
          "interior": features["interior"] ?? false,
          "kitchen": features["kitchen"] ?? false,
          "owner": features["owner"] ?? false,
          "parking": features["parking"] ?? false,
          "security": features["security"] ?? false,
          "time": features["time"] ?? false,
          "toilet": features["toilet"] ?? false
        }
      };

      final result = await PostsService().createPost(postData);

      setState(() => loading = false);

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng tin thành công!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng tin thất bại!')),
        );
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng tin cho thuê')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(
              title: 'Thông tin cơ bản',
              children: [
                _buildDropdownMotelType(),
                if (selectedMotelType == 'O_GHEP') _buildDropdownGender(),
                _buildTextField(_titleController, 'Tiêu đề *'),
                _buildTextField(_contentController, 'Nội dung mô tả *',
                    maxLines: 3),
              ],
            ),
            _buildCard(
              title: 'Giá và diện tích',
              children: [
                _buildTextField(
                    _priceController, 'Giá cho thuê (VD: 1000000) *',
                    keyboard: TextInputType.number),
                _buildTextField(_acreageController, 'Diện tích (m²) *',
                    keyboard: TextInputType.number),
                _buildTextField(_electricController, 'Giá điện (đồng/kWh)',
                    keyboard: TextInputType.number),
                _buildTextField(_waterController, 'Giá nước (đồng/m³)',
                    keyboard: TextInputType.number),
              ],
            ),
            _buildCard(
              title: 'Địa chỉ và tiện ích',
              children: [
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Địa chỉ cụ thể *',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Đặc điểm nổi bật',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: features.entries.map((e) {
                    final selected = e.value;
                    return FilterChip(
                      label: Text(_featureLabel(e.key)),
                      selected: selected,
                      selectedColor: Colors.teal.shade100,
                      onSelected: (bool val) {
                        setState(() => features[e.key] = val);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: pickImages,
              icon: const Icon(Icons.upload),
              label: const Text('Chọn ảnh (tối đa 8)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            if (images.isNotEmpty)
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: images
                    .map((img) => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(File(img.path), fit: BoxFit.cover),
                        ))
                    .toList(),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: loading ? null : submitPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Tạo bài viết',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1, TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdownMotelType() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: selectedMotelType,
        decoration: const InputDecoration(
            labelText: 'Loại hình *', border: OutlineInputBorder()),
        items: const [
          DropdownMenuItem(value: 'PHONG_TRO', child: Text('Tìm phòng trọ')),
          DropdownMenuItem(value: 'O_GHEP', child: Text('Tìm người ở ghép')),
        ],
        onChanged: (val) => setState(() => selectedMotelType = val),
      ),
    );
  }

  Widget _buildDropdownGender() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        decoration: const InputDecoration(
            labelText: 'Giới tính yêu cầu', border: OutlineInputBorder()),
        items: const [
          DropdownMenuItem(value: 'true', child: Text('Nam')),
          DropdownMenuItem(value: 'false', child: Text('Nữ')),
          DropdownMenuItem(value: 'null', child: Text('Không yêu cầu')),
        ],
        onChanged: (val) => setState(() => selectedGender = val),
      ),
    );
  }

  String _featureLabel(String key) {
    switch (key) {
      case 'interior':
        return 'Đầy đủ nội thất';
      case 'airConditioner':
        return 'Có điều hòa';
      case 'heater':
        return 'Có nóng lạnh';
      case 'internet':
        return 'Có internet';
      case 'toilet':
        return 'Vệ sinh khép kín';
      case 'time':
        return 'Giờ giấc tự do';
      case 'parking':
        return 'Có chỗ để xe';
      case 'security':
        return 'An ninh tốt';
      case 'owner':
        return 'Không chung chủ';
      case 'kitchen':
        return 'Kệ bếp';
      default:
        return key;
    }
  }
}
