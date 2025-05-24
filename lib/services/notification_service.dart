import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

/// Service de gestion des notifications locales pour l'application QCM
/// 
/// Fonctionnalités :
/// - Notifications de rappel quotidien
/// - Notifications de nouveaux quiz
/// - Notifications de motivation
/// - Gestion des permissions
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool _notificationsEnabled = true;

  /// Initialise le service de notifications
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialiser les fuseaux horaires
      tz.initializeTimeZones();

      // Configuration Android
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // Configuration iOS
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Configuration générale
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      // Initialiser le plugin
      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Demander les permissions
      await _requestPermissions();

      _isInitialized = true;

      if (kDebugMode) {
        print('Service de notifications initialisé avec succès');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'initialisation des notifications: $e');
      }
    }
  }

  /// Demande les permissions nécessaires
  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      // Android 13+ nécessite une permission explicite
      final status = await Permission.notification.request();
      return status.isGranted;
    } else if (Platform.isIOS) {
      // iOS gère les permissions via le plugin
      final bool? result = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    }
    return true;
  }

  /// Gère le tap sur une notification
  void _onNotificationTapped(NotificationResponse notificationResponse) {
    final String? payload = notificationResponse.payload;
    
    if (kDebugMode) {
      print('Notification tappée avec payload: $payload');
    }

    // Ici vous pouvez naviguer vers une page spécifique
    // selon le type de notification (payload)
  }

  /// Active ou désactive les notifications
  void setNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;
    
    if (!enabled) {
      cancelAllNotifications();
    } else {
      scheduleDefaultNotifications();
    }
  }

  /// Vérifie si les notifications sont activées
  bool get isEnabled => _notificationsEnabled;

  /// Programme les notifications par défaut
  Future<void> scheduleDefaultNotifications() async {
    if (!_notificationsEnabled || !_isInitialized) return;

    // Annuler les notifications existantes
    await cancelAllNotifications();

    // Programmer les rappels quotidiens
    await _scheduleDailyReminders();

    // Programmer les notifications de motivation
    await _scheduleMotivationalNotifications();
  }

  /// Programme des rappels quotidiens
  Future<void> _scheduleDailyReminders() async {
    const List<String> reminderMessages = [
      'Prêt pour un nouveau défi QCM ? 🧠',
      'Il est temps de tester vos connaissances ! 📚',
      'Votre cerveau a besoin d\'exercice ! 💪',
      'Quelques questions pour commencer la journée ? ☀️',
      'Maintenez votre niveau avec un quiz rapide ! 🎯',
    ];

    // Programmer pour 19h chaque jour
    for (int i = 0; i < 7; i++) {
      final scheduledDate = _nextInstanceOfTime(19, 0).add(Duration(days: i));
      final message = reminderMessages[i % reminderMessages.length];

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        100 + i, // ID unique
        'QCM App - Rappel quotidien',
        message,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminder',
            'Rappels quotidiens',
            channelDescription: 'Notifications de rappel pour jouer quotidiennement',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            categoryIdentifier: 'daily_reminder',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'daily_reminder',
      );
    }
  }

  /// Programme des notifications de motivation
  Future<void> _scheduleMotivationalNotifications() async {
    const List<String> motivationalMessages = [
      'Félicitations ! Continuez sur cette lancée ! 🌟',
      'Votre progression est impressionnante ! 📈',
      'Nouveau record personnel à battre ? 🏆',
      'Défiez-vous avec une catégorie difficile ! 🎲',
      'Partagez vos scores avec vos amis ! 👥',
    ];

    // Programmer des notifications aléaoires
    final random = Random();
    for (int i = 0; i < 5; i++) {
      final daysFromNow = random.nextInt(7) + 1;
      final hour = random.nextInt(12) + 9; // Entre 9h et 21h
      final minute = random.nextInt(60);

      final scheduledDate = DateTime.now()
          .add(Duration(days: daysFromNow))
          .copyWith(hour: hour, minute: minute, second: 0, microsecond: 0);

      final message = motivationalMessages[i];

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        200 + i, // ID unique
        'QCM App - Motivation',
        message,
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'motivation',
            'Notifications de motivation',
            channelDescription: 'Messages motivationnels pour encourager l\'utilisation',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            categoryIdentifier: 'motivation',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'motivation',
      );
    }
  }

  /// Calcule la prochaine occurrence d'une heure donnée
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    return scheduledDate;
  }

  /// Envoie une notification immédiate pour les nouveaux quiz
  Future<void> showNewQuizNotification({
    required String category,
    required int questionCount,
  }) async {
    if (!_notificationsEnabled || !_isInitialized) return;

    await _flutterLocalNotificationsPlugin.show(
      300, // ID unique
      'Nouveaux quiz disponibles ! 🎉',
      'Découvrez $questionCount nouvelles questions dans la catégorie $category',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'new_content',
          'Nouveau contenu',
          channelDescription: 'Notifications pour les nouveaux quiz et catégories',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          categoryIdentifier: 'new_content',
        ),
      ),
      payload: 'new_quiz:$category',
    );
  }

  /// Envoie une notification de félicitations pour un bon score
  Future<void> showCongratulationsNotification({
    required int score,
    required int totalQuestions,
  }) async {
    if (!_notificationsEnabled || !_isInitialized) return;

    final percentage = (score / totalQuestions * 100).round();
    String message;
    
    if (percentage >= 90) {
      message = 'Excellent ! $score/$totalQuestions - Vous êtes un expert ! 🏆';
    } else if (percentage >= 70) {
      message = 'Très bien ! $score/$totalQuestions - Beau travail ! 👏';
    } else {
      message = 'Bon effort ! $score/$totalQuestions - Continuez à vous améliorer ! 💪';
    }

    await _flutterLocalNotificationsPlugin.show(
      400, // ID unique
      'Résultat du quiz',
      message,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'quiz_results',
          'Résultats de quiz',
          channelDescription: 'Notifications pour les résultats de quiz',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          categoryIdentifier: 'quiz_results',
        ),
      ),
      payload: 'quiz_result:$score:$totalQuestions',
    );
  }

  /// Annule toutes les notifications programmées
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Annule une notification spécifique
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Obtient les notifications en attente
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }
}
