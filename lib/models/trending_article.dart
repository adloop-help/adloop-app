class TrendingArticle {
  final String title;
  final String image;
  final String url;
  final String source;

  TrendingArticle({
    required this.title,
    required this.image,
    required this.url,
    required this.source,
  });

  factory TrendingArticle.fromJson(Map<String, dynamic> json) {
    return TrendingArticle(
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      url: json['url'] ?? '',
      source: json['source']?['name'] ?? '',
    );
  }
}
