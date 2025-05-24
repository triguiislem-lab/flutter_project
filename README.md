# 🧠 QCM App - Application de Quiz Interactive

Une application mobile Flutter complète pour les quiz à choix multiples (QCM) avec de nombreuses fonctionnalités avancées.

## 📱 Aperçu de l'Application

QCM App est une application de quiz interactive qui utilise l'API Open Trivia Database pour fournir une expérience de quiz personnalisable avec :
- Quiz personnalisables par catégorie et difficulté
- Système de notifications intelligent
- Support multilingue (Français, Anglais, Arabe)
- Effets sonores et vibrations
- Thèmes sombre/clair
- Historique des scores locaux

## 🚀 Fonctionnalités Principales

### 🎯 **Système de Quiz**
- **Catégories variées** : Science, Histoire, Sport, Divertissement, etc.
- **Niveaux de difficulté** : Facile, Moyen, Difficile
- **Types de questions** : Choix multiples, Vrai/Faux
- **Nombre de questions** : 5, 10, 15, ou 20 questions par quiz
- **Timer** : 30 secondes par question
- **Scores en temps réel** : Suivi des bonnes/mauvaises réponses

### 🔔 **Système de Notifications**
- **Rappels quotidiens** : Notifications à 19h pour encourager l'utilisation
- **Messages motivationnels** : Notifications aléatoires d'encouragement
- **Nouveaux contenus** : Alertes pour nouveaux quiz disponibles
- **Félicitations** : Messages personnalisés selon les scores obtenus
- **Contrôle utilisateur** : Activation/désactivation complète

### 🎨 **Interface Utilisateur**
- **Design Material** : Interface moderne et intuitive
- **Thèmes** : Mode sombre et clair
- **Responsive** : Adaptation à toutes les tailles d'écran
- **Animations fluides** : Transitions et effets visuels
- **Accessibilité** : Support des lecteurs d'écran

### 🔊 **Expérience Multimédia**
- **Effets sonores** : Sons pour clics, bonnes/mauvaises réponses, completion
- **Vibrations** : Retour haptique sur les interactions
- **Logo personnalisé** : Branding de l'application

### 🌍 **Support Multilingue**
- **Français** : Langue principale
- **Anglais** : Support international
- **Arabe** : Support RTL (Right-to-Left)
- **Changement dynamique** : Basculement en temps réel

### 💾 **Persistance des Données**
- **Scores locaux** : Historique des résultats
- **Paramètres** : Sauvegarde des préférences
- **Leaderboard** : Classement personnel

## 🏗️ Architecture du Code

### 📁 Structure des Dossiers

```
lib/
├── main.dart                    # Point d'entrée de l'application
├── models/                      # Modèles de données
│   ├── question.dart           # Modèle des questions de quiz
│   ├── category.dart           # Modèle des catégories
│   ├── quiz_options.dart       # Options de configuration du quiz
│   └── quiz_result.dart        # Résultats des quiz
├── providers/                   # Gestion d'état (Provider pattern)
│   ├── quiz_provider.dart      # État et logique des quiz
│   └── settings_provider.dart  # Paramètres de l'application
├── screens/                     # Écrans de l'interface utilisateur
│   ├── home_screen.dart        # Écran d'accueil principal
│   ├── quiz_options_screen.dart # Configuration des quiz
│   ├── quiz_screen.dart        # Interface de jeu
│   ├── results_screen.dart     # Affichage des résultats
│   ├── leaderboard_screen.dart # Historique des scores
│   ├── settings_screen.dart    # Paramètres généraux
│   ├── notification_settings_screen.dart # Gestion des notifications
│   └── about_screen.dart       # Informations sur l'app
├── services/                    # Services métier
│   ├── api_service.dart        # Communication avec Open Trivia DB
│   ├── notification_service.dart # Gestion des notifications
│   ├── background_service.dart # Tâches en arrière-plan
│   ├── sound_service.dart      # Gestion audio
│   ├── vibration_service.dart  # Retour haptique
│   └── storage_service.dart    # Persistance locale
├── widgets/                     # Composants réutilisables
│   ├── answer_option.dart      # Boutons de réponse
│   ├── category_selector.dart  # Sélecteur de catégorie
│   ├── difficulty_selector.dart # Sélecteur de difficulté
│   ├── question_card.dart      # Affichage des questions
│   └── timer_widget.dart       # Minuteur visuel
└── utils/                       # Utilitaires et constantes
    ├── constants.dart          # Constantes de l'application
    ├── localization.dart       # Système de traduction
    └── theme.dart              # Thèmes et styles
```

### 🔧 Services Principaux

#### **ApiService** (`lib/services/api_service.dart`)
- Communication avec l'API Open Trivia Database
- Récupération des catégories et questions
- Gestion des erreurs réseau
- Simulation de nouveaux contenus

