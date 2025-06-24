import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ifl_mobile/models/season.dart';
import 'package:http/http.dart' as http;

Future<Season> fetchActiveSeason() async {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    final uri = Uri.parse('$baseUrl/member/seasons/active');

    final responseSeries = await http.get(uri);

    if (responseSeries.statusCode == 200) {
      final data = json.decode(responseSeries.body);
      return Season.fromJson(data['data']);
    } else {
      throw Exception('Failed to load series');
    }
  }