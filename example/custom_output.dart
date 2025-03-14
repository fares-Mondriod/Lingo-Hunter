import 'package:lingo_hunter/lingo_hunter.dart';

/// Example 3: Custom Output Directory
/// Saves translation files in a specific directory inside the project.
void main() async {
  await LingoHunter.extractAndCreateTranslationFiles(
    baseLang: 'en',
    langs: ['ar', 'fr', 'it'],
    outputDirectory: 'assets/locales', // Custom storage path
  );
  print("📂 Translation files saved in `assets/locales/`.");
}