#### **NotificationService** (`lib/services/notification_service.dart`)
- Gestion complète des notifications locales
- Programmation des rappels quotidiens
- Notifications contextuelles (scores, nouveaux contenus)
- Gestion des permissions multi-plateformes

#### **BackgroundService** (`lib/services/background_service.dart`)
- Tâches périodiques en arrière-plan
- Vérification de nouveaux contenus (toutes les 6h)
- Maintenance des notifications programmées

#### **SoundService** (`lib/services/sound_service.dart`)
- Lecture des effets sonores
- Gestion gracieuse des fichiers manquants
- Support multi-plateformes (Web, Mobile)

#### **StorageService** (`lib/services/storage_service.dart`)
- Persistance des données avec SharedPreferences
- Sauvegarde des scores et paramètres
- Gestion de l'historique des quiz

### 🎮 Providers (Gestion d'État)

#### **QuizProvider** (`lib/providers/quiz_provider.dart`)
```dart
class QuizProvider extends ChangeNotifier {
  // État du quiz (questions, score, timer)
  // Logique de jeu (réponses, progression)
  // Communication avec l'API
  // Notifications de fin de quiz
}
```

#### **SettingsProvider** (`lib/providers/settings_provider.dart`)
```dart
class SettingsProvider extends ChangeNotifier {
  // Paramètres utilisateur (thème, langue, sons)
  // Persistance des préférences
  // Contrôle des notifications
}
```

## 🎯 Fonctionnalités Détaillées

### 📊 **Système de Quiz**

#### Flux de jeu :
1. **Sélection** → Catégorie, difficulté, nombre de questions
2. **Chargement** → Récupération des questions via API
3. **Jeu** → Questions avec timer de 30s
4. **Résultats** → Score final et statistiques
5. **Sauvegarde** → Persistance du résultat

#### Fichiers impliqués :
- `quiz_options_screen.dart` : Configuration
- `quiz_screen.dart` : Interface de jeu
- `results_screen.dart` : Affichage des résultats
- `quiz_provider.dart` : Logique métier

### 🔔 **Système de Notifications**

#### Types de notifications :
1. **Rappels quotidiens** (19h00) : "Prêt pour un nouveau défi QCM ? 🧠"
2. **Motivation** (aléatoire) : "Votre progression est impressionnante ! 📈"
3. **Nouveaux contenus** : "Nouveaux quiz disponibles ! 🎉"
4. **Félicitations** : "Excellent ! 9/10 - Vous êtes un expert ! 🏆"

#### Fichiers impliqués :
- `notification_service.dart` : Service principal
- `background_service.dart` : Tâches périodiques
- `notification_settings_screen.dart` : Interface de gestion

### 🎨 **Système de Thèmes**

#### Thèmes disponibles :
- **Clair** : Couleurs vives et contrastées
- **Sombre** : Interface adaptée à la nuit

#### Fichiers impliqués :
- `theme.dart` : Définition des thèmes
- `settings_provider.dart` : Gestion du changement

### 🌍 **Système Multilingue**

#### Langues supportées :
- **Français** : Langue par défaut
- **Anglais** : Support international
- **Arabe** : Support RTL

#### Fichiers impliqués :
- `localization.dart` : Traductions et logique
- `main.dart` : Configuration des locales

## 🛠️ Installation et Configuration

### Prérequis
- Flutter SDK (3.0+)
- Android Studio / VS Code
- Émulateur Android/iOS ou appareil physique

### Installation
```bash
# Cloner le projet
git clone [url-du-repo]
cd project_application

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run
```

### Configuration des Assets

#### Sons (optionnel)
Ajouter les fichiers MP3 dans `assets/sounds/` :
- `click.mp3` : Son de clic
- `correct.mp3` : Bonne réponse
- `wrong.mp3` : Mauvaise réponse
- `completed.mp3` : Quiz terminé

#### Logo
Le logo est dans `assets/images/Quiz-logo.jpg`

## 📱 Plateformes Supportées

### ✅ Android
- Notifications locales complètes
- Vibrations et sons
- Permissions automatiques

### ✅ iOS
- Notifications avec permissions
- Retour haptique
- Interface native

### ✅ Web
- Interface responsive
- Notifications limitées
- Sons avec interaction utilisateur

## 🔧 Dépendances Principales

```yaml
dependencies:
  flutter_localizations: # Support multilingue
  provider: ^6.1.1 # Gestion d'état
  http: ^1.2.0 # Requêtes API
  shared_preferences: ^2.2.2 # Stockage local
  flutter_local_notifications: ^17.2.2 # Notifications
  audioplayers: ^5.2.1 # Sons
  vibration: ^1.8.4 # Vibrations
  timezone: ^0.9.4 # Gestion des fuseaux horaires
  permission_handler: ^11.3.1 # Permissions
```

