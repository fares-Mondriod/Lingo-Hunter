import 'package:lingo_hunter/lingo_hunter.dart';

/// Example 2: Advanced Usage
/// Allows specifying a custom project directory, output directory,
/// and additional regex patterns to match translatable strings.
void main() async {
  await LingoHunter.extractAndCreateTranslationFiles(
    baseLang: 'en',
    langs: ['ar', 'fr', 'de'],
    projectDirectory: '/Users/username/Projects/MyFlutterApp',
    outputDirectory: '/Users/username/Projects/MyFlutterApp/assets/lang',
    additionalRegExps: [
      RegExp(r'translate\("([^\"]+)"\)'), // Custom regex pattern
    ],
  );
  print("🚀 Custom translation files generated successfully!");
}