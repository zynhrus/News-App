import 'package:flutter/material.dart';
import 'category_news_bloc.dart';
export 'category_news_bloc.dart';

class CategoryNewsBlocProvide extends InheritedWidget {
  CategoryNewsBlocProvide({Key key, Widget child})
      : bloc = CategoryNewsBloc(),
        super(key: key, child: child);

  final CategoryNewsBloc bloc;

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static CategoryNewsBloc of(BuildContext context) {
    return (context
            .dependOnInheritedWidgetOfExactType<CategoryNewsBlocProvide>())
        .bloc;
  }
}
