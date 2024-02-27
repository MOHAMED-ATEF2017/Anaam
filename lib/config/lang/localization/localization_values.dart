// ignore_for_file: constant_identifier_names, file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'center_localization.dart';

String getTranslated(BuildContext buildContext, String key) {
  return CenterLocalization.of(buildContext)!.getTranslatedValue(key);
}

const String ARABIC = 'ar';
const String ENGLISH = 'en';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setString('languageCode', languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  final String defaultLocale =
      Platform.localeName; // Returns locale string in the form 'en_US'
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String lCode = sharedPreferences.getString('languageCode') ?? defaultLocale;
  return _locale(lCode);
}

Locale _locale(String langCode) {
  Locale locale;

  switch (langCode) {
    case ARABIC:
      locale = Locale(langCode, 'SA');
      break;
    case ENGLISH:
      locale = Locale(langCode, 'US');
      break;
    default:
      locale = const Locale(ARABIC, 'SA');
  }

  return locale;
}
