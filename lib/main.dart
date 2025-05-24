import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:project_application/providers/quiz_provider.dart';
import 'package:project_application/providers/settings_provider.dart';
import 'package:project_application/screens/home_screen.dart';
import 'package:project_application/services/vibration_service.dart';
import 'package:project_application/utils/constants.dart';
import 'package:project_application/utils/localization.dart';
import 'package:project_application/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize vibration service
  final vibrationService = VibrationService();
  await vibrationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: const AppWithSettings(),
    );
  }
}

class AppWithSettings extends StatefulWidget {
  const AppWithSettings({super.key});

  @override
  State<AppWithSettings> createState() => _AppWithSettingsState();
}

class _AppWithSettingsState extends State<AppWithSettings> {
  @override
  void initState() {
    super.initState();
    // Load settings when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SettingsProvider>(context, listen: false).loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      title: 'Quiz App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settingsProvider.darkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,

      // Localization setup
      locale: Locale(settingsProvider.language),
      supportedLocales: AppConstants.supportedLocales,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
