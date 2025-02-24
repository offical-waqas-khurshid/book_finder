import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_sources/book_remote_data_source/api_services.dart';
import '../../models/book_model.dart';

final bookProvider = StateNotifierProvider<BookNotifier, List<BookModel>>((ref) {
  return BookNotifier();
});

class BookNotifier extends StateNotifier<List<BookModel>> {
  final ApiService _apiService = ApiService();

  BookNotifier() : super([]) {
    fetchBooks("flutter");
  }

  Future<void> fetchBooks(String query) async {
    state = [];
    final books = await _apiService.fetchBooks(query);
    state = books;
  }

}