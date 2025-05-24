import 'package:flutter/material.dart';
import 'package:project_application/utils/constants.dart';
import 'package:project_application/utils/localization.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('aboutApp')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App logo
            const Icon(
              Icons.quiz,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            
            // App name
            Text(
              localizations.get('appName'),
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.smallPadding),
            
            // App version
            Text(
              '${localizations.get('version')} 1.0.0',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppConstants.largePadding),
            
            // App description
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  children: [
                    Text(
                      'Quiz App is an interactive quiz application that allows users to test their knowledge across various categories. The app features customizable quizzes, score tracking, and multiple difficulty levels.',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    Text(
                      localizations.get('poweredBy'),
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    ElevatedButton.icon(
                      onPressed: () => _launchUrl('https://opentdb.com'),
                      icon: const Icon(Icons.public),
                      label: Text(localizations.get('visitWebsite')),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            
            // Features list
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Features:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    _buildFeatureItem(context, 'Multiple quiz categories'),
                    _buildFeatureItem(context, 'Adjustable difficulty levels'),
                    _buildFeatureItem(context, 'Score tracking and leaderboard'),
                    _buildFeatureItem(context, 'Dark and light themes'),
                    _buildFeatureItem(context, 'Sound effects and vibration'),
                    _buildFeatureItem(context, 'Multiple languages (English, French, Arabic)'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
