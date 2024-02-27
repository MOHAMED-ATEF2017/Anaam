import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_urls.dart';

class ChatController {
  Future<String> getUserMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const key5 = 'token';
      final token = prefs.getString(key5);

      http.Response response = await http.post(Uri.parse(ApiUrls.apiUrl+ApiUrls.getUserMessages), body: {
        'token': token,
      });

      return response.body;

    }catch (e){
      if (kDebugMode) {
        print('error in api: $e');
      }
      return 'error';
    }
  }

  Future<String> sendMessage(String message) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const key5 = 'token';
      final token = prefs.getString(key5);

      http.Response response = await http.post(Uri.parse(ApiUrls.apiUrl+ApiUrls.sendMessage), body: {
        'token': token,
        'message': message,
      });

      return response.body;

    }catch (e){
      if (kDebugMode) {
        print('error in api: $e');
      }
      return 'error';
    }
  }
}