# 🧠 QCM App - Interactive Quiz Application

A comprehensive Flutter mobile app for multiple-choice quizzes using the Open Trivia Database API.

## ✨ Key Features

- **Customizable Quizzes**: Multiple categories, difficulty levels, and question counts
- **Smart Notifications**: Daily reminders and motivational messages
- **Multilingual Support**: French, English, and Arabic (RTL)
- **Audio & Haptics**: Sound effects and vibration feedback
- **Themes**: Dark and light modes
- **Local Storage**: Score history and settings persistence

## 🛠️ Installation & Setup

### Prerequisites
- Flutter SDK (3.0+)
- Android Studio / VS Code
- Android/iOS emulator or physical device

### Quick Start
```bash
# Clone the repository
git clone [repository-url]
cd project_application

# Install dependencies
flutter pub get

# Run the application
flutter run
```

### Assets Configuration
- **Sounds**: Add MP3 files to `assets/sounds/` (click.mp3, correct.mp3, wrong.mp3, completed.mp3)
- **Logo**: Located at `assets/images/Quiz-logo.jpg`

## 🏗️ Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
├── providers/                   # State management (Provider pattern)
├── screens/                     # UI screens
├── services/                    # Business logic services
├── widgets/                     # Reusable components
└── utils/                       # Utilities and constants
```

### Key Services
- **ApiService**: Open Trivia Database communication
- **NotificationService**: Local notifications management
- **SoundService**: Audio effects handling
- **StorageService**: Local data persistence

## 🎮 Usage

### Basic Workflow
1. **Start Quiz** → Select category, difficulty, and question count
2. **Play** → Answer questions within 30-second timer
3. **Results** → View score and statistics
4. **Settings** → Customize themes, language, sounds, and notifications

### Notification System
- **Daily Reminders**: 7 PM notifications to encourage regular play
- **Quiz Completion**: Personalized messages based on performance
- **Simple Toggle**: Easy enable/disable in settings

## 📱 Platform Support

- **Android**: Full notifications, vibrations, and sounds
- **iOS**: Native notifications with permissions and haptic feedback
- **Web**: Responsive interface with limited notification support (no vibration)

## 🔧 Dependencies

```yaml
dependencies:
  provider: ^6.1.1                    # State management
  http: ^1.2.0                        # API requests
  shared_preferences: ^2.2.2          # Local storage
  flutter_local_notifications: ^17.2.2 # Notifications
  audioplayers: ^5.2.1               # Sound effects
  vibration: ^1.8.4                  # Haptic feedback
  timezone: ^0.9.4                   # Timezone handling
  permission_handler: ^11.3.1        # Permissions
```

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the project
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- **Open Trivia Database** for the quiz API
- **Flutter Team** for the framework
- **Flutter Community** for the packages used

---

**Developed with ❤️ in Flutter**
