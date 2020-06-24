import 'package:flutter/material.dart';
import 'package:newsapp/bloc/news_bloc.dart';
import 'package:newsapp/helper/custom_drawer.dart';
import 'package:newsapp/model/news_response.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:newsapp/model/news.dart';
import 'package:newsapp/views/description_page.dart';
import 'package:share/share.dart';
import 'package:newsapp/model/favorite.dart';
import 'package:newsapp/respository/database.dart';

class NewsListPage extends StatefulWidget {
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  @override
  void initState() {
    super.initState();
    trendingNewsBloc..getNews();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return CustomDrawer(
      title: "Trending Indonesia",
      color: Colors.white,
      child: Scaffold(
        body: StreamBuilder<NewsResponse>(
          stream: trendingNewsBloc.subject.stream,
          builder: (context, AsyncSnapshot<NewsResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return _buildErrorWidget(snapshot.data.error);
              }
              return _buildListWidget(snapshot.data, height);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else {
              return _buildLoadingWidget();
            }
          },
        ),
      ),
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

  Widget _buildListWidget(NewsResponse data, double height) {
    List<News> news = data.news;
    if (news.length == 0) {
      return Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "No More News",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    } else
      return PageView.builder(
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
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: height / 2.5,
                      width: double.infinity,
                      child: Image.network(
                        news[index].urlToImage == "" ||
                                news[index].urlToImage == null
                            ? "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png"
                            : news[index].urlToImage,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 90,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black, Colors.transparent])),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Article by",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w200),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  news[index].author == null
                                      ? "Unknown"
                                      : news[index].author,
                                  style: TextStyle(fontSize: 18),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
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
                                        urlToImage: news[index].urlToImage ==
                                                null
                                            ? "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png"
                                            : news[index].urlToImage,
                                        publishedAt:
                                            news[index].publishedAt == null
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
                                icon: Icon(Icons.share),
                                onPressed: () {
                                  Share.share(news[index].url);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      AutoSizeText(
                        news[index].title,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        maxLines: 3,
                      ),
                      SizedBox(height: 15),
                      Text(
                        news[index].publishedAt,
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.only(bottom: 12),
                        height: height / 4,
                        child: AutoSizeText(
                          news[index].content == null
                              ? "Click here for more"
                              : news[index].content,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
  }
}
