import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_application/providers/settings_provider.dart';
import 'package:project_application/services/sound_service.dart';
import 'package:project_application/services/vibration_service.dart';
import 'package:project_application/utils/constants.dart';
import 'package:project_application/utils/localization.dart';

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
                _vibrationService.vibrateClick();
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
                _vibrationService.vibrateClick();
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
                  _vibrationService.vibrateClick();
                }
              },
            ),
          ),

          // Notifications toggle
          _buildSettingTile(
            context,
            title: localizations.get('notifications'),
            icon: Icons.notifications,
            trailing: Switch(
              value: settingsProvider.notificationsEnabled,
              onChanged: (value) {
                settingsProvider.toggleNotifications();
                _soundService.playClickSound();
                _vibrationService.vibrateClick();
              },
            ),
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
                  _vibrationService.vibrateClick();
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
}
