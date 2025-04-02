import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/insights_screen.dart';
import 'screens/add_expense.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/expense.dart';
import 'providers/expense_provider.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  try {
    Hive.registerAdapter(ExpenseAdapter());
    final expenseBox = await Hive.openBox<Expense>('expenses');
    runApp(ExpenseTrackerApp(expenseBox: expenseBox));
  } catch (e) {
    debugPrint('Error initializing Hive: $e');
  }
}

class ExpenseTrackerApp extends StatelessWidget {
  final Box<Expense> expenseBox;

  const ExpenseTrackerApp({super.key, required this.expenseBox});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseProvider(expenseBox),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
        ),
        home: HomeScreen(),
        routes: {
          '/add-expense': (context) => AddExpenseScreen(),
          '/insights': (context) => InsightsScreen(),
        },
      ),
    );
  }
}