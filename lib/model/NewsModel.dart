import 'dart:convert';

class Results {
  Source source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  Results(this.source, this.author, this.title, this.description, this.url,
      this.urlToImage, this.publishedAt, this.content);

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      Source.fromJson(json['source']),
      json['author'] as String?,
      json['title'] as String?,
      json['description'] as String?,
      json['url'] as String?,
      json['urlToImage'] as String?,
      json['publishedAt'] as String?,
      json['content'] as String?,
    );
  }
}

class Source {
  String name;

  Source(this.name);

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(json['name']);
  }
}
