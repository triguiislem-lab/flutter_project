import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_application/providers/settings_provider.dart';
import 'package:project_application/screens/about_screen.dart';
import 'package:project_application/screens/home_screen.dart';
import 'package:project_application/screens/leaderboard_screen.dart';
import 'package:project_application/screens/quiz_options_screen.dart';
import 'package:project_application/screens/settings_screen.dart';
import 'package:project_application/screens/simple_notification_settings_screen.dart';
import 'package:project_application/services/sound_service.dart';
import 'package:project_application/services/vibration_service.dart';
import 'package:project_application/utils/constants.dart';
import 'package:project_application/utils/localization.dart';

class AppNavigationDrawer extends StatelessWidget {
  final String? currentRoute;
  final SoundService _soundService = SoundService();
  final VibrationService _vibrationService = VibrationService();

  AppNavigationDrawer({super.key, this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          _buildDrawerHeader(context, localizations, settingsProvider),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavigationItem(
                  context,
                  localizations.get('home'),
                  Icons.home,
                  'home',
                  () => _navigateToScreen(context, HomeScreen()),
                ),
                _buildNavigationItem(
                  context,
                  localizations.get('startQuiz'),
                  Icons.play_arrow,
                  'quiz_options',
                  () => _navigateToScreen(context, const QuizOptionsScreen()),
                ),
                _buildNavigationItem(
                  context,
                  localizations.get('leaderboard'),
                  Icons.leaderboard,
                  'leaderboard',
                  () => _navigateToScreen(context, LeaderboardScreen()),
                ),
                const Divider(),
                _buildNavigationItem(
                  context,
                  localizations.get('settings'),
                  Icons.settings,
                  'settings',
                  () => _navigateToScreen(context, SettingsScreen()),
                ),
                _buildNavigationItem(
                  context,
                  localizations.get('notifications'),
                  Icons.notifications,
                  'notifications',
                  () => _navigateToScreen(
                    context,
                    SimpleNotificationSettingsScreen(),
                  ),
                ),
                const Divider(),
                _buildNavigationItem(
                  context,
                  localizations.get('about'),
                  Icons.info,
                  'about',
                  () => _navigateToScreen(context, AboutScreen()),
                ),
              ],
            ),
          ),

          // Footer with app info
          _buildDrawerFooter(context, localizations),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(
    BuildContext context,
    AppLocalizations localizations,
    SettingsProvider settingsProvider,
  ) {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primaryContainer,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Logo
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
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
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            AppConstants.borderRadius,
                          ),
                        ),
                        child: Icon(
                          Icons.quiz,
                          size: 30,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.get('appName'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      localizations.get('appDescription'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          // Language and Theme indicators
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.language, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      settingsProvider.language.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  settingsProvider.darkMode
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context,
    String title,
    IconData icon,
    String route,
    VoidCallback onTap,
  ) {
    final isSelected = currentRoute == route;

    return ListTile(
      leading: Icon(
        icon,
        color:
            isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: TextStyle(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Theme.of(
        context,
      ).colorScheme.primaryContainer.withValues(alpha: 0.3),
      onTap: () {
        _soundService.playClickSound();
        _vibrationService.vibrateOnTap();
        Navigator.pop(context); // Close drawer
        onTap();
      },
    );
  }

  Widget _buildDrawerFooter(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Column(
        children: [
          Text(
            '${localizations.get('appName')} v1.0.0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
         
        ],
      ),
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    // Navigate to the screen, replacing current route
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
