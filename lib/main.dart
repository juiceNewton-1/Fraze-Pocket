import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fraze_pocket/onboarding_view/initial_page.dart';
import 'package:fraze_pocket/service/flagsmith_service.dart';
import 'package:fraze_pocket/service/service_locator.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fraze_pocket/models/mood_entry.dart';
import 'package:fraze_pocket/provider/affirmation_provider.dart';

void main() async {
  final splashBindings = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: splashBindings);
  await ServiceLocator.setup();
  await Hive.initFlutter();
  Hive.registerAdapter(MoodEntryAdapter());
  await Hive.openBox('settings');
  await Hive.openBox<MoodEntry>('moodBox');
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  WidgetsBinding.instance.addObserver(
    AppLifecycleListener(
        onDetach: GetIt.instance<FlagSmithService>().closeClient),
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => AffirmationProvider(),
      child: AppInfo(
        data: await AppInfoData.get(),
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fraze Pocket',
      theme: ThemeData(
        fontFamily: 'Onest',
      ),
      debugShowCheckedModeBanner: false,
      home: const InitialScreen(),
    );
  }
}
