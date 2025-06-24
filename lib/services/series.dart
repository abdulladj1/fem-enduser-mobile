import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ifl_mobile/models/series.dart';
import 'package:http/http.dart' as http;

Future<List<Series>> fetchSeries({
    int? status,
    String? seasonId,
    String? sort,
    String? dir,
  }) async {
    final queryParams = <String, String>{};

    if (status != null) queryParams['status'] = status.toString();
    if (seasonId != null) queryParams['seasonId'] = seasonId;
    if (sort != null) queryParams['sort'] = sort;
    if (dir != null) queryParams['dir'] = dir;

    final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    final uri = Uri.parse(
      '$baseUrl/member/series/with-tickets',
    ).replace(queryParameters: queryParams);

    final responseSeries = await http.get(uri);

    if (responseSeries.statusCode == 200) {
      final data = json.decode(responseSeries.body);
      final list = data['data']['list'] as List;
      return list.map((json) => Series.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load series');
    }
  }