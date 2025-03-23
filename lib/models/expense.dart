import 'package:hive/hive.dart';
part 'expense.g.dart';

@HiveType(typeId: 0)
class Expense {
  @HiveField(0)
  final String category;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date; // Ensure this is DateTime

  @HiveField(3)
  final String note;

  Expense({
    required this.category,
    required this.amount,
    required this.date,
    required this.note,
  });
}