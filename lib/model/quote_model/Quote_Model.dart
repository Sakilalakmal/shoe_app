class QuoteModel {
  final String content;
  final String author;
  final List<String> tags;
  final int length;

  QuoteModel({
    required this.content,
    required this.author,
    required this.tags,
    required this.length,
  });

  // Convert JSON to QuoteModel
  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      content: json['content'] ?? '',
      author: json['author'] ?? 'Unknown',
      tags: List<String>.from(json['tags'] ?? []),
      length: json['length'] ?? 0,
    );
  }

  // Convert QuoteModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'author': author,
      'tags': tags,
      'length': length,
    };
  }

  @override
  String toString() {
    return 'QuoteModel(content: $content, author: $author)';
  }
}