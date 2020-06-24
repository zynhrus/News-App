import 'dart:async';
import 'package:newsapp/model/news_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:newsapp/respository/respository.dart';
import 'package:newsapp/respository/state.dart';

class SearchNewsBloc {
  static NewsRepository _repository = NewsRepository();
  PublishSubject<String> _query;

  init() {
    _query = PublishSubject<String>();
  }

  Stream<NewsResponse> get newsList => _query.stream
      .debounceTime(Duration(milliseconds: 200))
      .where((String value) => value.isNotEmpty)
      .distinct()
      .transform(streamTransformer);

  final streamTransformer =
      StreamTransformer<String, NewsResponse>.fromHandlers(
          handleData: (query, sink) async {
    State state = await _repository.getNewsSearch(query);
    if (state is SuccessState) {
      sink.add(state.value);
    } else {
      sink.addError((state as ErrorState).msg);
      print(state);
    }
  });

  Function(String) get changeQuery => _query.sink.add;

  dispose() {
    _query.close();
  }
}

final searchNewsBloc = SearchNewsBloc();
