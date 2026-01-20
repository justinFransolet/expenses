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

  /// Convert a Map into an Expense.
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      // TODO: deduce category from index, reverse of toMap operation
      category: Category.food,
    );
  }
}
