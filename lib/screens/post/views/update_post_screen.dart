import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vnua_service/screens/post/service/posts_service.dart';

class UpdatePostScreen extends StatefulWidget {
  final int postId;
  const UpdatePostScreen({super.key, required this.postId});

  @override
  State<UpdatePostScreen> createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final PostsService _postService = PostsService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _acreageController = TextEditingController();
  final TextEditingController _electricPriceController = TextEditingController();
  final TextEditingController _waterPriceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _selectedMotel = 'PHONG_TRO';
  bool? _selectedGender;
  int? _districtId;
  List<File> _selectedImages = [];
  List<Map<String, dynamic>> _existingImages = [];
  bool _loading = false;

  final List<Map<String, dynamic>> _districtList = [
    {'id': 1, 'name': 'An Đào'},
    {'id': 4, 'name': 'Đào Nguyên'},
    {'id': 5, 'name': 'Cửu Việt'},
    {'id': 6, 'name': 'Thành Chung'},
    {'id': 7, 'name': 'Ngô Xuân Quảng'},
    {'id': 8, 'name': 'Vinhomes Ocean Park'},
    {'id': 9, 'name': 'Khác'},
  ];

  final List<Map<String, dynamic>> _features = [
    {'label': 'Đầy đủ nội thất', 'key': 'interior'},
    {'label': 'Có điều hòa', 'key': 'airConditioner'},
    {'label': 'Có nóng lạnh', 'key': 'heater'},
    {'label': 'Có internet', 'key': 'internet'},
    {'label': 'Vệ sinh khép kín', 'key': 'toilet'},
    {'label': 'Giờ giấc tự do', 'key': 'time'},
    {'label': 'Có chỗ để xe', 'key': 'parking'},
    {'label': 'An ninh tốt', 'key': 'security'},
    {'label': 'Không chung chủ', 'key': 'owner'},
    {'label': 'Kệ bếp', 'key': 'kitchen'},
  ];

  Map<String, bool> _selectedFeatures = {};

  @override
  void initState() {
    super.initState();
    _features.forEach((f) => _selectedFeatures[f['key']] = false);
    _loadPostData();
  }

  Future<void> _loadPostData() async {
    final post = await _postService.getPostById(widget.postId);
    if (post != null) {
      setState(() {
        _titleController.text = post['title'] ?? '';
        _contentController.text = post['content'] ?? '';
        final acc = post['accomodationDTO'] ?? {};
        _selectedMotel = acc['motel'] ?? 'PHONG_TRO';
        _priceController.text = acc['price']?.toString() ?? '';
        _acreageController.text = acc['acreage']?.toString() ?? '';
        _electricPriceController.text = acc['electricPrice']?.toString() ?? '';
        _waterPriceController.text = acc['waterPrice']?.toString() ?? '';
        _addressController.text = acc['address'] ?? '';
        _districtId = acc['district']?['id'];
        _selectedGender = acc['gender'];
        _features.forEach((f) {
          _selectedFeatures[f['key']] = acc[f['key']] == true;
        });
      });
    }
  }

