import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class BookDetailsPage extends StatelessWidget {
  const BookDetailsPage({
    super.key,
    @pathParam required this.bookId,
  });
  final int bookId;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Book details'),
        ),
        body: Center(
          child: Text(
            bookId.toString(),
          ),
        ),
      );
}
