import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;

  final List<String> _categories = [
    "🍔 Food",
    "🚕 Transport",
    "🛍 Shopping",
    "📑 Bills",
    "🎉 Entertainment",
    "❓ Other",
  ];

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitExpense() {
    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    final note = _noteController.text.trim();

    if (_selectedCategory == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a category and enter a valid amount")),
      );
      return;
    }

    Provider.of<ExpenseProvider>(context, listen: false).addExpense(
      Expense(
        category: _selectedCategory!,
        amount: amount,
        date: _selectedDate,
        note: note,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("➕ Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "📌 Category",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 26),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: "💰 Amount",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 26),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: "📝 Note (optional)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "📅 Date: ${_selectedDate.toLocal()}".split(' ')[0],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text("Select Date"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitExpense,
                  child: const Text("✅ Add Expense"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}