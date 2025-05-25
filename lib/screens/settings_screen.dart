import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_application/providers/settings_provider.dart';
import 'package:project_application/screens/simple_notification_settings_screen.dart';
import 'package:project_application/screens/vibration_test_screen.dart';
import 'package:project_application/services/sound_service.dart';
import 'package:project_application/services/vibration_service.dart';
import 'package:project_application/utils/constants.dart';
import 'package:project_application/utils/localization.dart';
import 'package:project_application/widgets/app_navigation_drawer.dart';

class SettingsScreen extends StatelessWidget {
  final SoundService _soundService = SoundService();
  final VibrationService _vibrationService = VibrationService();

  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.get('settings'))),
      drawer: AppNavigationDrawer(currentRoute: 'settings'),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          // Dark mode toggle
          _buildSettingTile(
            context,
            title: localizations.get('darkMode'),
            icon: Icons.dark_mode,
            trailing: Switch(
              value: settingsProvider.darkMode,
              onChanged: (value) {
                settingsProvider.toggleDarkMode();
                _soundService.playClickSound();
                _vibrationService.vibrateOnTap();
              },
            ),
          ),

          // Sound toggle
          _buildSettingTile(
            context,
            title: localizations.get('sound'),
            icon: Icons.volume_up,
            trailing: Switch(
              value: settingsProvider.soundEnabled,
              onChanged: (value) {
                settingsProvider.toggleSound();
                if (value) {
                  _soundService.playClickSound();
                }
                _vibrationService.vibrateOnTap();
              },
            ),
          ),

          // Vibration toggle
          _buildSettingTile(
            context,
            title: localizations.get('vibration'),
            icon: Icons.vibration,
            trailing: Switch(
              value: settingsProvider.vibrationEnabled,
              onChanged: (value) {
                settingsProvider.toggleVibration();
                _soundService.playClickSound();
                if (value) {
                  _vibrationService.vibrateOnTap();
                }
              },
            ),
          ),

          // Notifications settings
          _buildNavigationTile(
            context,
            title: localizations.get('notifications'),
            icon: Icons.notifications,
            subtitle:
                settingsProvider.notificationsEnabled
                    ? 'Activées'
                    : 'Désactivées',
            onTap: () {
              _soundService.playClickSound();
              _vibrationService.vibrateOnTap();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => const SimpleNotificationSettingsScreen(),
                ),
              );
            },
          ),

          // Sound & Vibration test (debug only)
          if (kDebugMode)
            _buildNavigationTile(
              context,
              title: 'Test Sound & Vibration',
              icon: Icons.vibration,
              subtitle: 'Debug audio and haptic functionality',
              onTap: () {
                _soundService.playClickSound();
                _vibrationService.vibrateOnTap();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VibrationTestScreen(),
                  ),
                );
              },
            ),

          // Language selection
          _buildSettingTile(
            context,
            title: localizations.get('language'),
            icon: Icons.language,
            trailing: DropdownButton<String>(
              value: settingsProvider.language,
              onChanged: (value) {
                if (value != null) {
                  settingsProvider.setLanguage(value);
                  _soundService.playClickSound();
                  _vibrationService.vibrateOnTap();
                }
              },
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text(localizations.get('english')),
                ),
                DropdownMenuItem(
                  value: 'fr',
                  child: Text(localizations.get('french')),
                ),
                DropdownMenuItem(
                  value: 'ar',
                  child: Text(localizations.get('arabic')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget trailing,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: trailing,
      ),
    );
  }

  Widget _buildNavigationTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
