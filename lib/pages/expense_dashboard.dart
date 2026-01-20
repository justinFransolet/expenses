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
  bool _isLoading = false;
  String? _errorMessage;
  // Default to 1.0 for €
  Future<double> _rate = Future.sync(() => 1.0);

  @override
  void initState() {
    super.initState();
    _loadAllExpenses();
  }

  void _loadAllExpenses() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    DatabaseHelper.instance.readAllExpenses().then((list) {
      setState(() {
        _expenses = list;
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement';
        _isLoading = false;
      });
    });
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }
    if (_expenses.isEmpty) {
      return const Center(child: Text('Aucune dépense'));
    }
    return ListView.builder(
      itemCount: _expenses.length,
      itemBuilder: (context, index) {
        final expense = _expenses[index];
        return Dismissible(
          key: ValueKey(expense.id ?? index),
          direction: DismissDirection.startToEnd,
          onDismissed: (_) async {
            if (expense.id != null) {
              await DatabaseHelper.instance.delete(expense.id!);
            }
            setState(() {
              _expenses.removeAt(index);
            });
          },
          background: Container(
            color: Colors.redAccent,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: ListTile(
            // TODO: add category
            leading: Icon(expense.category.icon),
            title: Text(expense.title),
            subtitle: Text(expense.category.label),
            trailing: Text('${expense.amount.toStringAsFixed(2)} €'),
            onTap: () async {
              final updated = await Navigator.pushNamed(context, '/expense', arguments: expense);
              if (updated != null && updated is Expense) {
                await DatabaseHelper.instance.update(updated);
                _loadAllExpenses();
              }
            },
          ),
        );
      },
    );
  }
}
