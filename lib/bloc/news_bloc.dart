import 'package:newsapp/model/news_response.dart';
import 'package:newsapp/respository/respository.dart';
import 'package:rxdart/rxdart.dart';

class NewsBloc {
  final NewsRepository _repository = NewsRepository();
  final BehaviorSubject<NewsResponse> _subject =
      BehaviorSubject<NewsResponse>();

  getNews() async {
    NewsResponse response = await _repository.getNewsHeadline();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<NewsResponse> get subject => _subject;
}

final trendingNewsBloc = NewsBloc();
