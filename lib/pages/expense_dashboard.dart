import 'package:expenses/models/category.dart';
import 'package:expenses/models/expense.dart';
import 'package:expenses/services/currency_service.dart';
import 'package:expenses/services/database_helper.dart';
import 'package:expenses/viewmodels/category_icon.dart';
import 'package:flutter/material.dart';

/// Dashboard page displaying the list of expenses and total sum with currency
/// conversion.
class ExpenseDashboard extends StatefulWidget {
  const ExpenseDashboard({super.key});

  @override
  State<ExpenseDashboard> createState() => _ExpenseDashboardState();
}

class _ExpenseDashboardState extends State<ExpenseDashboard> {
  late Future<List<Expense>> _expensesFuture;
  List<Expense> _expenses = [];
  // Default to 1.0 for €
  Future<double> _rate = Future.sync(() => 1.0);

  @override
  void initState() {
    super.initState();
    // TODO: remove dummy initialization of _expenses and initialize _expensesFuture from database instead
    _expenses = [
      Expense(title: "Bogus expense 1", amount: 10.0, category: Category.food),
      Expense(
        title: "Bogus expense 2",
        amount: 20.0,
        category: Category.transport,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expenses')),
      // TODO: handle loading, errors, and initialize _expenses from _expensesFuture
      body: Column(
        children: [
          _buildSummaryCard(), // Total sum display
          // TODO: replace SizedBox with something else to occupy remaining vertical space
          SizedBox(height: 100, child: _buildExpenseList()), // Expenses list
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newExpense = await Navigator.pushNamed(context, '/expense');
          if (newExpense != null && newExpense is Expense) {
            // TODO: save newExpense to database and refresh this widget
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard() {
    // TODO: compute total expense in €
    final total = 0.0;
    return Card(
      margin: const EdgeInsets.all(16.0),
      // TODO: implement expense total card with currency conversion
      // Don't forget to handle aysnchronous loading of exchange rate.
      // If rate is not available, show 'N/A' instead of the total amount.
      child: Placeholder(fallbackHeight: 150),
    );
  }

  Widget _buildExpenseList() {
    // TODO: implement expense deletion by swiping list item to the left
    // TODO: implement expense edition by tapping on a list item (using a named route)
    return ListView.builder(
      itemCount: _expenses.length,
      itemBuilder: (context, index) {
        final expense = _expenses[index];
        return ListTile(
          // TODO: add category
          title: Text(expense.title),
          trailing: Text('${expense.amount.toStringAsFixed(2)} €'),
        );
      },
    );
  }
}
