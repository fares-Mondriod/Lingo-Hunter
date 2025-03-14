import 'package:lingo_hunter/lingo_hunter.dart';
///  Example 6 Overriding Default Regex Patterns
///  Extracted using custom regex patterns only!
void main() async {
  await LingoHunter.extractAndCreateTranslationFiles(
    baseLang: 'en',
    langs: ['ar', 'fr'],
    overrideRegExps: true,
    additionalRegExps: [
      RegExp(r'gettext\("([^\"]+)"\)'), // Fully replacing default regex
    ],
  );
  print("🔍 Extracted using custom regex patterns only!");
}