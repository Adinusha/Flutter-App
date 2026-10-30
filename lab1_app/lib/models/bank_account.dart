
class BankAccount {
  late String accountNumber;
  bool _isInitialized = false;

  final String holderName;
  double balance;
  final String? bankBranch;

  BankAccount({
    required this.holderName,
    this.balance = 0.0,
    this.bankBranch,
  });

  void initializeAccount(String number) {
    final normalized = number.trim();

    if (normalized.isEmpty) {
      throw ArgumentError('Account number cannot be empty.');
    }

    accountNumber = normalized;
    _isInitialized = true;
  }

  bool isAccountNumberSet() {
    return _isInitialized;
  }

  String getDisplayAccountNumber() {
    return isAccountNumberSet()
        ? accountNumber
        : 'Not initialized';
  }

  String getDisplayBranch() {
    return bankBranch ?? 'N/A';
  }
}
