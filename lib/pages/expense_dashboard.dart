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
  List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _errorMessage;

  final List<Map<String, String>> _availableCurrencies = [
  {'code': 'EUR', 'symbol': '€'},
  {'code': 'USD', 'symbol': r'$'},
  {'code': 'GBP', 'symbol': '£'},
  {'code': 'JPY', 'symbol': '¥'},
  ];

  late String _selectedCurrencyCode;
  String get _selectedCurrencySymbol =>
      _availableCurrencies.firstWhere((c) => c['code'] == _selectedCurrencyCode)['symbol']!;

  late Future<double> _rate;

  @override
  void initState() {
    super.initState();
    _selectedCurrencyCode = _availableCurrencies.first['code']!;
    _rate = Future.sync(() => 1.0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllExpenses();
    });
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

  void _onCurrencyChanged(String? newCode) {
    if (newCode == null || newCode == _selectedCurrencyCode) return;
    setState(() {
      _selectedCurrencyCode = newCode;
      _rate = CurrencyService.getExchangeRate('EUR', _selectedCurrencyCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expenses')),
      body: Column(
        children: [
          _buildSummaryCard(), // Total sum display
          Expanded(child: _buildExpenseList()), // Expenses list
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newExpense = await Navigator.pushNamed(context, '/expense');
          if (newExpense != null && newExpense is Expense) {
            _loadAllExpenses();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final total = _expenses.fold<double>(0.0, (sum, e) => sum + e.amount);

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: FutureBuilder<double>(
          future: _rate,
          builder: (context, snapshot) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Total dépensé', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      _buildConvertedAmount(snapshot, total),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCurrencyCode,
                      items: _availableCurrencies.map((c) {
                        return DropdownMenuItem<String>(
                          value: c['code'],
                          child: Text(c['symbol']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        );
                      }).toList(),
                      onChanged: _onCurrencyChanged,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildConvertedAmount(AsyncSnapshot<double> snapshot, double total) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    final rate = snapshot.data ?? 0.0;
    final converted = (total * rate).toStringAsFixed(2);

    return Text(
      '$converted $_selectedCurrencySymbol',
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      overflow: TextOverflow.ellipsis, // anti-overflow
    );
  }

  Widget _buildExpenseList() {
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
          direction: DismissDirection.endToStart,
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
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: ListTile(
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
