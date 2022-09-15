import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/modules/gasol/features/players/dvo/player_dvo.dart';

part 'match_dvo.g.dart';

@DataClass()
class MatchDvo with _$MatchDvo {
  final String id;
  final DateTime createdAt;

  final List<PlayerDvo> leftPlayers;
  final List<PlayerDvo> rightPlayers;

  final int leftPoints;
  final int rightPoints;

  const MatchDvo({
    required this.id,
    required this.createdAt,
    required this.leftPlayers,
    required this.rightPlayers,
    required this.leftPoints,
    required this.rightPoints,
  });
}
