import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // Fetch data from the API
  Future<Map<String, dynamic>> fetchData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/input'));
      if (response.statusCode == 200) {
        print('Dữ liệu nhận được từ API GET: ${response.body}');
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error occurred: $error');
      throw Exception('Error occurred: $error');
    }
  }

  // Post data to the API
  Future<void> postData(String token, List<int> results) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/output'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'results': results}),
      );

      if (response.statusCode == 200) {
        print('Results successfully posted');
      } else {
        throw Exception('Failed to post results');
      }
    } catch (error) {
      print('Error occurred while posting: $error');
      throw Exception('Error occurred while posting: $error');
    }
  }
}
