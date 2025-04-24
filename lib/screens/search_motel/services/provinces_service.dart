import 'dart:convert';
import 'package:http/http.dart' as http;

class Ward {
  final String name;

  Ward({required this.name});

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(name: json['name']);
  }
}

class District {
  final String name;
  final List<Ward> wards;

  District({required this.name, required this.wards});

  factory District.fromJson(Map<String, dynamic> json) {
    final wardsJson = json['wards'] as List<dynamic>;
    final wards = wardsJson.map((w) => Ward.fromJson(w)).toList();
    return District(name: json['name'], wards: wards);
  }
}

class Province {
  final String name;
  final List<District> districts;

  Province({required this.name, required this.districts});

  factory Province.fromJson(Map<String, dynamic> json) {
    final districtsJson = json['districts'] as List<dynamic>;
    final districts = districtsJson.map((d) => District.fromJson(d)).toList();
    return Province(name: json['name'], districts: districts);
  }
}

class ProvinceService {
  static String stripPrefix(String name) {
    return name
        .replaceAll(RegExp(r'^(Tỉnh|Thành phố|TP\.?|Quận|Huyện|Thị xã|Phường|Xã|Thị trấn)\s*'), '')
        .trim();
  }

  static Future<List<Province>> fetchAllData() async {
    final response = await http.get(Uri.parse('https://provinces.open-api.vn/api/?depth=3'));

    if (response.statusCode == 200) {
      final decoded = json.decode(utf8.decode(response.bodyBytes));
      return (decoded as List).map((item) => Province.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load full provinces data');
    }
  }

  static Future<List<String>> getAllLocationNames() async {
    final data = await fetchAllData();
    final allNames = <String>[];

    for (var province in data) {
      final provinceName = stripPrefix(province.name);

      for (var district in province.districts) {
        final districtName = stripPrefix(district.name);

        for (var ward in district.wards) {
          final wardName = stripPrefix(ward.name);
          allNames.add("$wardName, $districtName, $provinceName");
        }
      }
    }

    return allNames;
  }
}
