import 'package:expenses/models/category.dart';

/// A model class representing an expense item.
class Expense {
  /// Unique identifier for the expense (nullable for new entries).
  final int? id;

  /// Title or description of the expense.
  final String title;

  /// Amount spent in the expense (in €).
  final double amount;

  /// Category of the expense (e.g., Food, Transport).
  final Category category;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
  });

  /// Convert an Expense into a Map. The keys must match the database columns.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category.index,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    final catRaw = map['category'];

    Category category;
    if (catRaw >= 0 && catRaw < Category.values.length) {
      category = Category.values[catRaw];
    } else {
      category = Category.food;
    }

    return Expense(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      amount: map['amount'],
      category: category,
    );
  }
}
