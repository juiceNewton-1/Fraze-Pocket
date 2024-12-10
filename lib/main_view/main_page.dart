import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:fraze_pocket/main_view/action_history_page.dart';
import 'package:fraze_pocket/main_view/choose_feeling_bottom_sheet.dart';
import 'package:fraze_pocket/models/mood_entry.dart';
import 'package:fraze_pocket/settings_view/settings_page.dart';
import 'package:fraze_pocket/styles/app_theme.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _controller = EasyInfiniteDateTimelineController();
  DateTime _selectedDate = DateTime.now();
  final DateTime _firstDate = DateTime(2020);
  final DateTime _lastDate = DateTime(2030, 12, 31);

  String _currentMood = 'Primary';
  String _currentMoodImage = 'assets/images/Feel_not selected.png';
  String _currentMoodText = 'CHOOSE\nWHAT\nYOU FEEL';

  Map<DateTime, String> _moodByDate = {};

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _loadMoodByDate();

    // Добавляем слушатель изменений в Hive
    Hive.box<MoodEntry>('moodBox').watch().listen((event) {
      _loadMoodByDate();
    });
  }

  void _loadMoodByDate() {
    final moodBox = Hive.box<MoodEntry>('moodBox');
    final entries = moodBox.values.toList();

    // Сортируем записи по дате
    entries.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final Map<DateTime, String> moodMap = {};
    for (var entry in entries) {
      final date = DateUtils.dateOnly(entry.dateTime);
      moodMap[date] = entry.mood;
    }

    setState(() {
      _moodByDate = moodMap;

      // Обновляем текущее настроение на основе выбранной даты
      final selectedDateOnly = DateUtils.dateOnly(_selectedDate);
      if (_moodByDate.containsKey(selectedDateOnly)) {
        _currentMood = _moodByDate[selectedDateOnly]!;
        _currentMoodImage = _getImageForMood(_currentMood);
        _currentMoodText = 'YOU ARE\nFEELING\n$_currentMood';
      } else {
        _currentMood = 'Primary';
        _currentMoodImage = 'assets/images/Feel_not selected.png';
        _currentMoodText = 'CHOOSE\nWHAT\nYOU FEEL';
      }
    });
  }

  void showChooseFeelingBottomSheet(BuildContext context) async {
    final selectedMood = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: const ChooseFeelingBottomSheet(),
          ),
        );
      },
    );

    if (selectedMood != null) {
      final moodUpper = selectedMood.toUpperCase();

      setState(() {
        _currentMood = moodUpper;
        _currentMoodImage = _getImageForMood(_currentMood);
        _currentMoodText = 'YOU ARE\nFEELING\n$_currentMood';
      });

      // Сохраняем настроение в Hive
      _addMoodEntry(moodUpper);
    }
  }

  void _addMoodEntry(String mood) async {
    final moodBox = Hive.box<MoodEntry>('moodBox');

    final moodEntry = MoodEntry(
      mood: mood,
      dateTime: DateTime.now(),
      image: _getImageForMood(mood),
    );

    await moodBox.add(moodEntry);
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
    final dayProps = EasyDayProps(
      borderColor: Colors.transparent,
      width: 50,
      height: 80,
      dayStructure: DayStructure.dayStrDayNum,
      activeDayStyle: DayStyle(
        decoration: BoxDecoration(
            color: AppTheme.surface, borderRadius: BorderRadius.circular(20)),
        borderRadius: 20,
        dayNumStyle: const TextStyle(
          color: AppTheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        dayStrStyle: const TextStyle(
          color: Color.fromARGB(134, 252, 248, 239),
          fontSize: 12,
        ),
      ),
      inactiveDayStyle: const DayStyle(
        borderRadius: 20,
        dayNumStyle: TextStyle(
          color: AppTheme.onPrimary,
          fontSize: 16,
        ),
        dayStrStyle: TextStyle(
          color: Color.fromARGB(134, 252, 248, 239),
          fontSize: 12,
        ),
      ),
      disabledDayStyle: const DayStyle(
        borderRadius: 20,
        dayNumStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        dayStrStyle: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
      todayStyle: const DayStyle(
        borderRadius: 20,
        dayNumStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        dayStrStyle: TextStyle(
          color: Color.fromARGB(134, 252, 248, 239),
          fontSize: 12,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 140),
          
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
                    minSize: 1,

                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsPage()));
                    },
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
                height: 35,
              ),
              // График настроения
              Center(
                child: GradientGraphContainer(
                  gradColor1: Colors.transparent,
                  gradColor2: Colors.transparent,
                  image: _currentMoodImage,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                DateFormat('dd MMMM yyyy').format(_selectedDate),
                style: AppTheme.bodyLarge
                    .copyWith(color: const Color.fromARGB(125, 252, 248, 239)),
              ),
              const SizedBox(
                height: 20,
              ),
              // Текст настроения и кнопка добавления
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _currentMoodText,
                    style: AppTheme.displayLarge
                        .copyWith(color: AppTheme.onBackground),
                  ),
                  GestureDetector(
                    onTap: () {
                      showChooseFeelingBottomSheet(context);
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
                        Icons.add,
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
              // Таймлайн
              EasyInfiniteDateTimeLine(
                showTimelineHeader: false,
                controller: _controller,
                firstDate: _firstDate,
                focusDate: _selectedDate,
                lastDate: _lastDate,
                itemBuilder: (context, date, isSelected, onTap) {
                  final isToday = DateUtils.isSameDay(date, DateTime.now());
                  final dayOfWeek = DateFormat('E').format(date);
                  final dayOfMonth = date.day.toString();

                  // Получаем настроение для текущей даты
                  final dateWithoutTime = DateUtils.dateOnly(date);
                  final mood = _moodByDate[dateWithoutTime];

                  // Определяем цвет точки на основе настроения
                  Color dotColor;
                  if (mood != null) {
                    switch (mood) {
                      case 'AMAZING':
                        dotColor = const Color.fromARGB(255, 34, 250, 228);
                        break;
                      case 'GOOD':
                        dotColor = Colors.orange;
                        break;
                      case 'NOT BAD':
                        dotColor = Colors.purple;
                        break;
                      case 'BAD':
                        dotColor = Colors.red;
                        break;
                      default:
                        dotColor = Colors
                            .grey; // Если настроение не соответствует известным
                    }
                  } else {
                    dotColor = AppTheme.surface; // Если настроения нет
                  }

                  return GestureDetector(
                    onTap: onTap,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:
                            isSelected ? AppTheme.surface : Colors.transparent,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Обновленный контейнер с цветом настроения
                          Container(
                            height: 7,
                            width:
                                7, // Добавляем ширину для корректного отображения круга
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: dotColor,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            dayOfWeek,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color.fromARGB(134, 252, 248, 239),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            dayOfMonth,
                            style: TextStyle(
                              color: isToday ? Colors.blue : Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                onDateChange: (selectedDate) {
                  setState(() {
                    _selectedDate = selectedDate;
                    final date = DateUtils.dateOnly(selectedDate);
                    if (_moodByDate.containsKey(date)) {
                      _currentMood = _moodByDate[date]!;
                      _currentMoodImage = _getImageForMood(_currentMood);
                      _currentMoodText = 'YOU ARE\nFEELING\n$_currentMood';
                    } else {
                      _currentMood = 'Primary';
                      _currentMoodImage = 'assets/images/Feel_not selected.png';
                      _currentMoodText = 'CHOOSE\nWHAT\nYOU FEEL';
                    }
                  });
                },
                dayProps: dayProps,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GradientGraphContainer extends StatelessWidget {
  final Color gradColor1;
  final Color gradColor2;
  final String image;

  const GradientGraphContainer({
    super.key,
    required this.gradColor1,
    required this.gradColor2,
    required this.image,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.contain),
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            gradColor1,
            gradColor2,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
