import 'package:test/test.dart';
import 'package:lingo_hunter/lingo_hunter.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  group('LingoHunter Tests', () {
    const String testOutputDir = 'test_output';

    setUp(() async {
      final outputDir = Directory(testOutputDir);
      if (await outputDir.exists()) {
        await outputDir.delete(recursive: true);
      }
      await outputDir.create(recursive: true);
    });


    tearDown(() async {
      final outputDir = Directory(testOutputDir);
      if (await outputDir.exists()) {
        await outputDir.delete(recursive: true);
      }
    });

    test('Basic translation extraction', () async {
      await LingoHunter.extractAndCreateTranslationFiles(
        baseLang: 'en',
        langs: ['ar', 'fr'],
        outputDirectory: testOutputDir,
      );
      
      expect(File('$testOutputDir/translations_en.json').existsSync(), isTrue);
      expect(File('$testOutputDir/translations_ar.json').existsSync(), isTrue);
      expect(File('$testOutputDir/translations_fr.json').existsSync(), isTrue);
    });

    test('Disable base language translation', () async {
      await LingoHunter.extractAndCreateTranslationFiles(
        baseLang: 'en',
        langs: ['ar', 'fr'],
        outputDirectory: testOutputDir,
        translateBaseLang: false,
      );
      
      final enFile = File('$testOutputDir/translations_en.json');
      expect(enFile.existsSync(), isTrue);
      final content = jsonDecode(enFile.readAsStringSync());
      expect(content.isEmpty, isFalse);
      content.forEach((key, value) {
        expect(value, equals(''));
      });
    });

    test('Custom regex pattern extraction', () async {
      await LingoHunter.extractAndCreateTranslationFiles(
        baseLang: 'en',
        langs: ['es'],
        outputDirectory: testOutputDir,
        overrideRegExps: true,
        additionalRegExps: [RegExp(r'gettext\("([^"]+)"\)')],
      );
      
      expect(File('$testOutputDir/translations_es.json').existsSync(), isTrue);
    });
  });
}