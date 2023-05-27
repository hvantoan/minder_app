import 'package:minder/generated/l10n.dart';
import 'package:minder/util/constant/path/image_path.dart';

class Language {
  Language({this.key, required this.name, required this.imageIconPath});

  final String? key;
  final String name;
  final String imageIconPath;

  static List<Language> languages() {
    return [
      Language(
        name: S.current.txt_system_language,
        imageIconPath: ImagePath.device,
      ),
      Language(
          key: "vi", name: "Tiếng Việt", imageIconPath: ImagePath.vietnamese),
      Language(key: "en", name: "English", imageIconPath: ImagePath.english),
    ];
  }
}
