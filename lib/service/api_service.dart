import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';

class ApiService  {
  Future<Map<String, dynamic>> getAffirmation() async {
    try {
      final response = await get(
        Uri.parse(
          'https://www.affirmations.dev/',
        ),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        return json;
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      log('ApiService: ${e.toString()}');
      rethrow;
    }
  }
}
