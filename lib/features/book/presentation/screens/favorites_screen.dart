import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/favorite_provider.dart';


class FavoriteScreen extends ConsumerStatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(favoriteProvider.notifier).loadFavorites()); // Ensure data loads
  }

  @override
  Widget build(BuildContext context) {
    final favoriteBooks = ref.watch(favoriteProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Favorite Books')),
      body: favoriteBooks.isEmpty
          ? Center(child: Text('No favorites yet.'))
          : ListView.builder(
        itemCount: favoriteBooks.length,
        itemBuilder: (context, index) {
          final book = favoriteBooks[index];
          return ListTile(
            leading: book.thumbnail.isNotEmpty
                ? Image.network(book.thumbnail, width: 50)
                : Icon(Icons.book, size: 50),
            title: Text(book.title),
            subtitle: Text(book.authors),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                ref.read(favoriteProvider.notifier).toggleFavorite(book);
              },
            ),
          );
        },
      ),
    );
  }
}
