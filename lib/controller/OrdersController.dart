import 'dart:convert';

import 'package:en3am_app/models/orders.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../config/api_urls.dart';

class OrdersController {

  Future<String> placeOrder(
    String name,
    String phone,
    String address,
    String deliverDate,
    int city,
    String deliveryTime,
    int paymentMethod,
    String bankName,
    String accountName,
    String accountIban,
  ) async {

    try {
    final prefs = await SharedPreferences.getInstance();
    const key5 = 'token';
    final token = prefs.getString(key5);

    http.Response response = await http.post(Uri.parse(ApiUrls.apiUrl+ApiUrls.placeOrder), body: {
      'token': token,
      'ship_name': name,
      'ship_phone': phone,
      'ship_address': address,
      'ship_city': city.toString(),
      'ship_date': deliverDate,
      'ship_time': deliveryTime,
      'payment_method': paymentMethod.toString(),
      'bank_name': bankName,
      'account_name': accountName,
      'account_iban': accountIban,
    });

    return response.body;

    }catch(e){

      return 'error';
    }

  }

  Future<List<OrderModel>> getUserOrders () async{
    try {
      final prefs = await SharedPreferences.getInstance();
      const key5 = 'token';
      final token = prefs.getString(key5);

      http.Response response = await http.post(Uri.parse(ApiUrls.apiUrl+ApiUrls.getUserOrders), body: {
        'token': token,
      });

      print(response.body);

      Map<String, dynamic> res = json.decode(response.body);

      List<OrderModel> data = List<OrderModel>.from(
          res['data'].map((x) => OrderModel.fromJson(x)));

      return data;

    }catch(e){
      rethrow;
    }
  }
}