  Future<void> _pickImages() async {
    final picked = await ImagePicker().pickMultiImage(
      imageQuality: 80,
      requestFullMetadata: false,
    );
    if (picked.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(picked.map((e) => File(e.path)));
      });
    }
  }

  Future<void> _updatePost() async {
    if (!_formKey.currentState!.validate()) return;

    final totalImages = _existingImages.length + _selectedImages.length;
    if (totalImages < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ít nhất 5 ảnh.')),
      );
      return;
    }

    final featuresMap = {
      for (var f in _features) f['key']: _selectedFeatures[f['key']] ?? false
    };

    final data = {
      'title': _titleController.text.trim(),
      'content': _contentController.text.trim(),
      'accomodation': {
        'price': int.tryParse(_priceController.text),
        'acreage': int.tryParse(_acreageController.text),
        'electricPrice': int.tryParse(_electricPriceController.text),
        'waterPrice': int.tryParse(_waterPriceController.text),
        'address': _addressController.text.trim(),
        'motel': _selectedMotel,
        'district': {'id': _districtId},
        'gender': _selectedMotel == 'O_GHEP' ? _selectedGender : null,
        ...featuresMap
      },
    };

    setState(() => _loading = true);
    final result = await _postService.updatePostWithImages(
      widget.postId,
      data,
      _selectedImages,
    );
    setState(() => _loading = false);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thành công!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi khi cập nhật bài đăng.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cập nhật tin đăng'), backgroundColor: Colors.teal),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardField(
                child: TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Tiêu đề'),
                  validator: (value) {
                    if (value == null || value.trim().length < 10) {
                      return 'Tiêu đề phải từ 10 ký tự trở lên';
                    }
                    return null;
                  },
                ),
              ),
              _buildCardField(
                child: TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(labelText: 'Nội dung mô tả'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().length < 50) {
                      return 'Nội dung phải từ 50 ký tự trở lên';
                    }
                    return null;
                  },
                ),
              ),
              _buildCardField(
                child: DropdownButtonFormField<String>(
                  value: _selectedMotel,
                  items: const [
                    DropdownMenuItem(value: 'PHONG_TRO', child: Text('Phòng trọ')),
                    DropdownMenuItem(value: 'O_GHEP', child: Text('Ở ghép')),
                  ],
                  onChanged: (val) => setState(() => _selectedMotel = val!),
                  decoration: const InputDecoration(labelText: 'Loại hình'),
                ),
              ),
              if (_selectedMotel == 'O_GHEP')
                _buildCardField(
                  child: DropdownButtonFormField<bool?>(
                    value: _selectedGender,
                    decoration: const InputDecoration(labelText: 'Giới tính yêu cầu'),
                    items: const [
                      DropdownMenuItem(value: true, child: Text('Nam')),
                      DropdownMenuItem(value: false, child: Text('Nữ')),
                      DropdownMenuItem(value: null, child: Text('Không yêu cầu')),
                    ],
                    onChanged: (val) => setState(() => _selectedGender = val),
                  ),
                ),
              _buildCardField(child: _buildNumberField(_priceController, 'Giá cho thuê')),
              _buildCardField(child: _buildNumberField(_acreageController, 'Diện tích (m²)')),
              _buildCardField(child: _buildNumberField(_electricPriceController, 'Giá điện (đ/kWh)')),
              _buildCardField(child: _buildNumberField(_waterPriceController, 'Giá nước (đ/m³)')),
              _buildCardField(
                child: DropdownButtonFormField<int>(
                  value: _districtId,
                  items: _districtList.map((e) => DropdownMenuItem<int>(
                    value: e['id'] as int,
                    child: Text(e['name'] as String),
                  )).toList(),
                  onChanged: (val) => setState(() => _districtId = val),
                  decoration: const InputDecoration(labelText: 'Khu vực'),
                ),
              ),
              _buildCardField(
                child: TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Địa chỉ cụ thể'),
                ),
              ),
              const SizedBox(height: 8),
              Text("Đặc điểm nổi bật", style: Theme.of(context).textTheme.titleMedium),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _features.map((f) {
                  return FilterChip(
                    label: Text(f['label']),
                    selected: _selectedFeatures[f['key']]!,
                    onSelected: (val) => setState(() => _selectedFeatures[f['key']] = val),
                    selectedColor: Colors.teal.shade100,
                    checkmarkColor: Colors.teal,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImages,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text('Chọn ảnh mới'),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _selectedImages.map((f) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Image.file(f, fit: BoxFit.cover, width: 100),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedImages.remove(f)),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                )).toList(),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updatePost,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Cập nhật bài đăng', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardField({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: child,
    );
  }

  Widget _buildNumberField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      validator: (value) => value!.isEmpty ? 'Không được để trống' : null,
    );
  }
}
