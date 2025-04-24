import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:vnua_service/url.dart';

class ImageDto {
  final String id;
  final String fileName;
  final String fileType;
  final String url;

  ImageDto({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.url,
  });

  factory ImageDto.fromJson(Map<String, dynamic> json) {
    return ImageDto(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      fileType: json['fileType'] as String,
      url: json['url'] as String,
    );
  }
}

class ImagePostService {
  static const String _baseUrl = "${AppConfig.baseUrl}/api";
  final String token;
  final http.Client _client;

  ImagePostService({
    required this.token,
    http.Client? client,
  }) : _client = client ?? http.Client();

  Map<String, String> get _jsonHeaders => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  };

  /// Upload 1 file
  Future<ImageDto> uploadImage({
    required int postId,
    required Uint8List fileBytes,
    required String fileName,
    required String contentType,
  }) async {
    final uri = Uri.parse('$_baseUrl/uploadImage/post/$postId');
    final req = http.MultipartRequest('POST', uri)
      ..headers.addAll(_jsonHeaders)
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: fileName,
          contentType: MediaType.parse(contentType),
        ),
      );

    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);

    if (res.statusCode == 200) {
      return ImageDto.fromJson(json.decode(res.body));
    } else {
      throw Exception('Upload failed [${res.statusCode}]: ${res.body}');
    }
  }

  /// Delete all images of a post
  Future<void> deleteImages(int postId) async {
    final uri = Uri.parse('$_baseUrl/deleteImage/post/$postId');
    final res = await _client.delete(
      uri,
      headers: _jsonHeaders,
    );

    if (res.statusCode != 200) {
      throw Exception('Delete images failed [${res.statusCode}]: ${res.body}');
    }
  }

  /// Upload multiple files
  Future<List<ImageDto>> uploadMultipleImages({
    required int postId,
    required List<Uint8List> filesBytes,
    required List<String> fileNames,
    required List<String> contentTypes,
  }) async {
    if (filesBytes.length != fileNames.length ||
        filesBytes.length != contentTypes.length) {
      throw ArgumentError('Danh sách fileBytes, fileNames và contentTypes phải cùng độ dài');
    }

    // Gọi tuần tự hoặc song song tuỳ nhu cầu
    final uploads = <Future<ImageDto>>[];
    for (var i = 0; i < filesBytes.length; i++) {
      uploads.add(uploadImage(
        postId: postId,
        fileBytes: filesBytes[i],
        fileName: fileNames[i],
        contentType: contentTypes[i],
      ));
    }
    return Future.wait(uploads);
  }

  /// Lấy danh sách ImageDto khi edit post
  Future<List<ImageDto>> getImageDtosByPost(int postId) async {
    final uri = Uri.parse('$_baseUrl/imageByte/post/$postId');
    final res = await _client.get(uri, headers: _jsonHeaders);

    if (res.statusCode == 200) {
      final List<dynamic> list = json.decode(res.body);
      return list.map((e) => ImageDto.fromJson(e)).toList();
    } else {
      throw Exception('Fetch images failed [${res.statusCode}]: ${res.body}');
    }
  }

  /// Download image data (bytes) theo fileId
  Future<Uint8List> downloadImage(String fileId) async {
    final uri = Uri.parse('$_baseUrl/image/$fileId');
    final res = await _client.get(uri, headers: {
      'Authorization': 'Bearer $token',
      // Media type tuỳ backend, thường binary/octet-stream
    });

    if (res.statusCode == 200) {
      return res.bodyBytes;
    } else {
      throw Exception('Download failed [${res.statusCode}]: ${res.body}');
    }
  }

  /// Lấy list URL (String) khi view chi tiết post
  Future<List<String>> getImageUrlsByPost(int postId) async {
    final uri = Uri.parse('$_baseUrl/image/post/$postId');
    final res = await _client.get(uri, headers: _jsonHeaders);

    if (res.statusCode == 200) {
      final List<dynamic> list = json.decode(res.body);
      return list.cast<String>();
    } else {
      throw Exception('Fetch image URLs failed [${res.statusCode}]: ${res.body}');
    }
  }
}
