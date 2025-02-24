import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_sources/book_local_data_source/db_local_service.dart';
import '../../models/book_model.dart';

final favoriteProvider =
StateNotifierProvider<FavoriteNotifier, List<BookModel>>((ref) {
  return FavoriteNotifier();
});

class FavoriteNotifier extends StateNotifier<List<BookModel>> {
  final FavoriteDatabaseHelper _dbHelper = FavoriteDatabaseHelper();

  FavoriteNotifier() : super([]) {
    loadFavorites();
  }

  /// Load favorites from database when initialized
  Future<void> loadFavorites() async {
    final favorites = await _dbHelper.getFavorites();
    state = [...favorites]; // Ensure state updates properly
  }

  /// Toggle favorite status and update database
  Future<void> toggleFavorite(BookModel book) async {
    final isAlreadyFavorite = state.any((b) => b.id == book.id);

    if (isAlreadyFavorite) {
      await _dbHelper.removeFavorite(book.id);
      state = state.where((b) => b.id != book.id).toList();
      print("Removed from favorites: ${book.title}");
    } else {
      await _dbHelper.addFavorite(book);
      state = [...state, book]; // Ensure new list is created
      print("Added to favorites: ${book.title}");
    }

    // Force a state update to trigger rebuild
    state = List.from(state);

    // Print the updated list of favorites
    printFavorites();
  }

  void printFavorites() {
    print("Favorite Books:");
    if (state.isEmpty) {
      print("No favorite books yet.");
    } else {
      for (var book in state) {
        print("Title: ${book.title}, Author: ${book.authors}");
      }
    }
  }

  /// Check if a book is favorite
  bool isFavorite(String bookId) {
    return state.any((book) => book.id == bookId);
  }
}
