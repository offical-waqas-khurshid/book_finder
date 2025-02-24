class BookModel {
  final String id;
  final String title;
  final String authors;
  final String thumbnail;

  BookModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.thumbnail,
  });

  /// Convert `BookModel` to a `Map<String, dynamic>` (for storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'thumbnail': thumbnail,
    };
  }

  /// Create `BookModel` from a `Map<String, dynamic>` (for retrieval)
  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'] ?? '',
      title: map['title'] ?? 'No Title',
      authors: map['authors'] ?? 'Unknown',
      thumbnail: map['thumbnail'] ?? '',
    );
  }

  /// Convert JSON (API response) to `BookModel`
  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      title: json['volumeInfo']['title'] ?? 'No Title',
      authors: (json['volumeInfo']['authors'] ?? ['Unknown']).join(", "),
      thumbnail: json['volumeInfo']['imageLinks']?['thumbnail'] ?? '',
    );
  }
}
