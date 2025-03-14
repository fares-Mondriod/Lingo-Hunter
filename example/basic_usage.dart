import 'package:lingo_hunter/lingo_hunter.dart';
/// Example 1: Basic Usage
/// Automatically detects the project root, scans for translatable strings,
/// and generates JSON translation files.
void main() async {
  await LingoHunter.extractAndCreateTranslationFiles(
    baseLang: 'en', // Base language (English)
    langs: ['ar', 'fr', 'es'], // Additional languages
  );
  print("✅ Translation files generated successfully in the project root.");
}
