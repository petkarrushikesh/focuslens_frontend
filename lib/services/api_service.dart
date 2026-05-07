import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import '../models/focus_models.dart';

class ApiService {
  // static const String baseUrl = 'http://192.168.1.34:5000/';
  static const String baseUrl = 'http://127.0.0.1:5000';
  static const String uploadEndpoint = '$baseUrl/upload-session';

  static Future<SessionResponse> uploadSession({
    required File videoFile,
    bool indexAudio = false,
    String languageCode = 'en',
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(uploadEndpoint));

      // Add video file
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          videoFile.path,
          contentType: http.MediaType('video', 'mp4'),
        ),
      );

      // Add optional fields
      if (indexAudio) {
        request.fields['index_audio'] = 'true';
        request.fields['language_code'] = languageCode;
      }

      // Send request with timeout
      final streamedResponse = await request.send().timeout(
        const Duration(minutes: 10),
        onTimeout: () {
          throw Exception('Upload timeout - server took too long to respond');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return SessionResponse.fromJson(jsonData);
      } else if (response.statusCode == 400) {
        throw Exception('Bad request: Missing file or unsupported format');
      } else if (response.statusCode == 422) {
        throw Exception('Unprocessable: Video too short or empty index');
      } else if (response.statusCode == 502) {
        throw Exception('Bad Gateway: VideoDB API error');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception(
          'Connection error: Cannot connect to server. Is the Flask backend running at $baseUrl?');
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> healthCheck() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}