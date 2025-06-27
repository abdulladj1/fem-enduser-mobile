import 'dart:convert';

PurchaseResponse purchaseResponseFromJson(String str) =>
    PurchaseResponse.fromJson(json.decode(str)["data"]);

class PurchaseResponse {
  PurchaseResponse({
    required this.id,
    required this.member,
    required this.season,
    required this.series,
    required this.tickets,
    required this.amount,
    required this.invoice,
    required this.price,
    required this.grandTotal,
    required this.isCheckoutPackage,
    required this.status,
    required this.expiresAt,
    required this.paidAt,
  });

  final String id;
  final Member member;
  final Season season;
  final Series series;
  final List<Ticket> tickets;
  final int amount;
  final Invoice invoice;
  final double price;
  final double grandTotal;
  final bool isCheckoutPackage;
  final String status;
  final DateTime expiresAt;
  final DateTime? paidAt;

  factory PurchaseResponse.fromJson(Map<String, dynamic> json) =>
      PurchaseResponse(
        id: json["id"],
        member: Member.fromJson(json["member"]),
        season: Season.fromJson(json["season"]),
        series: Series.fromJson(json["series"]),
        tickets: List<Ticket>.from(
          json["tickets"].map((x) => Ticket.fromJson(x)),
        ),
        amount: json["amount"],
        invoice: Invoice.fromJson(json["invoice"]),
        price: (json["price"] as num).toDouble(),
        grandTotal: (json["grandTotal"] as num).toDouble(),
        isCheckoutPackage: json["isCheckoutPackage"],
        status: json["status"],
        expiresAt: DateTime.parse(json["expiresAt"]),
        paidAt: json["paidAt"] == null ? null : DateTime.parse(json["paidAt"]),
      );
}

/* ---------- sub-models ---------- */

class Member {
  Member({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  final String id, name, email, phone;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"] ?? "",
  );
}

class Season {
  Season({required this.id, required this.name});
  final String id, name;
  factory Season.fromJson(Map<String, dynamic> json) =>
      Season(id: json["id"], name: json["name"]);
}

class Series {
  Series({required this.id, required this.name});
  final String id, name;
  factory Series.fromJson(Map<String, dynamic> json) =>
      Series(id: json["id"], name: json["name"]);
}

class Ticket {
  Ticket({
    required this.id,
    required this.name,
    required this.date,
    required this.venueId,
  });

  final String id, name, venueId;
  final DateTime date;

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
    id: json["id"],
    name: json["name"],
    date: DateTime.parse(json["date"]),
    venueId: json["venueId"],
  );
}

class Invoice {
  Invoice({
    required this.invoiceId,
    required this.invoiceExternalId,
    required this.invoiceUrl,
    required this.paymentMethod,
    required this.merchantName,
    required this.bankCode,
    required this.paymentChannel,
    required this.paymentDestination,
  });

  final String invoiceId,
      invoiceExternalId,
      invoiceUrl,
      paymentMethod,
      merchantName,
      bankCode,
      paymentChannel,
      paymentDestination;

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
    invoiceId: json["invoiceId"],
    invoiceExternalId: json["invoiceExternalId"],
    invoiceUrl: json["invoiceUrl"],
    paymentMethod: json["PaymentMethod"],
    merchantName: json["merchantName"],
    bankCode: json["bankCode"] ?? "",
    paymentChannel: json["paymentChannel"] ?? "",
    paymentDestination: json["paymentDestination"] ?? "",
  );
}
