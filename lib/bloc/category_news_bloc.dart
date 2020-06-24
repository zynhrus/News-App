import 'package:newsapp/model/news_response.dart';
import 'package:newsapp/respository/respository.dart';
import 'package:rxdart/rxdart.dart';

class CategoryNewsBloc {
  final _repository = NewsRepository();
  final _category = PublishSubject<String>();
  final _subject = BehaviorSubject<Future<NewsResponse>>();

  Function(String) get getNewsByCategory => _category.sink.add;
  Stream<Future<NewsResponse>> get newsArticleByCategory => _subject.stream;

  CategoryNewsBloc() {
    _category.stream.transform(_itemTransformer()).pipe(_subject);
  }

  dispose() async {
    _category.close();
    await _subject.drain();
    _subject.close();
  }

  _itemTransformer() {
    return ScanStreamTransformer(
      (Future<NewsResponse> articles, String category, int index) {
        print(index);
        articles = _repository.getNewsCategory(category);
        return articles;
      },
    );
  }
}
