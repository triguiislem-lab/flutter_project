import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:project_application/providers/settings_provider.dart';
import 'package:project_application/services/notification_service.dart';
import 'package:project_application/services/background_service.dart';
import 'package:project_application/utils/constants.dart';
import 'package:project_application/utils/localization.dart';

/// Écran de gestion des paramètres de notifications
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final NotificationService _notificationService = NotificationService();
  List<PendingNotificationRequest> _pendingNotifications = [];

  @override
  void initState() {
    super.initState();
    _loadPendingNotifications();
  }

  Future<void> _loadPendingNotifications() async {
    final notifications = await _notificationService.getPendingNotifications();
    setState(() {
      _pendingNotifications = notifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('notifications')),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          // En-tête avec description
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.notifications_active,
                        color: Theme.of(context).colorScheme.primary,
                        size: 32,
                      ),
                      const SizedBox(width: AppConstants.defaultPadding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.get('notificationPermission'),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: AppConstants.smallPadding),
                            Text(
                              localizations.get('notificationPermissionDesc'),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Paramètres de notifications
          Card(
            child: Column(
              children: [
                // Activer/Désactiver les notifications
                SwitchListTile(
                  title: Text(localizations.get('enableNotifications')),
                  subtitle: Text(
                    settingsProvider.notificationsEnabled
                        ? 'Les notifications sont activées'
                        : 'Les notifications sont désactivées',
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

                if (settingsProvider.notificationsEnabled) ...[
                  const Divider(),

                  // Bouton pour programmer les notifications
                  ListTile(
                    leading: const Icon(Icons.schedule),
                    title: Text(localizations.get('dailyReminder')),
                    subtitle: const Text('Programmer des rappels quotidiens'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      await _notificationService.scheduleDefaultNotifications();
                      _loadPendingNotifications();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Rappels quotidiens programmés'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),

                  const Divider(),

                  // Bouton pour tester les notifications
                  ListTile(
                    leading: const Icon(Icons.send),
                    title: const Text('Tester les notifications'),
                    subtitle: const Text('Envoyer une notification de test'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      await _notificationService.showNewQuizNotification(
                        category: 'Test',
                        questionCount: 10,
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notification de test envoyée'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),

                  const Divider(),

                  // Bouton pour annuler toutes les notifications
                  ListTile(
                    leading: const Icon(Icons.clear_all, color: Colors.red),
                    title: const Text('Annuler toutes les notifications'),
                    subtitle: const Text(
                      'Supprimer toutes les notifications programmées',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      await _notificationService.cancelAllNotifications();
                      _loadPendingNotifications();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Toutes les notifications ont été annulées',
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Liste des notifications en attente
          if (settingsProvider.notificationsEnabled &&
              _pendingNotifications.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifications programmées (${_pendingNotifications.length})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    ...(_pendingNotifications
                        .take(5)
                        .map(
                          (notification) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.schedule, size: 16),
                                const SizedBox(
                                  width: AppConstants.smallPadding,
                                ),
                                Expanded(
                                  child: Text(
                                    notification.title ?? 'Notification',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                                Text(
                                  'ID: ${notification.id}',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        )),
                    if (_pendingNotifications.length > 5)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '... et ${_pendingNotifications.length - 5} autres',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: AppConstants.defaultPadding),

          // Informations sur les types de notifications
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Types de notifications',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),

                  _buildNotificationTypeItem(
                    context,
                    Icons.schedule,
                    'Rappels quotidiens',
                    'Notifications pour vous encourager à jouer régulièrement',
                  ),

                  _buildNotificationTypeItem(
                    context,
                    Icons.new_releases,
                    'Nouveaux contenus',
                    'Alertes pour les nouveaux quiz et catégories',
                  ),

                  _buildNotificationTypeItem(
                    context,
                    Icons.emoji_events,
                    'Félicitations',
                    'Messages de félicitations pour vos bons scores',
                  ),

                  _buildNotificationTypeItem(
                    context,
                    Icons.psychology,
                    'Motivation',
                    'Messages motivationnels pour vous encourager',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTypeItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
