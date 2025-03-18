import 'dart:io';

import 'package:args/args.dart';
import 'package:lingo_hunter/lingo_hunter.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('baseLang', abbr: 'b', help: 'Base language (default: en)')
    ..addMultiOption('langs', abbr: 'l', help: 'List of target languages')
    ..addOption('projectDir', abbr: 'p', help: 'Project root directory')
    ..addOption('outputDir',
        abbr: 'o', help: 'Output directory for translation files')
    ..addFlag('disableBaseLang',
        abbr: 'd', help: 'Disable base language translation')
    ..addFlag('overridePattern',
        abbr: 'r', help: 'Override default regex patterns')
    ..addMultiOption('patterns',
        abbr: 'x', help: 'Custom regex patterns for translation extraction')
    ..addMultiOption('extensions',
        abbr: 'e', help: 'File extensions to scan (e.g., .dart, .js)')
    ..addFlag('help',
        abbr: 'h', negatable: false, help: 'Show usage information');

  final argResults = parser.parse(arguments);

  if (argResults['help'] as bool) {
    print(parser.usage);
    return;
  }

  final baseLang = argResults['baseLang'] ?? 'en';
  final langs = argResults['langs']?.cast<String>() ?? [];
  final projectDirectory = argResults['projectDir'] ?? Directory.current.path;
  final outputDirectory = argResults['outputDir'];
  final translateBaseLang = !(argResults['disableBaseLang'] as bool);
  final overrideRegExps = argResults['overridePattern'] as bool;
  final additionalRegExps = (argResults['patterns'] as List<String>?)
          ?.map((p) => RegExp(p))
          .toList() ??
      [];
  final fileExtensions = argResults['extensions']?.cast<String>();

  await LingoHunter.extractAndCreateTranslationFiles(
    baseLang: baseLang,
    langs: langs,
    projectDirectory: projectDirectory,
    outputDirectory: outputDirectory,
    translateBaseLang: translateBaseLang,
    overrideRegExps: overrideRegExps,
    additionalRegExps: additionalRegExps,
    fileExtensions: fileExtensions,
  );

  print('Translation files generated successfully!');
}
