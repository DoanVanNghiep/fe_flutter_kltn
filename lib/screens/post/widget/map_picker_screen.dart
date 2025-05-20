import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as latlong;
import 'package:vnua_service/res/color.dart';

class MapPickerScreen extends StatefulWidget {
  final latlong.LatLng initialPosition;
  final String? address;

  const MapPickerScreen({
    super.key,
    required this.initialPosition,
    this.address,
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late latlong.LatLng _selectedPosition;
  final MapController _mapController = MapController();
  String? _displayedAddress;

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.initialPosition;

    // Nếu có address truyền vào → convert sang LatLng
    if (widget.address != null && widget.address!.isNotEmpty) {
      _loadCoordinatesFromAddress(widget.address!);
    }
  }

  Future<void> _loadCoordinatesFromAddress(String address) async {
    final coord = await _getCoordinatesFromAddress(address);
    if (coord != null) {
      setState(() {
        _selectedPosition = coord;
        _mapController.move(coord, 15.0);
        _displayedAddress = address;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chọn vị trí"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop(_selectedPosition);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.initialPosition,
              initialZoom: 15.0,
              onTap: (tapPosition, point) {
                setState(() {
                  _selectedPosition = point;
                  _displayedAddress = null; // Xoá địa chỉ khi chọn mới
                });
                _mapController.move(point, 15.0);
              },
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
                    point: _selectedPosition,
                    width: 80,
                    height: 80,
                    child: const Icon(
                      Icons.location_pin,
                      color: AppColors.primary,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Hiển thị địa chỉ nếu có
          if (_displayedAddress != null)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _displayedAddress!,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
