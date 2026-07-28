import 'package:we_mama/core/enums/ui_enums.dart';

class MoodRowModel {
  final String name;
  final MoodType moodType;
  final double? hp;

  MoodRowModel({required this.name, required this.moodType, this.hp});
}