## 🎯 Utilisation

### Démarrage rapide
1. **Lancer l'app** → Écran d'accueil avec logo
2. **Commencer un quiz** → Bouton "Start Quiz"
3. **Configurer** → Choisir catégorie, difficulté, nombre
4. **Jouer** → Répondre aux questions dans le temps imparti
5. **Voir résultats** → Score et statistiques
6. **Paramètres** → Personnaliser l'expérience

### Gestion des notifications
1. **Paramètres** → **Notifications**
2. **Activer** les notifications
3. **Programmer** des rappels
4. **Tester** le système

### Navigation dans l'app

#### **Écran d'accueil** (`home_screen.dart`)
- Logo de l'application
- Bouton "Commencer un Quiz"
- Accès aux paramètres
- Navigation vers le leaderboard

#### **Configuration du quiz** (`quiz_options_screen.dart`)
- Sélection de catégorie (Science, Histoire, etc.)
- Choix de difficulté (Facile, Moyen, Difficile)
- Nombre de questions (5, 10, 15, 20)
- Type de questions (Choix multiples, Vrai/Faux)

#### **Interface de jeu** (`quiz_screen.dart`)
- Affichage de la question
- Options de réponse
- Timer de 30 secondes
- Progression (question X/Y)
- Score en temps réel

#### **Résultats** (`results_screen.dart`)
- Score final
- Pourcentage de réussite
- Temps total
- Boutons : Rejouer, Accueil, Leaderboard

#### **Paramètres** (`settings_screen.dart`)
- Thème (Clair/Sombre)
- Langue (FR/EN/AR)
- Sons (Activé/Désactivé)
- Vibrations (Activé/Désactivé)
- Notifications → Écran dédié

## 🔔 Guide des Notifications

### Types de notifications et leur timing

#### **📅 Rappels Quotidiens**
- **Heure** : 19h00 chaque jour
- **Fréquence** : Quotidienne
- **Messages** : 5 messages rotatifs
- **Exemple** : "Prêt pour un nouveau défi QCM ? 🧠"

#### **🎉 Motivation**
- **Timing** : Aléatoire entre 9h-21h
- **Fréquence** : 5 notifications sur 7 jours
- **Messages** : Encouragements personnalisés
- **Exemple** : "Votre progression est impressionnante ! 📈"

#### **🆕 Nouveaux Contenus**
- **Vérification** : Toutes les 6 heures
- **Probabilité** : 30% de nouveau contenu
- **Déclencheur** : Service en arrière-plan
- **Exemple** : "Nouveaux quiz disponibles ! 🎉"

#### **🏆 Félicitations**
- **Timing** : Immédiat après quiz
- **Condition** : Score obtenu
- **Messages** : Basés sur le pourcentage
- **Exemples** :
  - 90%+ : "Excellent ! Vous êtes un expert ! 🏆"
  - 70%+ : "Très bien ! Beau travail ! 👏"
  - <70% : "Bon effort ! Continuez à vous améliorer ! 💪"

### Configuration des notifications

#### **Activation/Désactivation**
```dart
// Dans SettingsProvider
void toggleNotifications() {
  _notificationsEnabled = !_notificationsEnabled;
  _notificationService.setNotificationsEnabled(_notificationsEnabled);
}
```

#### **Programmation manuelle**
```dart
// Programmer des rappels quotidiens
await _notificationService.scheduleDefaultNotifications();
```

#### **Test des notifications**
```dart
// Envoyer une notification de test
await _notificationService.showNewQuizNotification(
  category: 'Test',
  questionCount: 10,
);
```

## 🤝 Contribution

Ce projet est ouvert aux contributions ! N'hésitez pas à :

### Comment contribuer
1. **Fork** le projet
2. **Créer** une branche pour votre fonctionnalité
3. **Commiter** vos changements
4. **Pousser** vers la branche
5. **Ouvrir** une Pull Request

### Types de contributions
- 🐛 **Signaler des bugs**
- ✨ **Proposer de nouvelles fonctionnalités**
- 📚 **Améliorer la documentation**
- 🌍 **Ajouter des traductions**
- 🎨 **Améliorer l'interface**
- 🔧 **Optimiser les performances**

### Guidelines
- Suivre les conventions de code Flutter
- Ajouter des tests pour les nouvelles fonctionnalités
- Mettre à jour la documentation
- Respecter l'architecture existante

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.

## 🙏 Remerciements

- **Open Trivia Database** : Pour l'API des questions
- **Flutter Team** : Pour le framework
- **Communauté Flutter** : Pour les packages utilisés

---

**Développé avec ❤️ en Flutter**

*QCM App - Testez vos connaissances, défiez votre esprit !*
