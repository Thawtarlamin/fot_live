class Match {
  final String id;
  final String status;
  final String date;
  final String time;
  final String score;
  final String league;
  final String homeName;
  final String awayName;
  final String homeFlag;
  final String awayFlag;

  Match({
    required this.id,
    required this.status,
    required this.date,
    required this.time,
    required this.score,
    required this.league,
    required this.homeName,
    required this.awayName,
    required this.homeFlag,
    required this.awayFlag,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      status: json['status'],
      date: json['date'],
      time: json['time'],
      score: json['score'],
      league: json['league'],
      homeName: json['home_name'],
      awayName: json['away_name'],
      homeFlag: json['home_flag'],
      awayFlag: json['away_flag'],
    );
  }
}
