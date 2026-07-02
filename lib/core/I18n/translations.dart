import 'package:education_app/core/I18n/en.dart';
import 'package:education_app/core/I18n/fa.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': EnglishLanguage().keys,
    'fa': PersionLanguage().keys,
  };


}

abstract class AppTranslationsKeys {
  Map<String, String> get keys;
}