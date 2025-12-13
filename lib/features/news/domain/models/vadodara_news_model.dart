class VadodaraNews {
  final String title;
  final String description;
  final String? imageUrl;
  final String? link;
  final String? source;
  final DateTime? pubDate;
  final String? content;

  VadodaraNews({
    required this.title,
    required this.description,
    this.imageUrl,
    this.link,
    this.source,
    this.pubDate,
    this.content,
  });

  factory VadodaraNews.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateStr) {
      if (dateStr == null) return null;
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        return null;
      }
    }

    return VadodaraNews(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      link: json['link'],
      source: json['source_id'],
      pubDate: parseDate(json['pubDate']),
      content: json['content'],
    );
  }
}
