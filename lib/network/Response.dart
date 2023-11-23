import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:news/model/NewsModel.dart';

class Api {
  static String baseUrl = "newsapi.org";
  static String endPoint = "/v2/top-headlines";
  static String apikey = "dfb1d9be6a0e46509d423ea0425eaed7";
}

class ApiService {
  final client = http.Client();

  Future<List<Results>> getNews() async {
    final queryParameters = {
      'country': 'in',
      'category': 'general',
      'apiKey': Api.apikey
    };

    final uri = Uri.https(Api.baseUrl, Api.endPoint, queryParameters);
    final response = await client.get(uri);
    Map<String, dynamic> json = jsonDecode(response.body);
    List<dynamic> body = json['articles'];
    List<Results> articles =
        body.map((dynamic item) => Results.fromJson(item)).toList();
    return articles;
  }
}
