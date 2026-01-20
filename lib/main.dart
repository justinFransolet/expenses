import 'package:expenses/models/expense.dart';
import 'package:expenses/pages/expense_dashboard.dart';
import 'package:expenses/pages/expense_form.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ExpensesApp());

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: hide debug banner
    // TODO: handles routes '/' and '/expense'
    // '/expense' should accept an optional Expense argument for editing
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const ExpenseDashboard(),
    );
  }
}
