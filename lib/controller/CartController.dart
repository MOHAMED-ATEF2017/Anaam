import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_urls.dart';

class CartController {

  Future<dynamic> addToCart(
      String productId,
      String quantity,
      String size,
      String sizePrice,
      String cutting,
      String cuttingPrice,
      String packaging,
      String packagingPrice,
      String head,
      String rumen,
      String price,
      String note,
      String mincedCount,
      String mincedPrice,
      ) async {

    final prefs = await SharedPreferences.getInstance();
    const key5 = 'token';
    final token = prefs.getString(key5);


    http.Response response = await http.post(Uri.parse(ApiUrls.apiUrl+ApiUrls.addToCart), body: {
      'token': token,
      'product_id': productId,
      'quantity': quantity,
      'size_id': size,
      'size_price': sizePrice,
      'cutting_id': cutting,
      'cutting_price': cuttingPrice,
      'packaging_id': packaging,
      'packaging_price': packagingPrice,
      'head': head,
      'rumen': rumen,
      'price': price,
      'note': note,
      'minced_count': mincedCount,
      'minced_price': mincedPrice,
    });

    if (kDebugMode) {
      print(response.body);
    }

    var data = json.decode(response.body);

    return data;

  }

  Future<dynamic> getUserCart() async {


    final prefs = await SharedPreferences.getInstance();
    const key5 = 'token';
    final token = prefs.getString(key5);

    http.Response response = await http.post(Uri.parse(ApiUrls.apiUrl+ApiUrls.getCart), body: {
      'token': token,
    });

    // if (kDebugMode) {
    //   print(response.body);
    // }

    var data = json.decode(response.body);

    return data;

  }

  Future<bool> deleteItem(String id) async {
    try{


    final prefs = await SharedPreferences.getInstance();
    const key5 = 'token';
    final token = prefs.getString(key5);

    http.Response response = await http.post(Uri.parse(ApiUrls.apiUrl+ApiUrls.removeFromCart), body: {
      'token': token,
      'cart_id': id,
    });

    // if (kDebugMode) {
    //   print(response.body);
    // }

    var data = json.decode(response.body);

    if(data['success'] == true)
      {
        return true;
      }else{
        return false;
    }
    }catch (e){
      return false;
    }
  }
}