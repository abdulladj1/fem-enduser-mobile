class Ticket {
  final String id;
  final String name;
  final DateTime date;
  final int price;
  final int remaining;
  final String seriesId; 
  final List<Match> matchs;

  Ticket({
    required this.id,
    required this.name,
    required this.date,
    required this.price,
    required this.remaining,
    required this.seriesId,
    required this.matchs,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
      price: json['price'],
      remaining: json['quota']['remaining'],
      seriesId: json['seriesId'],
      matchs: (json['matchs'] as List)
          .map((m) => Match.fromJson(m))
          .toList(),
    );
  }
}

class Match {
  final String time;
  final String venue;
  final String homeTeam;
  final String homeLogo;
  final String awayTeam;
  final String awayLogo;

  Match({
    required this.time,
    required this.venue,
    required this.homeTeam,
    required this.homeLogo,
    required this.awayTeam,
    required this.awayLogo,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      time: json['time'],
      venue: json['venue']['name'],
      homeTeam: json['homeSeasonTeam']['team']['name'],
      homeLogo: json['homeSeasonTeam']['team']['logo'],
      awayTeam: json['awaySeasonTeam']['team']['name'],
      awayLogo: json['awaySeasonTeam']['team']['logo'],
    );
  }
}
