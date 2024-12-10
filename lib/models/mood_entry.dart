import 'package:hive/hive.dart';

part 'mood_entry.g.dart';

@HiveType(typeId: 0)
class MoodEntry {
  @HiveField(0)
  late String mood;

  @HiveField(1)
  late DateTime dateTime;

  @HiveField(2)
  late String image;

  MoodEntry({
    required this.mood,
    required this.dateTime,
    required this.image,
  });
}
