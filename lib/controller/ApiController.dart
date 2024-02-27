
import 'dart:convert';
import 'package:en3am_app/models/cities.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/api_urls.dart';
import '../models/banks.dart';
import '../models/cutting.dart';
import '../models/packaging.dart';
import '../models/times.dart';

class ApiController {

  getRequest(String url) async {
    String fullUrl = ApiUrls.apiUrl+url;


    http.Response response = await http.get(Uri.parse(fullUrl));

    try {
      var data = json.decode(response.body);
      return data;
    }catch(e){

      var data = json.decode('{}');
      return data;
    }

  }

  Future<Map<String, dynamic>> getSettings() async {
    try {
      Map<String, dynamic> data = await getRequest(ApiUrls.settingsUrl);


      return data;
    }catch(e)
    {
      rethrow;
    }
  }

  Future<List<CuttingModel>> getCutting() async {
    try {
      Map<String, dynamic> res = await getRequest(ApiUrls.cutting);

      List<CuttingModel> data = List<CuttingModel>.from(
          res['data'].map((x) => CuttingModel.fromJson(x)));
      return data;
    }catch(e)
    {
      rethrow;
    }
  }

  Future<List<PackagingModel>> getPackaging() async {
    try {
      Map<String, dynamic> res = await getRequest(ApiUrls.packaging);

      List<PackagingModel> data = List<PackagingModel>.from(
          res['data'].map((x) => PackagingModel.fromJson(x)));
      return data;
    }catch(e)
    {
      rethrow;
    }
  }

  Future<List<CitiesModel>> getCities() async {
    try {
      Map<String, dynamic> res = await getRequest(ApiUrls.cities);

      List<CitiesModel> data = List<CitiesModel>.from(
          res['data'].map((x) => CitiesModel.fromJson(x)));
      return data;
    }catch(e)
    {
      rethrow;
    }
  }

  Future<List<TimesModel>> getTimes() async {
    try {
      Map<String, dynamic> res = await getRequest(ApiUrls.times);

      List<TimesModel> data = List<TimesModel>.from(
          res['data'].map((x) => TimesModel.fromJson(x)));
      return data;
    }catch(e)
    {
      rethrow;
    }
  }

  Future<List<BanksModel>> getBankAccounts() async {
    try {
      Map<String, dynamic> res = await getRequest(ApiUrls.banks);

      List<BanksModel> data = List<BanksModel>.from(
          res['data'].map((x) => BanksModel.fromJson(x)));
      return data;
    }catch(e)
    {
      rethrow;
    }
  }

  Future<String> getMinced() async {
    try {
      String fullUrl = ApiUrls.apiUrl+ApiUrls.minced;
      http.Response response = await http.get(Uri.parse(fullUrl));

      return response.body;
    }catch(e)
    {
      return 'error';
    }
  }
}