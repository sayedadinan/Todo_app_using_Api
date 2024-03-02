import 'dart:convert';

import 'package:http/http.dart' as http;

class TodoService {
  static Future<bool> deletedbyid(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final respomse = await http.delete(uri);
    return respomse.statusCode == 200;
  }

  static Future<List?> fetchdata() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      return result;
    } else {
      return null;
    }
  }
}
