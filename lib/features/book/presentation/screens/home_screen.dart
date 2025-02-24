import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/secure_storage_data.dart';
import '../providers/book_provider.dart';
import '../providers/favorite_provider.dart';
import 'favorites_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    final bookNotifier = ref.read(bookProvider.notifier);
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      bookNotifier.fetchBooks("flutter"); // Reset to default books
    }
  }

  void _searchBooks() {
    final bookNotifier = ref.read(bookProvider.notifier);
    bookNotifier.fetchBooks(_searchController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final books = ref.watch(bookProvider);
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Google Books'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoriteScreen()),
                );
              },
              icon: Icon(Icons.favorite)),
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search for books...",
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchBooks(); // Reset list
                        },
                      )
                    : Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50), // Rounded border
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              ),
              onSubmitted: (value) => _searchBooks(),
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final favorites = ref.watch(favoriteProvider);
                final booksLoading = books.isEmpty; // Assume loading if empty

                if (booksLoading) {
                  return Center(
                    child:
                        CircularProgressIndicator(), // Show loading indicator
                  );
                }
                if (books.isEmpty) {
                  return Center(
                    child: Text(
                      "No books found",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    final isFavorite = favorites.contains(book);

                    return ListTile(
                      leading: book.thumbnail.isNotEmpty
                          ? Image.network(book.thumbnail, width: 50)
                          : Icon(Icons.book, size: 50),
                      title: Text(book.title,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                      subtitle: Text(book.authors),
                      trailing: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          print("Favorite button clicked for: ${book.title}");
                          ref
                              .read(favoriteProvider.notifier)
                              .toggleFavorite(book);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
