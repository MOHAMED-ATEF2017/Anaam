
import 'package:clipboard/clipboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class GeneralFunctions {

  static checkIfGuest() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'is_login';
    final value = prefs.get(key);

    if (value != '1') {
        return true;
    }else{
      return false;
    }
  }

  static Future<void> openUrl(String url) async {
    if (kDebugMode) {
      print(url);
    }

    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  static void copyText(context,String text){

    FlutterClipboard.copy(text);

    var snackBar = const SnackBar(content: Text('تم النسخ إلى الحافظة'));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnack (context,String text){
    return ScaffoldMessenger.of(context).showSnackBar( SnackBar(
      content: Text(text),
    ),);
  }
}