# LingoHunter

LingoHunter is a powerful Dart package designed to automatically extract translatable strings from Flutter projects and generate JSON translation files. This helps developers streamline their localization process efficiently.

## 🚀 Features

- **Auto-detect project root** – Finds and scans the `lib/` directory for translatable strings.
- **Supports multiple languages** – Generates translation files for any specified languages.
- **Customizable output directory** – Allows saving translation files in a preferred location.
- **Regex customization** – Supports additional regex patterns to match custom translation methods.
- **Multi-file scanning** – Can extract translatable strings from `.dart` and `.js` files.
- **Toggle base language translation** – Optionally exclude base language keys from values.
- **Override regex patterns** – Fully replace the default extraction patterns.

## 📥 Installation

Add `LingoHunter` to your `pubspec.yaml`:

```yaml
dependencies:
  lingo_hunter: latest_version_here
```

Then run:

```sh
dart pub get
```

## 🔍 Usage Examples

### 1️⃣ **Basic Usage**

Automatically detects the Flutter project root, scans `.dart` files, and generates translation files in JSON format.

```dart
import 'package:lingo_hunter/lingo_hunter.dart';

void main() async {
  await LingoHunter.extractAndCreateTranslationFiles(
    baseLang: 'en',
    langs: ['ar', 'fr', 'es'],
  );
  print("✅ Translation files generated successfully in the project root.");
}
```

#### **Generated Output (translations_en.json)**

```json
{
  "Hello": "Hello",
  "Welcome": "Welcome"
}
```

#### **Generated Output (translations_ar.json, translations_fr.json, translations_es.json)**

```json
{
  "Hello": "",
  "Welcome": ""
}
```

---

### 2️⃣ **Advanced Usage**

Define a custom project directory, output directory, and add custom regex patterns.

```dart
import 'package:lingo_hunter/lingo_hunter.dart';

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
```

---

### 3️⃣ **Saving Translations in a Custom Directory**

Specify a custom directory for storing translation files.

```dart
import 'package:lingo_hunter/lingo_hunter.dart';

void main() async {
  await LingoHunter.extractAndCreateTranslationFiles(
    baseLang: 'en',
    langs: ['ar', 'fr', 'it'],
    outputDirectory: 'assets/locales',
  );
  print("📂 Translation files saved in `assets/locales/`.");
}
```

---

### 4️⃣ **Scanning Both Dart & JavaScript Files**

Extract translatable strings from both `.dart` and `.js` files.

```dart
import 'package:lingo_hunter/lingo_hunter.dart';

void main() async {
  await LingoHunter.extractAndCreateTranslationFiles(
    baseLang: 'en',
    langs: ['es', 'ru'],
    fileExtensions: ['.dart', '.js'],
  );
  print("🎯 Extracted translation strings from both `.dart` and `.js` files!");
}
```

---

### 5️⃣ **Disabling Base Language Translation**

By default, the base language file includes keys with values. If you want only keys without values, set `translateBaseLang: false`.

```dart
import 'package:lingo_hunter/lingo_hunter.dart';

void main() async {
  await LingoHunter.extractAndCreateTranslationFiles(
    baseLang: 'en',
    langs: ['ar', 'fr', 'es'],
    translateBaseLang: false,
  );
  print("🚀 Translation files generated without base language values.");
}
```

#### **Generated Output (translations_en.json)**

```json
{
  "Hello": "",
  "Welcome": ""
}
```

---

### 6️⃣ **Overriding Default Regex Patterns**

To fully replace the built-in regex patterns, set `overrideRegExps: true` and provide your custom patterns.

```dart
import 'package:lingo_hunter/lingo_hunter.dart';

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
```

---

## 📂 Example Directory Structure

Your project should have an `example/` directory with separate files for different scenarios:

```
example/
├── basic_usage.dart
├── advanced_usage.dart
├── custom_output.dart
├── scan_dart_js.dart
├── disable_base_lang.dart
├── override_patterns.dart
```

To run any example, navigate to the `example/` folder and execute:

```sh
dart run example/basic_usage.dart
```

## ⚡️ Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request on [GitHub](https://github.com/fares-Mondriod/Lingo-Hunter).

## 📜 License

This package is licensed under the MIT License. See the `LICENSE` file for more details.

---

🚀 **Now you're ready to automate your Flutter localization with LingoHunter!** 🎯
