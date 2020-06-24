import 'package:flutter/material.dart';
import 'package:newsapp/bloc/search_news_bloc.dart';
import 'package:newsapp/helper/custom_drawer.dart';
import 'package:newsapp/model/favorite.dart';
import 'package:newsapp/model/news.dart';
import 'package:newsapp/model/news_response.dart';
import 'package:newsapp/respository/database.dart';
import 'package:share/share.dart';
import 'description_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  void initState() {
    super.initState();
    searchNewsBloc.init();
  }

  @override
  void dispose() {
    searchNewsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return CustomDrawer(
      title: "Search",
      child: Scaffold(
        body: Column(
          children: <Widget>[
            CustomTextField(),
            StreamBuilder<NewsResponse>(
              stream: searchNewsBloc.newsList,
              builder: (context, AsyncSnapshot<NewsResponse> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.error != null &&
                      snapshot.data.error.length > 0) {
                    return _buildErrorWidget(snapshot.data.error);
                  } else if (snapshot.data.news.length == 0) {
                    return Text('Sorry No News About It');
                  }
                  return _buildListWidget(snapshot.data, width, height);
                } else if (snapshot.hasError) {
                  return _buildErrorWidget(snapshot.error);
                } else {
                  return _buildLoadingWidget();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildListWidget(NewsResponse data, width, height) {
  List<News> news = data.news;
  return Expanded(
    child: ListView.builder(
        padding: EdgeInsets.only(top: 10),
        itemCount: news.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DescriptionPage(news[index].url)),
              );
            },
            child: Container(
              width: width,
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.6), BlendMode.dstATop),
                      fit: BoxFit.cover,
                      image: NetworkImage(news[index].urlToImage == "" ||
                              news[index].urlToImage == null
                          ? "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png"
                          : news[index].urlToImage))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          news[index].author == null
                              ? "Unknown"
                              : news[index].author,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: Colors.pinkAccent,
                              ),
                              onPressed: () async {
                                await DBProvider.db.newFavorite(
                                  Favorite(
                                    urlToImage: news[index].urlToImage == null
                                        ? "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png"
                                        : news[index].urlToImage,
                                    publishedAt: news[index].publishedAt == null
                                        ? "Unknown"
                                        : news[index].publishedAt,
                                    author: news[index].author == null
                                        ? "Unknown"
                                        : news[index].author,
                                    url: news[index].url,
                                    title: news[index].title == null
                                        ? "Unknown"
                                        : news[index].title,
                                  ),
                                );
                              }),
                          IconButton(
                            icon: Icon(Icons.share, color: Colors.white),
                            onPressed: () {
                              Share.share(news[index].url);
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      news[index].title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(news[index].publishedAt,
                          style: TextStyle(color: Colors.white)),
                    ],
                  )
                ],
              ),
            ),
          );
        }),
  );
}

Widget _buildLoadingWidget() {
  return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height: 25.0,
        width: 25.0,
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 4.0,
        ),
      )
    ],
  ));
}

Widget _buildErrorWidget(String error) {
  return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Error occured: $error"),
    ],
  ));
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      margin: EdgeInsets.fromLTRB(20, 90, 20, 10),
      child: TextField(
        onChanged: (value) {
          searchNewsBloc.changeQuery(value);
          print(value);
        },
        style: TextStyle(color: Colors.black),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hoverColor: Colors.white,
          focusColor: Colors.white,
          contentPadding: EdgeInsets.only(left: 20),
          hintText: "Search",
          suffixIcon: Icon(
            Icons.search,
            size: 30,
            color: Colors.black,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Colors.white,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }
}
