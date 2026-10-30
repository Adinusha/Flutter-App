import 'package:flutter/material.dart';

import 'models/bank_account.dart';
import 'models/book.dart';
import 'models/library.dart';
import 'models/library_item.dart';
import 'models/magazine.dart';
import 'models/user.dart';

void main() => runApp(const LabTwoApp());

class LabTwoApp extends StatelessWidget {
  const LabTwoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADMD Lab2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LabHomePage(),
    );
  }
}

class LabHomePage extends StatefulWidget {
  const LabHomePage({super.key});

  @override
  State<LabHomePage> createState() => _LabHomePageState();
}

class _LabHomePageState extends State<LabHomePage> {
  final List<User> users = [
    User(name: 'Mairal Miral', age: 21, email: 'mairal@email.com'),
    User(name: 'MirceaCe lBatran', age: 19),
    User(name: 'Stanescu Lata'),
  ];

  late final List<BankAccount> accounts = _createAccounts();
  late final Library library = _createLibrary();

  List<BankAccount> _createAccounts() {
    final first = BankAccount(
      holderName: 'Mairal Miral',
      balance: 1250.50,
      bankBranch: 'Bucharest',
    )..initializeAccount('RO-1001');

    final second = BankAccount(
      holderName: 'MirceaCe lBatran',
      bankBranch: null,
    )..initializeAccount('RO-1002');

// Demonstrates a late field that has not yet been initialized.
    final third = BankAccount(holderName: 'Stanescu Lata');

    return [first, second, third];
  }

  Library _createLibrary() {
    final result = Library();
    result.addItem(Book(
      title: 'Cum sa?',
      author: 'Adina Druica',
      publishDate: DateTime(2025, 3, 12),
      pageCount: 240,
      isbn: '978-1-23456-789-0',
    ));
    result.addItem(Book(
      title: 'Azi maine, maine azi',
      author: 'Adina Druica',
      publishDate: DateTime(2024, 8, 4),
      pageCount: null,
    ));
    result.addItem(Magazine(
      title: 'Te pui cu saracii?',
      author: null,
      publishDate: DateTime(2026, 1, 15),
      issueNumber: 18,
      publisher: 'Tech Press',
    ));
    return result;
  }

  void _toggleBorrow(LibraryItem item) {
    setState(() {
      if (item.isBorrowed) {
        library.returnItem(item.title);
      } else {
        library.borrowItem(
          item.title,
          users.first,
          dueDate: DateTime.now().add(const Duration(days: 14)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final recentItems =
        library.getRecentItems(since: DateTime(2025, 1, 1));

    return Scaffold(
      appBar: AppBar(title: const Text('ADMD Lab 2 — Dart & Null Safety')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Users', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...users.map((user) => Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(user.name),
                  subtitle: Text(
                    'Age: ${user.getDisplayAge()}\n'
                    'Email: ${user.email ?? "Not provided"}',
                  ),
                  isThreeLine: true,
                ),
              )),
          const Divider(height: 32),
          Text('Bank accounts',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...accounts.map((account) => Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.account_balance)),
                  title: Text(account.holderName),
                  subtitle: Text(
                    'Account: ${account.getDisplayAccountNumber()}\n'
                    'Branch: ${account.getDisplayBranch()}\n'
                    'Balance: ${account.balance.toStringAsFixed(2)}',
                  ),
                  isThreeLine: true,
                ),
              )),
          const Divider(height: 32),
          Text('Library',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('${library.items.length} items • ${recentItems.length} recent since 2025'),
          const SizedBox(height: 8),
          ...library.items.map((item) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(item is Book ? Icons.menu_book : Icons.article),
                  ),
                  title: Text(item.title),
                  subtitle: Text(
                    '${item.details}\n'
                    '${item.isBorrowed ? "Borrowed by: ${item.borrower?.name ?? "Unknown"}" : "Available"}'
                    '${item.dueDate == null ? "" : "\nDue: ${item.dueDate!.toLocal().toString().split(" ").first}"}',
                  ),
                  isThreeLine: true,
                  trailing: TextButton(
                    onPressed: () => _toggleBorrow(item),
                    child: Text(item.isBorrowed ? 'Return' : 'Borrow'),
                  ),
                ),
              )),
          const SizedBox(height: 8),
          
        ],
      ),
    );
  }
}


