import '../../models/book_model.dart';

class BookState {
  final bool isLoading;
  final List<BookModel> books;

  BookState({required this.isLoading, required this.books});
}
