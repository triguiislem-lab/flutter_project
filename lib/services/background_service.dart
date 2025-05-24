import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:project_application/services/api_service.dart';
import 'package:project_application/services/notification_service.dart';

/// Service pour gérer les tâches en arrière-plan
/// 
/// Fonctionnalités :
/// - Vérification périodique de nouveaux contenus
/// - Programmation automatique des notifications
/// - Gestion des rappels utilisateur
class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();
  factory BackgroundService() => _instance;
  BackgroundService._internal();

  final ApiService _apiService = ApiService();
  final NotificationService _notificationService = NotificationService();
  
  Timer? _contentCheckTimer;
  bool _isRunning = false;

  /// Démarre les services en arrière-plan
  Future<void> start() async {
    if (_isRunning) return;

    _isRunning = true;

    if (kDebugMode) {
      print('Démarrage des services en arrière-plan');
    }

    // Programmer les notifications par défaut
    await _notificationService.scheduleDefaultNotifications();

    // Démarrer la vérification périodique de nouveaux contenus
    _startContentCheck();
  }

  /// Arrête les services en arrière-plan
  void stop() {
    if (!_isRunning) return;

    _isRunning = false;
    _contentCheckTimer?.cancel();
    _contentCheckTimer = null;

    if (kDebugMode) {
      print('Arrêt des services en arrière-plan');
    }
  }

  /// Démarre la vérification périodique de nouveaux contenus
  void _startContentCheck() {
    // Vérifier toutes les 6 heures
    _contentCheckTimer = Timer.periodic(
      const Duration(hours: 6),
      (timer) async {
        await _checkForNewContent();
      },
    );

    // Première vérification après 1 minute
    Timer(const Duration(minutes: 1), () async {
      await _checkForNewContent();
    });
  }

  /// Vérifie s'il y a de nouveaux contenus
  Future<void> _checkForNewContent() async {
    try {
      if (kDebugMode) {
        print('Vérification de nouveaux contenus...');
      }

      await _apiService.checkForNewContent();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la vérification de contenus: $e');
      }
    }
  }

  /// Force une vérification immédiate de nouveaux contenus
  Future<void> forceContentCheck() async {
    await _checkForNewContent();
  }

  /// Reprogramme les notifications
  Future<void> rescheduleNotifications() async {
    await _notificationService.scheduleDefaultNotifications();
    
    if (kDebugMode) {
      print('Notifications reprogrammées');
    }
  }

  /// Envoie une notification de test
  Future<void> sendTestNotification() async {
    await _notificationService.showNewQuizNotification(
      category: 'Test',
      questionCount: 10,
    );
  }

  /// Vérifie le statut du service
  bool get isRunning => _isRunning;

  /// Obtient les statistiques du service
  Map<String, dynamic> getStats() {
    return {
      'isRunning': _isRunning,
      'hasContentTimer': _contentCheckTimer != null,
      'nextContentCheck': _contentCheckTimer?.isActive == true 
          ? 'Dans ${6 - (DateTime.now().hour % 6)} heures'
          : 'Arrêté',
    };
  }
}
