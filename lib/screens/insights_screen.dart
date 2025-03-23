import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/expense_provider.dart';

class InsightsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final categoryExpenses = expenseProvider.getCategoryWiseExpenses();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Insights', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: bgColor,
      ),
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: categoryExpenses.isEmpty
                  ? Center(
                      child: Text('No data available! 📉',
                          style: TextStyle(fontSize: 18, color: textColor)),
                    )
                  : PieChart(
                      PieChartData(
                        sections: categoryExpenses.entries.map((entry) {
                          return PieChartSectionData(
                            value: entry.value,
                            title: entry.key,
                            color: Colors.primaries[entry.key.hashCode % Colors.primaries.length],
                            radius: 80,
                            titleStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}