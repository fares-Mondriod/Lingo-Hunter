import 'package:lingo_hunter/lingo_hunter.dart';

/// Example 4: Scanning Dart & JavaScript Files
/// Useful for projects that contain translatable strings in both `.dart` and `.js` files.
void main() async {
  await LingoHunter.extractAndCreateTranslationFiles(
    baseLang: 'en',
    langs: ['es', 'ru'],
    fileExtensions: ['.dart', '.js'], // Scans `.dart` and `.js`
  );
  print("🎯 Extracted translation strings from both `.dart` and `.js` files!");
}