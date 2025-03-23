import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/add_expense.dart';
import '../providers/expense_provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, String> categoryEmojis = {
    '🍔 Food': '🍔',
    '🚕 Transport': '🚕',
    '🛍 Shopping': '🛍',
    '📑 Bills': '📑',
    '🎉 Entertainment': '🎉',
    '❓ Other': '❓'
  };

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final expenses = expenseProvider.expenses;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final cardColor = isDarkMode ? Colors.grey[900] : Colors.grey[200];
    
    double totalExpensesToday = expenseProvider.getTotalExpensesForDays(1);
    double totalExpensesWeek = expenseProvider.getTotalExpensesForDays(7);
    double totalExpensesMonth = expenseProvider.getTotalExpensesForDays(30);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Expense Tracker', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: bgColor,
        elevation: 0,
      ),
      backgroundColor: bgColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _buildSummaryCard("Today", totalExpensesToday, isDarkMode)),
                SizedBox(width: 8),
                Expanded(child: _buildSummaryCard("This Week", totalExpensesWeek, isDarkMode)),
                SizedBox(width: 8),
                Expanded(child: _buildSummaryCard("This Month", totalExpensesMonth, isDarkMode)),
              ],
            ),
          ),
          Expanded(
            child: expenses.isEmpty
                ? Center(
                    child: Text('No expenses added yet! 💸',
                        style: TextStyle(fontSize: 18, color: textColor)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return Card(
                        color: cardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: isDarkMode ? Colors.blueGrey : Colors.blue,
                            radius: 22,
                            child: Text(
                              categoryEmojis[expense.category] ?? '❓',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                          title: Text('₹${expense.amount.toStringAsFixed(2)}',
                              style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                    '${DateFormat.yMMMd().format(expense.date)} - ${expense.note}',
                                    style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 14),),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Delete Expense"),
                                  content: Text("Are you sure you want to delete this expense?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Provider.of<ExpenseProvider>(context, listen: false).removeExpense(index);
                                        Navigator.pop(context);
                                      },
                                      child: Text("Delete", style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/insights'),
            backgroundColor: isDarkMode ? Colors.blueGrey[800] : Colors.blue,
            child: const Icon(Icons.pie_chart, color: Colors.white),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddExpenseScreen()),
              );
            },
            backgroundColor: isDarkMode ? Colors.blueGrey[800] : Colors.blue,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          SizedBox(height: 5),
          Text('₹${amount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
        ],
      ),
    );
  }
}