import 'dart:convert';

Favorite favoriteFromJson(String str) => Favorite.fromMap(json.decode(str));

String favoriteToJson(Favorite data) => json.encode(data.toMap());

class Favorite {
  String urlToImage;
  String publishedAt;
  String author;
  String url;
  String title;

  List<Favorite> favorites = [];

  Favorite({
    this.urlToImage,
    this.publishedAt,
    this.author,
    this.url,
    this.title,
  });

  factory Favorite.fromMap(Map<String, dynamic> json) => Favorite(
        urlToImage: json["urlToImage"],
        publishedAt: json["publishedAt"],
        author: json["author"],
        url: json["url"],
        title: json["title"],
      );

  Map<String, dynamic> toMap() => {
        "urlToImage": urlToImage,
        "publishedAt": publishedAt,
        "author": author,
        "url": url,
        "title": title,
      };
}
