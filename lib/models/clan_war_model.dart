import 'package:lucasbeatsfederacao/models/clan_model.dart';
import 'package:lucasbeatsfederacao/models/user_model.dart';

class ClanWar {
  final String id;
  final Clan challengerClan;
  final Clan challengedClan;
  final String status;
  final DateTime declaredAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final Clan? winnerClan;
  final Clan? loserClan;
  final Map<String, int> score;
  final String rules;
  final List<String> evidence;
  final User declaredBy;
  final User? respondedBy;
  final User? reportedBy;
  final String? cancellationReason;
  final DateTime updatedAt;

  ClanWar({
    required this.id,
    required this.challengerClan,
    required this.challengedClan,
    required this.status,
    required this.declaredAt,
    this.startedAt,
    this.endedAt,
    this.winnerClan,
    this.loserClan,
    required this.score,
    required this.rules,
    required this.evidence,
    required this.declaredBy,
    this.respondedBy,
    this.reportedBy,
    this.cancellationReason,
    required this.updatedAt,
  });

  factory ClanWar.fromMap(Map<String, dynamic> json) {
    return ClanWar(
      id: json['_id'] as String,
      challengerClan: Clan.fromMap(json['challengerClan'] as Map<String, dynamic>),
      challengedClan: Clan.fromMap(json['challengedClan'] as Map<String, dynamic>),
      status: json['status'] as String,
      declaredAt: DateTime.parse(json['declaredAt'] as String),
      startedAt: json['startedAt'] != null ? DateTime.parse(json['startedAt'] as String) : null,
      endedAt: json['endedAt'] != null ? DateTime.parse(json['endedAt'] as String) : null,
      winnerClan: json['winnerClan'] != null ? Clan.fromMap(json['winnerClan'] as Map<String, dynamic>) : null,
      loserClan: json['loserClan'] != null ? Clan.fromMap(json['loserClan'] as Map<String, dynamic>) : null,
      score: Map<String, int>.from(json['score'] as Map<String, dynamic>),
      rules: json['rules'] as String,
      evidence: List<String>.from(json['evidence'] as List<dynamic>),
      declaredBy: User.fromJson(json['declaredBy'] as Map<String, dynamic>),
      respondedBy: json['respondedBy'] != null ? User.fromJson(json['respondedBy'] as Map<String, dynamic>) : null,
      reportedBy: json['reportedBy'] != null ? User.fromJson(json['reportedBy'] as Map<String, dynamic>) : null,
      cancellationReason: json['cancellationReason'] as String?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}


