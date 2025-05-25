import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_application/providers/settings_provider.dart';
import 'package:project_application/services/notification_service.dart';
import 'package:project_application/utils/constants.dart';
import 'package:project_application/utils/localization.dart';
import 'package:project_application/widgets/app_navigation_drawer.dart';

class SimpleNotificationSettingsScreen extends StatefulWidget {
  const SimpleNotificationSettingsScreen({super.key});

  @override
  State<SimpleNotificationSettingsScreen> createState() =>
      _SimpleNotificationSettingsScreenState();
}

class _SimpleNotificationSettingsScreenState
    extends State<SimpleNotificationSettingsScreen> {
  final NotificationService _notificationService = NotificationService();
  int _pendingNotifications = 0;

  @override
  void initState() {
    super.initState();
    _loadPendingNotifications();
  }

  Future<void> _loadPendingNotifications() async {
    final count = await _notificationService.getPendingNotificationsCount();
    if (mounted) {
      setState(() {
        _pendingNotifications = count;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.get('notifications'))),
      drawer: AppNavigationDrawer(currentRoute: 'notifications'),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          // Status card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notification Status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    'Enabled: ${settingsProvider.notificationsEnabled ? "Yes" : "No"}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Pending notifications: $_pendingNotifications',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          // Enable/Disable notifications
          Card(
            child: SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: Text(
                settingsProvider.notificationsEnabled
                    ? 'Daily reminders are enabled'
                    : 'Daily reminders are disabled',
              ),
              value: settingsProvider.notificationsEnabled,
              onChanged: (value) {
                settingsProvider.toggleNotifications();
                _loadPendingNotifications();
              },
              secondary: Icon(
                settingsProvider.notificationsEnabled
                    ? Icons.notifications
                    : Icons.notifications_off,
              ),
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          // Action buttons
          if (settingsProvider.notificationsEnabled) ...[
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.schedule),
                    title: const Text('Schedule Daily Reminder'),
                    subtitle: const Text('Set daily reminder at 7 PM'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      await _notificationService.scheduleDailyReminder();
                      _loadPendingNotifications();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Daily reminder scheduled for 7 PM'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.notification_add),
                    title: const Text('Send Test Notification'),
                    subtitle: const Text('Test notification functionality'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      await _notificationService.showTestNotification();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Test notification sent'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.clear_all),
                    title: const Text('Cancel All Notifications'),
                    subtitle: const Text('Remove all pending notifications'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      await _notificationService.cancelAllNotifications();
                      _loadPendingNotifications();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('All notifications cancelled'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
          ],

          // Information card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Notifications',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  const Text(
                    '• Daily reminders are sent at 7 PM to encourage regular practice\n'
                    '• Quiz completion notifications celebrate your achievements\n'
                    '• You can enable or disable notifications anytime\n'
                    '• Test notifications help verify the system is working',
                  ),
                ],
              ),
            ),
          ),

          // Debug info (debug mode only)
          if (kDebugMode) ...[
            const SizedBox(height: AppConstants.defaultPadding),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Debug Information',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Text(
                      'Service initialized: ${_notificationService.isEnabled}',
                    ),
                    Text('Platform: ${Theme.of(context).platform}'),
                    ElevatedButton(
                      onPressed: _loadPendingNotifications,
                      child: const Text('Refresh Status'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
