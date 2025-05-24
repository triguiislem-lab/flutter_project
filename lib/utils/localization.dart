import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = {
    'en': {
      // General
      'appName': 'Quiz App',
      'ok': 'OK',
      'cancel': 'Cancel',
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
      'next': 'Next',
      'previous': 'Previous',
      'submit': 'Submit',
      'back': 'Back',
      
      // Home Screen
      'startQuiz': 'Start Quiz',
      'leaderboard': 'Leaderboard',
      'settings': 'Settings',
      'about': 'About',
      
      // Quiz Options Screen
      'quizOptions': 'Quiz Options',
      'category': 'Category',
      'difficulty': 'Difficulty',
      'numberOfQuestions': 'Number of Questions',
      'questionType': 'Question Type',
      'any': 'Any',
      'easy': 'Easy',
      'medium': 'Medium',
      'hard': 'Hard',
      'multiple': 'Multiple Choice',
      'boolean': 'True/False',
      
      // Quiz Screen
      'question': 'Question',
      'timeLeft': 'Time Left',
      'seconds': 'seconds',
      'correctAnswer': 'Correct Answer',
      'wrongAnswer': 'Wrong Answer',
      'true': 'True',
      'false': 'False',
      
      // Results Screen
      'quizResults': 'Quiz Results',
      'score': 'Score',
      'totalQuestions': 'Total Questions',
      'correctAnswers': 'Correct Answers',
      'accuracy': 'Accuracy',
      'playAgain': 'Play Again',
      'returnToHome': 'Return to Home',
      'viewAnswers': 'View Answers',
      
      // Leaderboard Screen
      'noScores': 'No scores yet',
      'date': 'Date',
      'clearScores': 'Clear Scores',
      'confirmClear': 'Are you sure you want to clear all scores?',
      
      // Settings Screen
      'darkMode': 'Dark Mode',
      'sound': 'Sound',
      'vibration': 'Vibration',
      'language': 'Language',
      'notifications': 'Notifications',
      'english': 'English',
      'french': 'French',
      'arabic': 'Arabic',
      
      // About Screen
      'aboutApp': 'About App',
      'version': 'Version',
      'poweredBy': 'Powered by Open Trivia Database',
      'visitWebsite': 'Visit Website',
    },
    'fr': {
      // General
      'appName': 'Application Quiz',
      'ok': 'OK',
      'cancel': 'Annuler',
      'loading': 'Chargement...',
      'error': 'Erreur',
      'retry': 'Réessayer',
      'next': 'Suivant',
      'previous': 'Précédent',
      'submit': 'Soumettre',
      'back': 'Retour',
      
      // Home Screen
      'startQuiz': 'Commencer le Quiz',
      'leaderboard': 'Classement',
      'settings': 'Paramètres',
      'about': 'À propos',
      
      // Quiz Options Screen
      'quizOptions': 'Options du Quiz',
      'category': 'Catégorie',
      'difficulty': 'Difficulté',
      'numberOfQuestions': 'Nombre de Questions',
      'questionType': 'Type de Question',
      'any': 'Tous',
      'easy': 'Facile',
      'medium': 'Moyen',
      'hard': 'Difficile',
      'multiple': 'Choix Multiple',
      'boolean': 'Vrai/Faux',
      
      // Quiz Screen
      'question': 'Question',
      'timeLeft': 'Temps Restant',
      'seconds': 'secondes',
      'correctAnswer': 'Bonne Réponse',
      'wrongAnswer': 'Mauvaise Réponse',
      'true': 'Vrai',
      'false': 'Faux',
      
      // Results Screen
      'quizResults': 'Résultats du Quiz',
      'score': 'Score',
      'totalQuestions': 'Total des Questions',
      'correctAnswers': 'Réponses Correctes',
      'accuracy': 'Précision',
      'playAgain': 'Rejouer',
      'returnToHome': 'Retour à l\'Accueil',
      'viewAnswers': 'Voir les Réponses',
      
      // Leaderboard Screen
      'noScores': 'Pas encore de scores',
      'date': 'Date',
      'clearScores': 'Effacer les Scores',
      'confirmClear': 'Êtes-vous sûr de vouloir effacer tous les scores?',
      
      // Settings Screen
      'darkMode': 'Mode Sombre',
      'sound': 'Son',
      'vibration': 'Vibration',
      'language': 'Langue',
      'notifications': 'Notifications',
      'english': 'Anglais',
      'french': 'Français',
      'arabic': 'Arabe',
      
      // About Screen
      'aboutApp': 'À propos de l\'Application',
      'version': 'Version',
      'poweredBy': 'Propulsé par Open Trivia Database',
      'visitWebsite': 'Visiter le Site Web',
    },
    'ar': {
      // General
      'appName': 'تطبيق الاختبار',
      'ok': 'موافق',
      'cancel': 'إلغاء',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'retry': 'إعادة المحاولة',
      'next': 'التالي',
      'previous': 'السابق',
      'submit': 'إرسال',
      'back': 'رجوع',
      
      // Home Screen
      'startQuiz': 'بدء الاختبار',
      'leaderboard': 'لوحة المتصدرين',
      'settings': 'الإعدادات',
      'about': 'حول',
      
      // Quiz Options Screen
      'quizOptions': 'خيارات الاختبار',
      'category': 'الفئة',
      'difficulty': 'الصعوبة',
      'numberOfQuestions': 'عدد الأسئلة',
      'questionType': 'نوع السؤال',
      'any': 'أي',
      'easy': 'سهل',
      'medium': 'متوسط',
      'hard': 'صعب',
      'multiple': 'اختيار متعدد',
      'boolean': 'صح/خطأ',
      
      // Quiz Screen
      'question': 'سؤال',
      'timeLeft': 'الوقت المتبقي',
      'seconds': 'ثواني',
      'correctAnswer': 'إجابة صحيحة',
      'wrongAnswer': 'إجابة خاطئة',
      'true': 'صحيح',
      'false': 'خطأ',
      
      // Results Screen
      'quizResults': 'نتائج الاختبار',
      'score': 'النتيجة',
      'totalQuestions': 'إجمالي الأسئلة',
      'correctAnswers': 'الإجابات الصحيحة',
      'accuracy': 'الدقة',
      'playAgain': 'العب مرة أخرى',
      'returnToHome': 'العودة إلى الرئيسية',
      'viewAnswers': 'عرض الإجابات',
      
      // Leaderboard Screen
      'noScores': 'لا توجد نتائج بعد',
      'date': 'التاريخ',
      'clearScores': 'مسح النتائج',
      'confirmClear': 'هل أنت متأكد من رغبتك في مسح جميع النتائج؟',
      
      // Settings Screen
      'darkMode': 'الوضع المظلم',
      'sound': 'الصوت',
      'vibration': 'الاهتزاز',
      'language': 'اللغة',
      'notifications': 'الإشعارات',
      'english': 'الإنجليزية',
      'french': 'الفرنسية',
      'arabic': 'العربية',
      
      // About Screen
      'aboutApp': 'حول التطبيق',
      'version': 'الإصدار',
      'poweredBy': 'مدعوم بواسطة Open Trivia Database',
      'visitWebsite': 'زيارة الموقع',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? _localizedValues['en']![key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
