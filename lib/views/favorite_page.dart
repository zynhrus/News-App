import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/helper/custom_drawer.dart';
import 'package:newsapp/model/favorite.dart';
import 'package:newsapp/respository/database.dart';

import 'description_page.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    DBProvider.db.getAllFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDrawer(
      title: "Favorite",
      child: Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(height: 90),
            Expanded(
              child: FutureBuilder<List<Favorite>>(
                future: DBProvider.db.getAllFavorites(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Favorite>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: 10, bottom: 30),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Favorite favorite = snapshot.data[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DescriptionPage(favorite.url)),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10.0,
                                    spreadRadius: 2.0,
                                    offset: Offset(
                                      5.0,
                                      5.0,
                                    ),
                                  )
                                ],
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      width: 130,
                                      height: 130,
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  favorite.urlToImage),
                                              fit: BoxFit.cover))),
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            AutoSizeText(
                                              favorite.title,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                              maxLines: 4,
                                            ),
                                            SizedBox(height: 7),
                                            AutoSizeText(
                                              "By " + favorite.author,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Flexible(
                                              child: AutoSizeText(
                                                favorite.publishedAt,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.favorite,
                                                color: Colors.pinkAccent,
                                              ),
                                              onPressed: () {
                                                DBProvider.db.deleteFavorite(
                                                    favorite.url);
                                                setState(() {});
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                        child: Text(
                      'No Favorite Yet',
                      style: TextStyle(color: Colors.black, fontSize: 30),
                    ));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
