import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://football-live-stream-api.p.rapidapi.com';

  static const Map<String, String> headers = {
    'x-rapidapi-key': 'bde2dc1befmshfc8ad330c2216fap18d4a6jsn6ca2003638f5',
    'x-rapidapi-host': 'football-live-stream-api.p.rapidapi.com',
  };
  Future<List<dynamic>> fetchMatches() async {
    final response = await http.get(
      Uri.parse('$baseUrl/all-match'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['result'] ?? [];
    } else {
      throw Exception('Failed to load matches');
    }
  }

  Future<String> fetchStreamUrl(String matchId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/link/$matchId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['url'] ?? '';
    } else {
      throw Exception('Failed to load stream url');
    }
  }
}
