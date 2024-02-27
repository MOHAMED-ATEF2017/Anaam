import 'package:flutter/material.dart';

import 'colors.dart';


ThemeData appTheme = ThemeData(
  textTheme: TextTheme(
    headline1: TextStyle(
      color: AppColors.white,
      fontSize: 16,
      fontFamily: "Cairo",
      fontWeight: FontWeight.normal,
      //letterSpacing: 0.15,
    ),
    headline2: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        decoration: TextDecoration.none,
        fontFamily: "Cairo",
        color: AppColors.blackColor),
    headline3: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
        decoration: TextDecoration.none,
        fontFamily: "Cairo",
        color: AppColors.blackColor),
    headline4: TextStyle(
        fontSize: 22,
        decoration: TextDecoration.none,
        fontFamily: "Cairo",
        color: AppColors.blackColor),
    headline5: TextStyle(
      color: AppColors.blackColor,
      fontSize: 18,
      fontFamily: "Cairo",
      fontWeight: FontWeight.w900,
      letterSpacing: 0.15,
    ),
  ),
  fontFamily: 'Cairo',
  appBarTheme:  AppBarTheme(
    backgroundColor: AppColors.blackColor,
    centerTitle: true,
  ),
  brightness: Brightness.light,
  primaryColor: AppColors.blackColor,
  backgroundColor: AppColors.white,
  colorScheme:  ColorScheme.light(
    primary: AppColors.blackColor,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.blue),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.blue,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: const OutlineInputBorder(),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xff184B92), width: 4),
    ),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.red.shade900, width: 2)),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: Colors.red.shade900, width: 2),
    ),
  ),
);
