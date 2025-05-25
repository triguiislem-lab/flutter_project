import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

/// Simple notification service for QCM App
///
/// Features:
/// - Daily reminders at 7 PM
/// - Quiz completion notifications
/// - Simple enable/disable toggle
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool _notificationsEnabled = true;

  /// Initialize notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize timezones
      tz.initializeTimeZones();

      // Create notification channels for Android
      await _createNotificationChannels();

      // Android configuration
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      
      

      // General configuration
      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
          
          );

      // Initialize plugin
      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Request permissions
      await _requestPermissions();

      _isInitialized = true;

      if (kDebugMode) {
        print('Notification service initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing notifications: $e');
      }
      // Don't set _isInitialized to true if there was an error
    }
  }

  /// Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      const List<AndroidNotificationChannel> channels = [
        AndroidNotificationChannel(
          'daily_reminder',
          'Daily Reminders',
          description: 'Daily reminder notifications to play quiz',
          importance: Importance.defaultImportance,
        ),
        AndroidNotificationChannel(
          'motivation',
          'Motivational Notifications',
          description: 'Motivational messages to encourage app usage',
          importance: Importance.defaultImportance,
        ),
        AndroidNotificationChannel(
          'new_content',
          'New Content',
          description: 'Notifications for new quizzes and categories',
          importance: Importance.high,
        ),
        AndroidNotificationChannel(
          'quiz_results',
          'Quiz Results',
          description: 'Notifications for quiz results',
          importance: Importance.defaultImportance,
        ),
        AndroidNotificationChannel(
          'test_notifications',
          'Test Notifications',
          description: 'Test notifications',
          importance: Importance.high,
        ),
        AndroidNotificationChannel(
          'instant_notifications',
          'Instant Notifications',
          description: 'Immediate notifications',
          importance: Importance.high,
        ),
      ];

      for (final channel in channels) {
        await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.createNotificationChannel(channel);
      }
    }
  }

  /// Request necessary permissions
  Future<bool> _requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        // Check if permission is already granted
        final currentStatus = await Permission.notification.status;
        if (currentStatus.isGranted) {
          return true;
        }

        // Request permission for Android 13+
        final status = await Permission.notification.request();

        if (kDebugMode) {
          print('Notification permission status: $status');
        }

        return status.isGranted;
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting notification permissions: $e');
      }
      return false;
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse notificationResponse) {
    final String? payload = notificationResponse.payload;

    if (kDebugMode) {
      print('Notification tapped with payload: $payload');
    }

    // Here you can navigate to a specific page
    // based on notification type (payload)
  }

  /// Enable or disable notifications
  void setNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;

    if (!enabled) {
      cancelAllNotifications();
    } else {
      scheduleDefaultNotifications();
    }
  }

  /// Check if notifications are enabled
  bool get isEnabled => _notificationsEnabled;

  /// Schedule default notifications
  Future<void> scheduleDefaultNotifications() async {
    if (!_notificationsEnabled || !_isInitialized) return;

    try {
      // Cancel existing notifications
      await cancelAllNotifications();

      // Schedule daily reminders
      await _scheduleDailyReminders();

      // Schedule motivational notifications
      await _scheduleMotivationalNotifications();

      if (kDebugMode) {
        print('Default notifications scheduled successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error scheduling default notifications: $e');
      }
    }
  }

  /// Calculate next instance of a specific time
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    try {
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      return scheduledDate;
    } catch (e) {
      if (kDebugMode) {
        print('Error calculating next instance of time: $e');
      }
      // Fallback to current time + 1 hour
      return tz.TZDateTime.now(tz.local).add(const Duration(hours: 1));
    }
  }

  /// Schedule daily reminders at 7 PM
  Future<void> _scheduleDailyReminders() async {
    try {
      const List<String> reminderMessages = [
        'Ready for a new QCM challenge? 🧠',
        'Time to test your knowledge! 📚',
        'Your brain needs exercise! 💪',
        'A few questions to start the day? ☀️',
        'Keep your level up with a quick quiz! 🎯',
      ];

      // Schedule for 7 PM each day
      for (int i = 0; i < 7; i++) {
        try {
          final scheduledDate = _nextInstanceOfTime(
            19,
            0,
          ).add(Duration(days: i));
          final message = reminderMessages[i % reminderMessages.length];

          await _flutterLocalNotificationsPlugin.zonedSchedule(
            100 + i, // Unique ID
            'QCM App - Daily Reminder',
            message,
            scheduledDate,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'daily_reminder',
                'Daily Reminders',
                channelDescription: 'Daily reminder notifications to play quiz',
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

          if (kDebugMode) {
            print('Scheduled daily reminder $i for $scheduledDate');
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error scheduling daily reminder $i: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in _scheduleDailyReminders: $e');
      }
    }
  }

  /// Schedule motivational notifications
  Future<void> _scheduleMotivationalNotifications() async {
    const List<String> motivationalMessages = [
      'Congratulations! Keep it up! 🌟',
      'Your progress is impressive! 📈',
      'New personal record to beat? 🏆',
      'Challenge yourself with a difficult category! 🎲',
      'Share your scores with friends! 👥',
    ];

    // Schedule random motivational notifications
    final random = Random();
    for (int i = 0; i < 5; i++) {
      final daysFromNow = random.nextInt(7) + 1;
      final hour = random.nextInt(12) + 9; // Between 9 AM and 9 PM
      final minute = random.nextInt(60);

      final scheduledDate = DateTime.now()
          .add(Duration(days: daysFromNow))
          .copyWith(hour: hour, minute: minute, second: 0, microsecond: 0);

      final message = motivationalMessages[i];

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        200 + i, // Unique ID
        'QCM App - Motivation',
        message,
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'motivation',
            'Motivational Notifications',
            channelDescription: 'Motivational messages to encourage app usage',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(categoryIdentifier: 'motivation'),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'motivation',
      );
    }
  }

  /// Send immediate notification for new quizzes
  Future<void> showNewQuizNotification({
    required String category,
    required int questionCount,
  }) async {
    if (!_notificationsEnabled || !_isInitialized) return;

    await _flutterLocalNotificationsPlugin.show(
      300, // Unique ID
      'New quizzes available! 🎉',
      'Discover $questionCount new questions in $category category',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'new_content',
          'New Content',
          channelDescription: 'Notifications for new quizzes and categories',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(categoryIdentifier: 'new_content'),
      ),
      payload: 'new_quiz:$category',
    );
  }

  /// Send congratulations notification for good score
  Future<void> showCongratulationsNotification({
    required int score,
    required int totalQuestions,
  }) async {
    if (!_notificationsEnabled || !_isInitialized) return;

    final percentage = (score / totalQuestions * 100).round();
    String message;

    if (percentage >= 90) {
      message = 'Excellent! $score/$totalQuestions - You are an expert! 🏆';
    } else if (percentage >= 70) {
      message = 'Very good! $score/$totalQuestions - Great work! 👏';
    } else {
      message = 'Good effort! $score/$totalQuestions - Keep improving! 💪';
    }

    await _flutterLocalNotificationsPlugin.show(
      400, // Unique ID
      'Quiz Result',
      message,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'quiz_results',
          'Quiz Results',
          channelDescription: 'Notifications for quiz results',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(categoryIdentifier: 'quiz_results'),
      ),
      payload: 'quiz_result:$score:$totalQuestions',
    );
  }

  /// Send instant notification
  Future<void> showInstantNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_notificationsEnabled || !_isInitialized) return;

    await _flutterLocalNotificationsPlugin.show(
      500, // Unique ID
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_notifications',
          'Instant Notifications',
          channelDescription: 'Immediate notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          categoryIdentifier: 'instant_notifications',
        ),
      ),
      payload: payload,
    );
  }

  /// Cancel all scheduled notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  /// Get pending notifications count
  Future<int> getPendingNotificationsCount() async {
    final pendingNotifications =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications.length;
  }

  /// Schedule daily reminder (single method for settings screen)
  Future<void> scheduleDailyReminder() async {
    if (!_notificationsEnabled || !_isInitialized) return;

    final now = DateTime.now();
    final scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      19, // 7 PM
      0,
    );

    // If it's already past 7 PM today, schedule for tomorrow
    final finalDate =
        scheduledDate.isBefore(now)
            ? scheduledDate.add(const Duration(days: 1))
            : scheduledDate;

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      999, // Special ID for manual daily reminder
      'QCM App - Daily Reminder',
      'Time for your daily quiz! 🧠',
      tz.TZDateTime.from(finalDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Daily Reminders',
          channelDescription: 'Daily reminder notifications to play quiz',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(categoryIdentifier: 'daily_reminder'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_reminder',
    );
  }

  /// Show test notification
  Future<void> showTestNotification() async {
    if (!_notificationsEnabled || !_isInitialized) return;

    await _flutterLocalNotificationsPlugin.show(
      998, // Special ID for test notification
      'QCM App - Test Notification',
      'This is a test notification! 🔔',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_notifications',
          'Test Notifications',
          channelDescription: 'Test notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          categoryIdentifier: 'test_notifications',
        ),
      ),
      payload: 'test',
    );
  }

  /// Show quiz completion notification (alias for showCongratulationsNotification)
  Future<void> showQuizCompletionNotification({
    required int score,
    required int totalQuestions,
  }) async {
    await showCongratulationsNotification(
      score: score,
      totalQuestions: totalQuestions,
    );
  }

  /// Check if notification service is properly initialized and working
  bool get isWorking => _isInitialized && _notificationsEnabled;

  /// Get notification service status for debugging
  Map<String, dynamic> getStatus() {
    return {
      'isInitialized': _isInitialized,
      'notificationsEnabled': _notificationsEnabled,
      'isWorking': isWorking,
      'platform': Platform.operatingSystem,
    };
  }

  /// Test notification functionality
  Future<bool> testNotifications() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (!_isInitialized) {
        if (kDebugMode) {
          print('Notification service failed to initialize');
        }
        return false;
      }

      // Try to show a simple test notification
      await showTestNotification();

      if (kDebugMode) {
        print('Test notification sent successfully');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Test notification failed: $e');
      }
      return false;
    }
  }
}
