import 'package:dio/dio.dart';

import '../../../models/book_model.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<BookModel>> fetchBooks(String query) async {
    try {
      final url = 'https://www.googleapis.com/books/v1/volumes?q=$query';
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List books = response.data['items'] ?? [];
        return books.map((book) => BookModel.fromJson(book)).toList();
      }
    } catch (e) {
      print("Error fetching books: $e");
    }
    return [];
  }
}