import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  final Box<Expense> _expenseBox;

  // Update the constructor to accept the expenseBox
  ExpenseProvider(this._expenseBox);

  List<Expense> get expenses => _expenseBox.values.toList();

  void addExpense(Expense expense) {
    _expenseBox.add(expense);
    notifyListeners();
  }

  void removeExpense(int index) {
    _expenseBox.deleteAt(index);
    notifyListeners();
  }

  double getTotalExpensesForDays(int days) {
  DateTime now = DateTime.now();
  DateTime cutoffDate = DateTime(now.year, now.month, now.day).subtract(Duration(days: days - 1));

  return expenses
      .where((expense) => expense.date.isAfter(cutoffDate))
      .fold(0.0, (sum, expense) => sum + expense.amount);
}

  Map<String, double> getCategoryWiseExpenses() {
    Map<String, double> categoryTotals = {};

    for (var expense in expenses) {
      categoryTotals.update(expense.category, (value) => value + expense.amount,
          ifAbsent: () => expense.amount);
    }

    return categoryTotals;
  }
}