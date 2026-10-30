import 'book.dart';
import 'library_item.dart';
import 'magazine.dart';
import 'user.dart';

class Library {
  final List<LibraryItem> _items = [];

  List<LibraryItem> get items => List.unmodifiable(_items);

  void addItem(LibraryItem item) {
    if (item.title.trim().isEmpty) {
      throw ArgumentError('A library item must have a title.');
    }
    final duplicate = _items.any((existing) =>
        existing.title.trim().toLowerCase() == item.title.trim().toLowerCase() &&
        existing.runtimeType == item.runtimeType);
    if (duplicate) {
      throw ArgumentError('An item with this title and type already exists.');
    }
    _items.add(item);
  }

  List<LibraryItem> searchByTitle(String? query) {
    if (query == null || query.trim().isEmpty) return [];
    final normalized = query.trim().toLowerCase();
    return _items
        .where((item) => item.title.toLowerCase().contains(normalized))
        .toList();
  }

  List<LibraryItem> getItemsByAuthor(String? author) {
    if (author == null || author.trim().isEmpty) return [];
    final normalized = author.trim().toLowerCase();
    return _items
        .where((item) => (item.author?.toLowerCase().contains(normalized) ?? false))
        .toList();
  }

  List<LibraryItem> getRecentItems({DateTime? since}) {
    if (since == null) return [];
    return _items
        .where((item) =>
            item.publishDate != null && !item.publishDate!.isBefore(since))
        .toList();
  }

  bool borrowItem(String title, User borrower, {DateTime? dueDate}) {
    final matches = searchByTitle(title);
    if (matches.isEmpty) return false;

    final item = matches.firstWhere(
      (candidate) => !candidate.isBorrowed,
      orElse: () => _UnavailableItem(),
    );
    if (item is _UnavailableItem) return false;

    item.borrower = borrower;
    item.dueDate = dueDate;
    return true;
  }

  bool returnItem(String title) {
    final matches = searchByTitle(title);
    if (matches.isEmpty) return false;
    final item = matches.firstWhere(
      (candidate) => candidate.isBorrowed,
      orElse: () => _UnavailableItem(),
    );
    if (item is _UnavailableItem) return false;

    item.borrower = null;
    item.dueDate = null;
    return true;
  }
}

// Internal sentinel used to avoid force-unwrapping or unsafe first-match access.
class _UnavailableItem extends LibraryItem {
  _UnavailableItem() : super(title: '');

  @override
  String get itemType => 'Unavailable';
}
