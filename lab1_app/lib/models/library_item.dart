import 'user.dart';

abstract class LibraryItem {
  final String title;
  final String? author;
  final DateTime? publishDate;
  User? borrower;
  DateTime? dueDate;

  LibraryItem({
    required this.title,
    this.author,
    this.publishDate,
    this.borrower,
    this.dueDate,
  });

  bool get isBorrowed => borrower != null;

  String get itemType;

  String get details {
    final authorText = author ?? 'Not provided';
    final dateText = publishDate == null
        ? 'Not provided'
        : '${publishDate!.year}-${publishDate!.month.toString().padLeft(2, '0')}-${publishDate!.day.toString().padLeft(2, '0')}';
    return '$itemType • Author: $authorText • Published: $dateText';
  }
}
