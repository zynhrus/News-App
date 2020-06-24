import 'package:dio/dio.dart';
import 'package:newsapp/model/news_response.dart';
import 'package:newsapp/respository/state.dart';

class NewsRepository {
  static String apiKey = "6017038084fc4a6da9111eebf4ea2388";
  static String mainUrl = "https://newsapi.org/v2/top-headlines";
  final Dio _dio = Dio();

  Future<NewsResponse> getNewsHeadline() async {
    final getTopHeadlinesIndonesia = '$mainUrl?country=id&apiKey=$apiKey';
    try {
      Response response = await _dio.get(getTopHeadlinesIndonesia);
      return NewsResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return NewsResponse.withError("$error");
    }
  }

  Future<NewsResponse> getNewsCategory(String category) async {
    final getCategoryIndonesia =
        '$mainUrl?country=id&category=$category&apiKey=$apiKey';
    try {
      Response response = await _dio.get(getCategoryIndonesia);
      return NewsResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return NewsResponse.withError("$error");
    }
  }

  Future<State> getNewsSearch(String query) async {
    final getSearchNews = '$mainUrl?q=$query&apiKey=$apiKey';
    Response response = await _dio.get(getSearchNews);
    try {
      return State<NewsResponse>.success(NewsResponse.fromJson(response.data));
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return State<String>.error(response.statusCode.toString());
    }
  }

  Future<State> imageData(query) => getNewsSearch(query);
}
