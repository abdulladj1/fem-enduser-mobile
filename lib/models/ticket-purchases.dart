class TicketPurchaseResponse {
  final int status;
  final String message;
  final TicketPurchase data;

  TicketPurchaseResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TicketPurchaseResponse.fromJson(Map<String, dynamic> json) {
    return TicketPurchaseResponse(
      status: json['status'],
      message: json['message'],
      data: TicketPurchase.fromJson(json['data']),
    );
  }
}

class TicketPurchase {
  final String id;
  final String purchaseId;
  final String code;
  final bool isUsed;
  final DateTime? usedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MemberPurchaseFK member;
  final TicketFK ticket;
  final VenueFK venue;

  TicketPurchase({
    required this.id,
    required this.purchaseId,
    required this.code,
    required this.isUsed,
    this.usedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.member,
    required this.ticket,
    required this.venue,
  });

  factory TicketPurchase.fromJson(Map<String, dynamic> json) {
    return TicketPurchase(
      id: json['id'],
      purchaseId: json['purchaseId'],
      code: json['code'],
      isUsed: json['isUsed'],
      usedAt: json['usedAt'] != null ? DateTime.parse(json['usedAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      member: MemberPurchaseFK.fromJson(json['member']),
      ticket: TicketFK.fromJson(json['ticket']),
      venue: VenueFK.fromJson(json['venue']),
    );
  }
}

class MemberPurchaseFK {
  final String id;
  final String name;
  final String email;
  final String phone;

  MemberPurchaseFK({required this.id, required this.name, required this.email, required this.phone});

  factory MemberPurchaseFK.fromJson(Map<String, dynamic> json) {
    return MemberPurchaseFK(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}

class TicketFK {
  final String id;
  final String name;
  final String date;
  final String venueId;

  TicketFK({required this.id, required this.name, required this.date, required this.venueId});

  factory TicketFK.fromJson(Map<String, dynamic> json) {
    return TicketFK(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      venueId: json['venueId'],
    );
  }
}

class VenueFK {
  final String id;
  final String name;

  VenueFK({required this.id, required this.name});

  factory VenueFK.fromJson(Map<String, dynamic> json) {
    return VenueFK(
      id: json['id'],
      name: json['name'],
    );
  }
}
