import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/purchase.dart';
import 'package:ifl_mobile/constants/purchase-type.dart';

class PurchaseService {
  final _client = http.Client();
  final _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  Future<PurchaseResponse> createPurchase(
    PurchaseType type,
    String productId, {
    int amount = 1,
    required String token,
  }) async {
    final uri = Uri.parse(
      type == PurchaseType.package
          ? '$_baseUrl/member/purchases/packages'
          : '$_baseUrl/member/purchases',
    );

    final body = jsonEncode({'productId': productId, 'amount': amount});

    final res = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (res.statusCode != 200) {
      throw Exception('Purchase failed → ${res.statusCode}: ${res.body}');
    }

    return purchaseResponseFromJson(res.body);
  }
}
