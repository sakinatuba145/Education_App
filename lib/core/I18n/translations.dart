import 'package:education_app/core/I18n/en.dart';
import 'package:education_app/core/I18n/fa.dart';
import 'package:education_app/core/I18n/ps.dart';
import 'package:education_app/core/I18n/tr.dart';
import 'package:education_app/core/I18n/ur.dart';
import 'package:get/get.dart';

import 'ar.dart';
import 'hi.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': EnglishLanguage().keys,
    'fa': PersianLanguage().keys,
    'hi': HindiLanguage().keys,
    'ps': PashtoLanguage().keys,
    'ur': UrduLanguage().keys,
    'ar': ArabicLanguage().keys,
    'tr': TurkishLanguage().keys,
  };


}

abstract class AppTranslationsKeys {
  Map<String, String> get keys;
}