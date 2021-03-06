import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../../data/models/currency.dart';
import '../../data/models/project.dart';
import '../../data/models/user.dart';
import '../../data/models/user_expense.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();
}

class GetExpensesEvent extends ExpenseEvent {
  final Project project;

  const GetExpensesEvent(this.project);

  @override
  List<Object> get props => [project];
}

class DeleteExpenseEvent extends ExpenseEvent {
  final int expenseId;

  const DeleteExpenseEvent(this.expenseId);

  @override
  List<Object> get props => [expenseId];
}

class AddExpenseEvent extends ExpenseEvent {
  final Project project;
  final Decimal amount;
  final String description;
  final Currency currency;
  final User user;
  final List<User> receivers;
  final DateTime dateTime;

  const AddExpenseEvent(
      {@required this.project,
      @required this.amount,
      @required this.description,
      @required this.currency,
      @required this.user,
      @required this.receivers,
      @required this.dateTime});

  @override
  List<Object> get props =>
      [project, amount, description, currency, user, receivers, dateTime];
}

class ModifyExpenseEvent extends ExpenseEvent {
  final UserExpense expense;

  const ModifyExpenseEvent(this.expense);

  @override
  List<Object> get props => [expense];
}
