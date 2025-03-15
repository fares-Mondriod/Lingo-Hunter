import 'dart:io';
import 'dart:convert';

abstract class LingoHunter {
  /// Extracts translatable strings from a Flutter project and generates translation files
  static Future<void> extractAndCreateTranslationFiles({
    /// The base language where the key is the same as the value
    required String baseLang,

    /// List of additional languages for which translation files will be created
    required List<String> langs,

    /// The Flutter project directory (optional, will auto-detect if not provided)
    String? projectDirectory,

    /// The output directory for the translation files (optional, defaults to the project root)
    String? outputDirectory,

    /// Whether to translate the base language
    bool translateBaseLang = true,

    /// Additional regular expressions to search for translation strings
    List<RegExp>? additionalRegExps,

    /// Whether to override default regular expressions entirely
    bool overrideRegExps = false,

    /// File extensions to scan for translation strings
    List<String> fileExtensions = const ['.dart'],
  }) async {
    // Find the project root directory
    final String projectRoot = projectDirectory ?? await _findLibDirectory();

    // Use the project root as output directory if not specified
    final String outputDir = outputDirectory ?? projectRoot;

    print("Project root directory: $projectRoot");
    print("Output directory: $outputDir");

    // Extract translatable strings
    final Set<String> strings = await extractStringsFromFlutterProject(
      directory: projectRoot,
      additionalRegExps: additionalRegExps,
      overrideRegExps: overrideRegExps,
      fileExtensions: fileExtensions,
    );

    // Generate translation files
    await _createTranslationFiles(
      strings: strings,
      outputDirectory: outputDir,
      baseLang: baseLang,
      langs: langs,
      translateBaseLang: translateBaseLang,
    );

    print("Successfully extracted strings and generated translation files.");
  }

  /// Finds the project's root directory by searching for the `pubspec.yaml` file
  static Future<String> _findLibDirectory() async {
    Directory current = Directory.current;

    // Search for `pubspec.yaml` in the current directory and parent directories
    while (true) {
      if (await File('${current.path}/pubspec.yaml').exists()) {
        final libPath = '${current.path}/lib';
        if (await Directory(libPath).exists()) {
          return libPath; // Return the `lib` directory if found
        } else {
          print(
              "Warning: 'lib' directory not found. Returning project root instead.");
          return current.path;
        }
      }

      // Ensure we haven't reached the system root
      if (current.path == current.parent.path) {
        break;
      }

      current = current.parent;
    }

    // If `pubspec.yaml` was not found, default to the current directory
    print(
        "Warning: `pubspec.yaml` not found. Using current directory as project root.");
    return Directory.current.path;
  }

  /// Extracts translatable strings from a Flutter project
  static Future<Set<String>> extractStringsFromFlutterProject({
    required String directory,
    List<RegExp>? additionalRegExps,
    bool overrideRegExps = false,
    List<String> fileExtensions = const ['.dart'],
  }) async {
    // Default patterns to search for translation calls
    final List<RegExp> defaultPatterns = [
      RegExp(r'"([^"]+)"\.tr\(\)'), // "string".tr()
      RegExp(r"'([^']+)'\.tr\(\)"), // 'string'.tr()
      RegExp(r'"([^"]+)"\.tr'), // "string".tr
      RegExp(r"'([^']+)'\.tr"), // 'string'.tr
      RegExp(r'"([^"]+)"\.tr\(\w+\)'), // "string".tr(context)
      RegExp(r"'([^']+)'\.tr\(\w+\)"), // 'string'.tr(context)
      RegExp(r'tr\(\w+, "([^"]+)"\)'), // tr(context, "string")
      RegExp(r"tr\(\w+, '([^']+)'\)"), // tr(context, 'string')
      RegExp(r'tr\("([^"]+)"\)'), // tr("string")
      RegExp(r"tr\('([^']+)'\)"), // tr('string')
      RegExp(r'"([^"]+)"\.tr\(args: \[.*?\]\)'), // "string".tr(args: [])
      RegExp(r'"([^"]+)"\.plural\(\d+\)'), // "string".plural(3)
      //Intl Package Patterns
      RegExp(r'AppLocalizations\.of\(context\)!\.translate\("([^"]+)"\)'),
    ];

    // Determine the patterns to use
    List<RegExp> patterns;
    if (overrideRegExps && additionalRegExps != null) {
      patterns = additionalRegExps;
    } else {
      patterns = [...defaultPatterns];
      if (additionalRegExps != null) {
        patterns.addAll(additionalRegExps);
      }
    }

    final Set<String> strings = {};
    final Directory projectDirObj = Directory(directory);
    final List<FileSystemEntity> entities =
        await projectDirObj.list(recursive: true).toList();

    // Filter files by the specified extensions
    final List<File> filteredFiles = entities
        .whereType<File>()
        .where((file) => fileExtensions.any((ext) => file.path.endsWith(ext)))
        .toList();

    // Extract strings from files
    for (final File file in filteredFiles) {
      final String content = await file.readAsString();

      for (final RegExp pattern in patterns) {
        final Iterable<RegExpMatch> matches = pattern.allMatches(content);

        for (final RegExpMatch match in matches) {
          if (match.groupCount >= 1 && match.group(1) != null) {
            strings.add(match.group(1)!);
          }
        }
      }
    }

    return strings;
  }

  /// Creates translation files for different languages
  static Future<void> _createTranslationFiles({
    required Set<String> strings,
    required String outputDirectory,
    required String baseLang,
    required List<String> langs,
    bool translateBaseLang = true,
  }) async {
    final Directory outputDir = Directory(outputDirectory);
    if (!await outputDir.exists()) {
      await outputDir.create(recursive: true);
    }

    // Always create the base language file, even if `translateBaseLang` is false
    final String baseFilePath = '$outputDirectory/translations_$baseLang.json';
    final Map<String, String> baseStrings = {
      for (final string in strings) string: translateBaseLang ? string : ""
    };
    await _writeTranslationFile(baseFilePath, baseStrings);

    for (final String lang in langs) {
      final String langFilePath = '$outputDirectory/translations_$lang.json';
      final Map<String, String> langStrings = {
        for (final string in strings) string: ""
      };
      await _writeTranslationFile(langFilePath, langStrings);
    }
  }

  /// Helper function to write a translation file
  /// دالة مساعدة لكتابة ملف الترجمة
  static Future<void> _writeTranslationFile(
      String filePath, Map<String, String> strings) async {
    final File file = File(filePath);
    final StringBuffer content = StringBuffer();
    content.writeln('{');

    int index = 0;
    for (final MapEntry<String, String> entry in strings.entries) {
      final String comma = (index < strings.length - 1) ? ',' : '';
      final String key =
          jsonEncode(entry.key).substring(1, jsonEncode(entry.key).length - 1);
      final String value = entry.value.isEmpty
          ? ""
          : jsonEncode(entry.value)
              .substring(1, jsonEncode(entry.value).length - 1);

      content.writeln('    "$key": "$value"$comma');
      index++;
    }

    content.writeln('}');
    await file.writeAsString(content.toString());
  }
}
