import 'package:timesheets/configurations/configurations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class BookListPage extends StatelessWidget {
  const BookListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final books = [1, 2, 3, 4];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book List'),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) => ListTile(
          onTap: () => context.navigateTo(
            BookDetailsRoute(
              bookId: books[index],
            ),
          ),
          title: Text(books[index].toString()),
        ),
      ),
    );
  }
}