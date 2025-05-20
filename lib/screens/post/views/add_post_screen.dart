import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:vnua_service/screens/post/service/posts_service.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:vnua_service/screens/post/widget/map_picker_screen.dart';
import 'package:flutter_map/flutter_map.dart';

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
  latlong.LatLng? _selectedLocation;
  latlong.LatLng? _searchedLocation;
  bool _showMapPreview = false;

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

  @override
  void initState() {
    super.initState();
    _addressController.addListener(() {
      final address = _addressController.text;
      if (address.isNotEmpty) {
        _loadCoordinatesFromText(address);
      } else {
        setState(() {
          _showMapPreview = false;
        });
      }
    });
  }

  Future<void> _loadCoordinatesFromText(String address) async {
    final coord = await _getCoordinatesFromAddress(address);
    if (coord != null) {
      setState(() {
        _searchedLocation = coord;
        _showMapPreview = true;
      });
    } else {
      setState(() => _showMapPreview = false);
    }
  }

  Future<latlong.LatLng?> _getCoordinatesFromAddress(String address) async {
    final response = await http.get(
      Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(address)}&format=json&limit=1',
      ),
      headers: {'User-Agent': 'EcoPosApp/1.0 (contact: support@ecoposapp.com)'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final lat = double.tryParse(data[0]['lat']);
        final lon = double.tryParse(data[0]['lon']);
        if (lat != null && lon != null) {
          return latlong.LatLng(lat, lon);
        }
      }
    }
    return null;
  }

  Future<void> _openMapPicker(BuildContext context) async {
    final latlong.LatLng? pickedLocation = await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => MapPickerScreen(
          address: _addressController.text,
          initialPosition:
              _selectedLocation ?? const latlong.LatLng(10.7769, 106.7009),
        ),
      ),
    );

    if (pickedLocation != null) {
      final data = await _getAddressFromCoordinates(pickedLocation);
      setState(() {
        _selectedLocation = pickedLocation;
        _addressController.text = data['display_name'];
      });
    }
  }

  Future<Map<String, dynamic>> _getAddressFromCoordinates(
      latlong.LatLng location) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://nominatim.openstreetmap.org/reverse?lat=${location.latitude}&lon=${location.longitude}&format=json'),
        headers: {
          'User-Agent': 'EcoPosApp/1.0 (contact: support@ecoposapp.com)',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (_) {}
    return {};
  }

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
          ...features,
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
      appBar: AppBar(
        title: const Text('Tạo tin đăng'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
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
            if (_showMapPreview && _searchedLocation != null)
              _buildMapPreviewCard(),
            _buildCard(
              title: 'Địa chỉ và tiện ích',
              children: [
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Địa chỉ cụ thể *',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.location_on),
                      onPressed: () async {
                        final latlong.LatLng? pickedLocation =
                            await Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => MapPickerScreen(
                              address: _addressController.text,
                              initialPosition: _selectedLocation ??
                                  const latlong.LatLng(10.7769, 106.7009),
                            ),
                          ),
                        );

                        if (pickedLocation != null) {
                          final data =
                              await _getAddressFromCoordinates(pickedLocation);
                          setState(() {
                            _selectedLocation = pickedLocation;
                            _addressController.text =
                                data['display_name'] ?? '';
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Đặc điểm nổi bật',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: features.entries.map((e) {
                    return FilterChip(
                      label: Text(_featureLabel(e.key)),
                      selected: e.value,
                      selectedColor: Colors.teal.withOpacity(0.2),
                      checkmarkColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onSelected: (val) => setState(() {
                        features[e.key] = val;
                      }),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: pickImages,
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: const Text('Thêm ảnh (tối đa 8)'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
                children: images.map((img) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(File(img.path),
                            fit: BoxFit.cover, width: double.infinity),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => images.remove(img));
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
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

  Widget _buildMapPreviewCard() {
    return _buildCard(
      title: 'Xem trước vị trí trên bản đồ',
      children: [
        SizedBox(
          height: 200,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: _searchedLocation!,
              initialZoom: 15.0,
              interactionOptions:
                  const InteractionOptions(flags: InteractiveFlag.none),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _searchedLocation!,
                    width: 80,
                    height: 80,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal)),
            const SizedBox(height: 16),
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
