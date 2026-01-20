import 'package:expenses/models/expense.dart';
import 'package:expenses/pages/expense_dashboard.dart';
import 'package:expenses/pages/expense_form.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ExpensesApp());

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    // '/expense' should accept an optional Expense argument for editing
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const ExpenseDashboard(),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute<void>(
              builder: (_) => const ExpenseDashboard(),
              settings: settings,
            );
          case '/expense':
            final expense = settings.arguments as Expense?;
            return MaterialPageRoute<void>(
              builder: (_) => ExpenseFormPage(expense: expense),
              settings: settings,
            );
          default:
            return MaterialPageRoute<void>(
              builder: (_) => const ExpenseDashboard(),
              settings: settings,
            );
        }
      },
    );
  }
}
