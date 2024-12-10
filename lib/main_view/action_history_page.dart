import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:fraze_pocket/models/mood_entry.dart';
import 'package:fraze_pocket/styles/app_theme.dart';

class ActionHistoryPage extends StatefulWidget {
  const ActionHistoryPage({super.key});

  @override
  State<ActionHistoryPage> createState() => _ActionHistoryPageState();
}

class _ActionHistoryPageState extends State<ActionHistoryPage> {
  late Box<MoodEntry> moodBox;

  @override
  void initState() {
    super.initState();
    moodBox = Hive.box<MoodEntry>('moodBox');
  }

  void _clearHistory() async {
    await moodBox.clear();
    setState(() {});
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final moodEntries =
        moodBox.values.toList().cast<MoodEntry>().reversed.toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 1,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                            color: AppTheme.surface, shape: BoxShape.circle),
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  CupertinoButton(
                      onPressed: _clearHistory,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'ACTION\nHISTORY',
                style:
                    AppTheme.displayLarge.copyWith(color: AppTheme.onSurface),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: moodEntries.isEmpty
                    ? Center(
                        child: Text(
                          'Your mood history will be recorded here',
                          style: AppTheme.bodyLarge.copyWith(
                            color: Colors.white60,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: moodEntries.length,
                        itemBuilder: (context, index) {
                          final moodEntry = moodEntries[index];
                          return ActionHistoryItem(
                            image: moodEntry.image,
                            message:
                                "You've changed your mood to ${moodEntry.mood}",
                            date:
                                '${moodEntry.dateTime.day} ${_getMonthName(moodEntry.dateTime.month)}. ${moodEntry.dateTime.year}',
                            time:
                                '${moodEntry.dateTime.hour}:${moodEntry.dateTime.minute.toString().padLeft(2, '0')}',
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionHistoryItem extends StatelessWidget {
  final String image;
  final String message;
  final String date;
  final String time;

  const ActionHistoryItem({
    super.key,
    required this.message,
    required this.date,
    required this.time,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              image:
                  DecorationImage(image: AssetImage(image), fit: BoxFit.fill),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: AppTheme.bodyLarge.copyWith(color: AppTheme.onSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
