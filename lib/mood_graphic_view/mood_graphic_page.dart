import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fraze_pocket/settings_view/settings_page.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:fraze_pocket/main_view/action_history_page.dart';
import 'package:fraze_pocket/models/mood_entry.dart';
import 'package:fraze_pocket/styles/app_theme.dart';

class MoodGraphicPage extends StatefulWidget {
  const MoodGraphicPage({super.key});

  @override
  State<MoodGraphicPage> createState() => _MoodGraphicPageState();
}

class _MoodGraphicPageState extends State<MoodGraphicPage> {
  List<Color> gradientColors = [
    const Color(0xff434343),
    const Color.fromARGB(45, 67, 67, 67),
  ];

  late Box<MoodEntry> moodBox;
  List<FlSpot> moodSpots = [];
  List<String> weekDays = [];

  @override
  void initState() {
    super.initState();
    moodBox = Hive.box<MoodEntry>('moodBox');
    _loadLastSevenDaysMoods();

    moodBox.watch().listen((event) {
      _loadLastSevenDaysMoods();
    });
  }

  void _loadLastSevenDaysMoods() {
    final DateTime today = DateTime.now();
    List<DateTime> lastSevenDays = List.generate(7, (index) {
      return DateTime(today.year, today.month, today.day)
          .subtract(Duration(days: 6 - index));
    });

    List<FlSpot> spots = [];
    List<String> daysLabels = [];

    for (int i = 0; i < lastSevenDays.length; i++) {
      DateTime day = lastSevenDays[i];
      DateTime dayOnly = DateUtils.dateOnly(day);

      List<MoodEntry> entriesForDay = moodBox.values
          .where((entry) => DateUtils.isSameDay(entry.dateTime, dayOnly))
          .toList();

      if (entriesForDay.isNotEmpty) {
        entriesForDay.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        MoodEntry latestEntry = entriesForDay.last;
        double moodValue = _moodToValue(latestEntry.mood);
        spots.add(FlSpot(i.toDouble(), moodValue));
      } else {
        spots.add(FlSpot(i.toDouble(), 0));
      }

      String dayLabel = DateFormat.E().format(day);
      daysLabels.add(dayLabel);
    }

    setState(() {
      moodSpots = spots;
      weekDays = daysLabels;
    });
  }

  double _moodToValue(String mood) {
    switch (mood) {
      case 'BAD':
        return 1;
      case 'NOT BAD':
        return 2;
      case 'GOOD':
        return 3;
      case 'AMAZING':
        return 4;
      default:
        return 0;
    }
  }

  String _getImageForMood(String mood) {
    switch (mood) {
      case 'AMAZING':
        return 'assets/images/Amazing.png';
      case 'GOOD':
        return 'assets/images/Good.png';
      case 'NOT BAD':
        return 'assets/images/Not bad.png';
      case 'BAD':
        return 'assets/images/Bad.png';
      default:
        return 'assets/images/Feel_not selected.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsPage()));
                    },
                    minSize: 1,
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.surface,
                        image: const DecorationImage(
                          image: AssetImage('assets/images/Ellipse 13.png'),
                        ),
                        border: Border.all(
                          color: const Color.fromRGBO(45, 45, 51, 1),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ActionHistoryPage(),
                        ),
                      );
                    },
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.surface,
                        border: Border.all(
                          color: const Color.fromRGBO(45, 45, 51, 1),
                        ),
                      ),
                      child: const Icon(
                        Icons.notifications,
                        color: AppTheme.onSurface,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                "Watch the progress on",
                style: AppTheme.bodyLarge
                    .copyWith(color: const Color.fromARGB(78, 252, 248, 239)),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "EMOTION\nGRAPH",
                style: AppTheme.displayLarge
                    .copyWith(color: AppTheme.onBackground),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(20)),
                child: moodSpots.isEmpty
                    ? const Center(child: Text('No mood data available'))
                    : AspectRatio(
                        aspectRatio: 1.50,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: true,
                              horizontalInterval: 1,
                              verticalInterval: 1,
                              getDrawingHorizontalLine: (value) {
                                return const FlLine(
                                  color: AppTheme.surface,
                                  strokeWidth: 1,
                                );
                              },
                              getDrawingVerticalLine: (value) {
                                return const FlLine(
                                  color: AppTheme.surface,
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  interval: 1,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    int index = value.toInt();
                                    if (index >= 0 && index < weekDays.length) {
                                      return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        child: Text(
                                          weekDays[index],
                                          style: AppTheme.bodyMedium.copyWith(
                                              color: const Color.fromARGB(
                                                  125, 243, 239, 230)),
                                        ),
                                      );
                                    } else {
                                      return const Text('');
                                    }
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  reservedSize: 70,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    String label;
                                    switch (value.toInt()) {
                                      case 1:
                                        label = 'Bad';
                                        break;
                                      case 2:
                                        label = 'Not Bad';
                                        break;
                                      case 3:
                                        label = 'Good';
                                        break;
                                      case 4:
                                        label = 'Amazing';
                                        break;
                                      default:
                                        return Container();
                                    }
                                    return Text(
                                      label,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border:
                                  Border.all(color: const Color(0xff37434d)),
                            ),
                            minX: 0,
                            maxX: 6,
                            minY: 0,
                            maxY: 5,
                            lineBarsData: [
                              LineChartBarData(
                                spots: moodSpots,
                                isCurved: true,
                                gradient: LinearGradient(
                                  colors: gradientColors,
                                ),
                                barWidth: 4,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter:
                                      (spot, percent, barData, index) =>
                                          FlDotCirclePainter(
                                    radius: 4,
                                    color: _valueToColor(spot.y),
                                  ),
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: gradientColors
                                        .map((color) => color.withOpacity(0.3))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _valueToColor(double value) {
    switch (value.toInt()) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.purple;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
