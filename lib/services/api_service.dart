import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_application/models/category.dart';
import 'package:project_application/models/question.dart';
import 'package:project_application/models/quiz_options.dart';
import 'package:project_application/services/notification_service.dart';

class ApiService {
  static const String _baseUrl = 'https://opentdb.com/api.php';
  static const String _categoriesUrl = 'https://opentdb.com/api_category.php';

  final NotificationService _notificationService = NotificationService();

  // Fetch categories from the API
  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(Uri.parse(_categoriesUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final categoriesList = data['trivia_categories'] as List;
        return categoriesList
            .map((category) => Category.fromJson(category))
            .toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Fetch questions from the API based on quiz options
  Future<List<Question>> getQuestions(QuizOptions options) async {
    try {
      // Build the URL with query parameters
      final queryParams = <String, String>{
        'amount': options.numberOfQuestions.toString(),
      };

      if (options.categoryId != null) {
        queryParams['category'] = options.categoryId.toString();
      }

      if (options.difficulty != 'any') {
        queryParams['difficulty'] = options.difficulty;
      }

      if (options.type != 'any') {
        queryParams['type'] = options.type;
      }

      final uri = Uri.parse(_baseUrl).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['response_code'] == 0) {
          final questionsList = data['results'] as List;
          return questionsList
              .map((question) => Question.fromJson(question))
              .toList();
        } else {
          throw Exception('API returned error code: ${data['response_code']}');
        }
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }

  /// Simule la vérification de nouveaux contenus
  /// Dans une vraie application, ceci interrogerait un serveur backend
  Future<void> checkForNewContent() async {
    try {
      // Simulation : vérifier s'il y a de nouveaux quiz
      // Dans la réalité, ceci ferait un appel API vers votre backend

      // Pour la démo, on simule parfois de nouveaux contenus
      final random = DateTime.now().millisecondsSinceEpoch % 10;

      if (random < 3) {
        // 30% de chance d'avoir du nouveau contenu
        final categories = await getCategories();
        if (categories.isNotEmpty) {
          final randomCategory = categories[random % categories.length];

          // Envoyer une notification de nouveau contenu
          await _notificationService.showNewQuizNotification(
            category: randomCategory.name,
            questionCount: 15 + (random * 5), // Entre 15 et 35 questions
          );
        }
      }
    } catch (e) {
      // Ignorer les erreurs silencieusement pour cette fonctionnalité
      print('Erreur lors de la vérification de nouveaux contenus: $e');
    }
  }
}
