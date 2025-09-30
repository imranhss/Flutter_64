import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://localhost:8085";

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({'email': email, 'password': password});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      String token = data['token'];

      Map<String, dynamic> payload = Jwt.parseJwt(token);
      String role = payload['role'];

      // Store token and role
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token);
      await prefs.setString('userRole', role);

      return true;
    } else {
      print('Failed to log in: ${response.body}');
      return false;
    }
  }


  Future<bool> registerJobSeeker({
    required Map<String, dynamic> user,
    required Map<String, dynamic> jobSeeker,
    required File photo,
  }) async {
    final dio = Dio();

    // Prepare multipart form data
    final formData = FormData();

    // Add User and JobSeeker as JSON strings
    formData.fields.add(MapEntry('user', jsonEncode(user)));
    formData.fields.add(MapEntry('jobSeeker', jsonEncode(jobSeeker)));

    // Detect MIME type of the image
    final mimeType = lookupMimeType(photo.path);
    final fileType = mimeType?.split('/') ?? ['image', 'jpeg'];

    // Add image file as MultipartFile
    formData.files.add(
      MapEntry(
        'imageFile',
        await MultipartFile.fromFile(
          photo.path,
          filename: photo.path.split('/').last,
          contentType: MediaType(fileType[0], fileType[1]),
        ),
      ),
    );

    try {
      final response = await dio.post(
        baseUrl+'/api/jobseeker/', // Adjust as needed
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200) {
        // If your backend returns token or some message
        final data = response.data;
        print('Registration successful: $data');

        // Optionally save token if returned
        // final token = data['token'];
        // await SharedPreferences.getInstance().then((prefs) {
        //   prefs.setString('authToken', token);
        // });

        return true;
      } else {
        print('Registration failed: ${response.statusCode}');
        return false;
      }
    } on DioError catch (e) {
      print('Dio error: ${e.response?.data ?? e.message}');
      return false;
    } catch (e) {
      print('Unexpected error: $e');
      return false;
    }
  }







  Future<String?> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('userRole'));
    return prefs.getString('userRole');
  }



}
