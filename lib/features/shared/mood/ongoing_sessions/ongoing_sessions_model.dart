import 'package:we_mama/core/enums/ui_enums.dart';

class OngoingSessionsModel {
  final String name;
  final MoodType moodType;
  final double? hp;

  OngoingSessionsModel({required this.name, required this.moodType, this.hp});
}
