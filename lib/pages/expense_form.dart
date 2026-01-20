import 'package:expenses/models/category.dart';
import 'package:expenses/models/expense.dart';
import 'package:expenses/viewmodels/category_icon.dart';
import 'package:flutter/material.dart';

/// Form page for creating or editing an expense.
class ExpenseFormPage extends StatefulWidget {
  /// The expense to edit; null if creating a new expense.
  final Expense? expense;

  const ExpenseFormPage({super.key, this.expense});

  @override
  State<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends State<ExpenseFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the input fields
  late TextEditingController _titleController;
  late TextEditingController _amountController;

  Category _selectedCategory = Category.food;

  @override
  void initState() {
    super.initState();
    // TODO: initialize controllers with existing data if editing, else empty
    // TODO: initialize _selectedCategory (default to food if creating new)
  }

  @override
  void dispose() {
    // TODO: cleanup
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Create a new Expense object (preserving the ID if editing)
      final updatedExpense = Expense(
        id: widget.expense?.id,
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
      );

      // Return the object to the previous screen
      Navigator.pop(context, updatedExpense);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expense != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Expense' : 'Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // TODO: TextFormField for title (with validation for non-empty)
              const SizedBox(height: 16),
              // TODO: TextFormField for amount (with validation for valid number)
              const SizedBox(height: 16),
              // TODO: DropdownButtonFormField for category selection
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(isEditing ? 'Update Expense' : 'Create Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
