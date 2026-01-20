/// Expense categories used in the application.
enum Category {
  food,
  transport,
  fun,
  bills,
}

extension CategoryLabel on Category {
  /// Get the string representation of the category.
  // TODO: make first letter uppercase
  String get label => name[0].toUpperCase() + name.substring(1);
}
