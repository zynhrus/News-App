class News {
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  News(
    this.urlToImage,
    this.url,
    this.title,
    this.author,
    this.content,
    this.description,
    this.publishedAt,
  );

  News.fromJson(Map<String, dynamic> json)
      : author = json["author"],
        title = json["title"],
        content = json["content"],
        description = json["description"],
        url = json["url"],
        urlToImage = json["urlToImage"],
        publishedAt = json["publishedAt"];
}
