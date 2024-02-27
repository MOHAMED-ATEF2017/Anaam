
import 'package:flutter/material.dart';

import '../../config/api_urls.dart';
import '../controller/ApiController.dart';

class HomeFunctions{

  static Future<List<String>> getBanners() async{
    ApiController _api = ApiController();
    List<dynamic> _data = await _api.getRequest(ApiUrls.bannerUrl) as List;

    List<String> bannersList = [];

    for(int i=0;i < _data.length; i++)
    {
      bannersList.add(_data[i]['image']);
    }

    return bannersList;
  }

  static Future<Map<String,dynamic>> getHomeProducts() async{
    ApiController _api = ApiController();
    Map<String,dynamic> _data = await _api.getRequest(ApiUrls.homeProductsUrl);

    return _data;
  }


}