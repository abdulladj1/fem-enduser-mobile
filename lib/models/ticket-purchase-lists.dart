import 'package:ifl_mobile/models/ticket-purchases.dart';

class TicketPurchaseListResponse {
  final int status;
  final String message;
  final List<TicketPurchase> list;
  final int total;

  TicketPurchaseListResponse({
    required this.status,
    required this.message,
    required this.list,
    required this.total,
  });

  factory TicketPurchaseListResponse.fromJson(Map<String, dynamic> json) {
    return TicketPurchaseListResponse(
      status: json['status'],
      message: json['message'],
      list: (json['data']['list'] as List)
          .map((e) => TicketPurchase.fromJson(e))
          .toList(),
      total: json['data']['total'],
    );
  }
}
