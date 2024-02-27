import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CenterLocalization {
  final Locale locale;

  CenterLocalization(this.locale);

  static CenterLocalization? of(BuildContext context) {
    return Localizations.of<CenterLocalization>(context, CenterLocalization);
  }

  Map<String, String> _localizedValues = {};

  Future load() async {
    String jsonLangValues = await rootBundle
        .loadString("lib/config/lang/languages/${locale.languageCode}.json");
    Map<String, dynamic> mappedJson = json.decode(jsonLangValues);

    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String getTranslatedValue(String key) {
    return _localizedValues[key] ?? '';
  }

  static const LocalizationsDelegate<CenterLocalization> delegate =
      _CenterLocalizationsDelegate();
}

class _CenterLocalizationsDelegate
    extends LocalizationsDelegate<CenterLocalization> {
  const _CenterLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<CenterLocalization> load(Locale locale) async {
    CenterLocalization localization = CenterLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(_CenterLocalizationsDelegate old) => false;
}
