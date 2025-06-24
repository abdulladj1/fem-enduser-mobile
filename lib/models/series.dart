import 'package:ifl_mobile/models/ticket.dart';

class SeriesResponse {
  final int status;
  final String message;
  final SeriesData data;

  SeriesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SeriesResponse.fromJson(Map<String, dynamic> json) {
    return SeriesResponse(
      status: json['status'],
      message: json['message'],
      data: SeriesData.fromJson(json['data']),
    );
  }
}

class SeriesData {
  final int limit;
  final int page;
  final int total;
  final List<Series> list;

  SeriesData({
    required this.limit,
    required this.page,
    required this.total,
    required this.list,
  });

  factory SeriesData.fromJson(Map<String, dynamic> json) {
    return SeriesData(
      limit: json['limit'],
      page: json['page'],
      total: json['total'],
      list:
          (json['list'] as List).map((item) => Series.fromJson(item)).toList(),
    );
  }
}

class Series {
  final String id;
  final String seasonId;
  final Season season;
  final String venueId;
  final Venue venue;
  final String name;
  final int price;
  final int matchCount;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final List<Ticket>? tickets;
  final DateTime createdAt;
  final DateTime updatedAt;

  Series({
    required this.id,
    required this.seasonId,
    required this.season,
    required this.venueId,
    required this.venue,
    required this.name,
    required this.price,
    required this.matchCount,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.tickets,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['id'],
      seasonId: json['seasonId'],
      season: Season.fromJson(json['season']),
      venueId: json['venueId'],
      venue: Venue.fromJson(json['venue']),
      name: json['name'],
      price: json['price'],
      matchCount: json['matchCount'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: json['status'],
      tickets:
          json['tickets'] != null
              ? (json['tickets'] as List)
                  .map((t) => Ticket.fromJson(t))
                  .toList()
              : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Season {
  final String id;
  final String name;

  Season({required this.id, required this.name});

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(id: json['id'], name: json['name']);
  }
}

class Venue {
  final String id;
  final String name;

  Venue({required this.id, required this.name});

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(id: json['id'], name: json['name']);
  }
}
