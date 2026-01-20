import 'package:expenses/models/category.dart';
import 'package:expenses/models/expense.dart';
import 'package:expenses/viewmodels/category_icon.dart';
import 'package:flutter/material.dart';
import '../services/database_helper.dart';

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
    _titleController = TextEditingController(text: widget.expense != null ? widget.expense!.title : '');
    _amountController = TextEditingController(text: widget.expense != null ? widget.expense!.amount.toString() : '');
    _selectedCategory = widget.expense != null ? widget.expense!.category : Category.food;

  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final normalized = _amountController.text.replaceAll(',', '.');
      final parsed = double.tryParse(normalized) ?? 0.0;

      final updatedExpense = Expense(
        id: widget.expense?.id,
        title: _titleController.text.trim(),
        amount: parsed,
        category: _selectedCategory,
      );

      try {
        await DatabaseHelper.instance.save(updatedExpense);
        Navigator.pop(context, updatedExpense);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la sauvegarde')),
        );
      }
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
              // Title field (validation non vide)
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le titre ne peut pas être vide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Amount field (validation nombre valide > 0)
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Montant'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le montant est requis';
                  }
                  final normalized = value.replaceAll(',', '.');
                  final parsed = double.tryParse(normalized);
                  if (parsed == null) {
                    return 'Entrez un nombre valide';
                  }
                  if (parsed <= 0) {
                    return 'Le montant doit être supérieur à 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Category selection
              DropdownButtonFormField<Category>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Catégorie'),
                items: Category.values.map((c) {
                  return DropdownMenuItem<Category>(
                    value: c,
                    child: Row(
                        children: [
                          Icon(c.icon),
                          const SizedBox(width: 8),
                          Text(c.label),
                        ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedCategory = value);
                },
              ),
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
