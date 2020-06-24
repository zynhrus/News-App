import 'package:flutter/material.dart';
import 'package:newsapp/helper/splash_screen.dart';
import 'package:newsapp/views/category_page.dart';
import 'package:newsapp/views/favorite_page.dart';
import 'package:newsapp/views/news_list_page.dart';
import 'package:newsapp/views/search_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
      title: 'News App',
      routes: <String, WidgetBuilder>{
        "/Home": (BuildContext context) => NewsListPage(),
        "/Category": (BuildContext context) => CategoryPage(),
        "/Search": (BuildContext context) => SearchPage(),
        "/Favorite": (BuildContext context) => FavoritePage(),
      },
      home: SplashScreen(),
    );
  }
}
