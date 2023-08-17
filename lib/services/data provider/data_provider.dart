import 'package:dio/dio.dart';
import 'package:new_app_api_integration/model/news.dart';

class DataProvider {
  static final _news = Dio();
  static Future<News> getNews(String gateWay) async {
    try {
      final rawData = await _news.get(gateWay);
      final News data = News.fromJson(rawData.data as Map<String, dynamic>);
      return data;
    } catch (e) {
      rethrow;
    }
  }
}
