import 'dart:convert';
import 'package:http/http.dart' as http;

class WifiService {
  static const String baseUrl = 'http://192.168.1.123';

  static Future<String> readSerial() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/read_serial'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final serial = data['serial_number'];
        if (serial is String) {
          return serial;
        } else {
          return 'Invalid serial format';
        }
      } else {
        return 'Error ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  static Future<String> writeSerial(
      String username, String password, String serial) async {
    try {
      final url = '$baseUrl/write_serial'
          '?username=${Uri.encodeComponent(username)}'
          '&password=${Uri.encodeComponent(password)}'
          '&serial=${Uri.encodeComponent(serial)}';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final message = data['message'];
        if (message is String) {
          return message;
        } else {
          return 'Response received but message missing';
        }
      } else {
        return 'Error ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
