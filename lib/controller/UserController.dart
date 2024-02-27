import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/api_urls.dart';



class UserController{

  Future<dynamic> checkPhoneNumber(String phone) async {

    http.Response response = await http.post(Uri.parse(ApiUrls.apiUrl+ApiUrls.checkNumberUrl), body: {
      'phone': phone,
    });

    if (kDebugMode) {
      print(response.body);
    }

    var data = json.decode(response.body);

    return data;

  }

  Future<dynamic> checkOpt(String phone,String otp,String name) async {

    http.Response response = await http.post(Uri.parse(ApiUrls.apiUrl+ApiUrls.checkOtpUrl), body: {
      'phone': phone,
      'otp': otp,
      'name' : name,
    });


    if (kDebugMode) {
      print(phone);
      print(otp);
      print(response.body);
    }

    var data = json.decode(response.body);

    try{

    if(data['success'] == "true")
      {

          saveUserParams(data['user']['id'].toString(),data['user']['api_token'].toString(),data['user']['name'].toString(),data['user']['phone'].toString(),data['user']['address'].toString(),data['user']['city_id']);

      }
    }catch (e)
    {
      if (kDebugMode) {
        print('error: $e');
      }
    }

    return data;

  }

  saveUserParams(String userId, String token, String name, String phone ,String address, int cityId ) async {
    final prefs = await SharedPreferences.getInstance();

    const key = 'is_login';
    const value = "1";
    prefs.setString(key, value);

    const key1 = 'user_id';
    final value1 = userId;
    prefs.setString(key1, value1);

    const key2 = 'name';
    final value2 = name;
    prefs.setString(key2, value2);

    const key3 = 'token';
    final value3 = token;
    prefs.setString(key3, value3);

    const key4 = 'phone';
    final value4 = phone;
    prefs.setString(key4, value4);

    const key5 = 'address';
    final value5 = address;
    prefs.setString(key5, value5);

    const key6 = 'city_id';
    final value6 = cityId;
    prefs.setInt(key6, value6);

  }

  Future<String> updateUserData(String name,String address,String cityId) async {

    try{
    final prefs = await SharedPreferences.getInstance();
    const key5 = 'token';
    final token = prefs.getString(key5);

    http.Response response = await http.post(Uri.parse(ApiUrls.apiUrl+ApiUrls.updateProfile), body: {
      'token': token,
      'name': name,
      'address': address,
      'city_id': cityId,
    });

    return response.body;

    }catch(e){

      return 'error';
    }
  }

  updateUserFCM(String fcm){
  }

  Future<String> deleteAccount() async {

    try{
      final prefs = await SharedPreferences.getInstance();
      const key5 = 'token';
      final token = prefs.getString(key5);

      http.Response response = await http.post(Uri.parse(ApiUrls.apiUrl+ApiUrls.deleteAccount), body: {
        'token': token,
      });

      return response.body;

    }catch(e){

      return 'error';
    }
  }

}