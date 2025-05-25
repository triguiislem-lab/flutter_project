import 'package:flutter/material.dart';
import 'package:project_application/screens/about_screen.dart';
import 'package:project_application/screens/leaderboard_screen.dart';
import 'package:project_application/screens/quiz_options_screen.dart';
import 'package:project_application/screens/settings_screen.dart';
import 'package:project_application/services/sound_service.dart';
import 'package:project_application/services/vibration_service.dart';
import 'package:project_application/utils/constants.dart';
import 'package:project_application/utils/localization.dart';
import 'package:project_application/widgets/app_navigation_drawer.dart';

class HomeScreen extends StatelessWidget {
  final SoundService _soundService = SoundService();
  final VibrationService _vibrationService = VibrationService();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // Services are now automatically synced via SettingsProvider

    return Scaffold(
      appBar: AppBar(title: Text(localizations.get('appName'))),
      drawer: AppNavigationDrawer(currentRoute: 'home'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                  child: Image.asset(
                    'assets/images/Quiz-logo.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to icon if image fails to load
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(
                            AppConstants.borderRadius,
                          ),
                        ),
                        child: const Icon(
                          Icons.quiz,
                          size: 60,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.largePadding),

              // App name
              Text(
                localizations.get('appName'),
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.largePadding * 2),

              // Start Quiz button
              _buildMenuButton(
                context,
                localizations.get('startQuiz'),
                Icons.play_arrow,
                () {
                  _soundService.playClickSound();
                  _vibrationService.vibrateOnTap();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuizOptionsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppConstants.defaultPadding),

              // Leaderboard button
              _buildMenuButton(
                context,
                localizations.get('leaderboard'),
                Icons.leaderboard,
                () {
                  _soundService.playClickSound();
                  _vibrationService.vibrateOnTap();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeaderboardScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppConstants.defaultPadding),

              // Settings button
              _buildMenuButton(
                context,
                localizations.get('settings'),
                Icons.settings,
                () {
                  _soundService.playClickSound();
                  _vibrationService.vibrateOnTap();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
              const SizedBox(height: AppConstants.defaultPadding),

              // About button
              _buildMenuButton(
                context,
                localizations.get('about'),
                Icons.info,
                () {
                  _soundService.playClickSound();
                  _vibrationService.vibrateOnTap();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: AppConstants.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
