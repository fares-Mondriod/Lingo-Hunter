import 'package:lingo_hunter/lingo_hunter.dart';
/// Example 3: Disable Base Language Usage
/// Translation files generated without base language values..
void main() async {
  await LingoHunter.extractAndCreateTranslationFiles(
    baseLang: 'en',
    langs: ['ar', 'fr', 'es'],
    translateBaseLang: false,
  );
  print("🚀 Translation files generated without base language values.");
}