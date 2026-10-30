import 'library_item.dart';

class Magazine extends LibraryItem {
  final int? issueNumber;
  final String? publisher;

  Magazine({
    required super.title,
    super.author,
    super.publishDate,
    super.borrower,
    super.dueDate,
    this.issueNumber,
    this.publisher,
  });

  @override
  String get itemType => 'Magazine';

  @override
  String get details =>
      '${super.details} • Issue: ${issueNumber?.toString() ?? "Not provided"} • Publisher: ${publisher ?? "Not provided"}';
}
