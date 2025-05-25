import 'dart:convert';
import 'package:http/http.dart' as http;

class WifiService {
  static const String baseUrl = 'http://192.168.1.123';

  static Future<String> readSerial() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/read_serial'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['serial_number']?.toString() ?? 'No serial number found';
      } else {
        return 'Error ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  static Future<String> writeSerial(
    String username,
    String password,
    String serial,
  ) async {
    try {
      final url = '$baseUrl/write_serial'
          '?username=${Uri.encodeComponent(username)}'
          '&password=${Uri.encodeComponent(password)}'
          '&serial=${Uri.encodeComponent(serial)}';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message']?.toString() ?? 'Serial written';
      } else {
        return 'Error ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
