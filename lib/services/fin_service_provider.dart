import 'dart:ffi';

import 'package:financemanagmentappprovider/models/expense_model.dart';
import 'package:financemanagmentappprovider/models/income_model.dart';
import 'package:financemanagmentappprovider/services/auth_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinanceExpAndIncomeProvider extends ChangeNotifier {
  // box income
  Box<IncomeModel>? _incomeBox;
  Future<void> openBoxIncome() async {
    _incomeBox = await Hive.openBox('userincome');
  }

  Future<void> clearBoxinc() async {
    _incomeBox = await Hive.openBox('userincome');
    print(_incomeBox!.values);
    _incomeBox!.clear();
  }

  //box expense
  Box<ExpenseModel>? _expenseBox;
  Future<void> openBoxExpense() async {
    _expenseBox = await Hive.openBox('userexpense');
  }

  Future<void> clearBoxexp() async {
    _expenseBox = await Hive.openBox('userexpense');
    print(_expenseBox!.values);
    _expenseBox!.clear();
  }

  bool _successexp = false;
  bool _successincome = false;

  bool get successexp => _successexp;
  bool get successincome => _successincome;

  double _totalIncome = 0.0;
  double _totalExpense = 0.0;

  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;

  FinanceExpAndIncomeProvider() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    print("123344${totalIncome}");
    await openBoxIncome();
    await openBoxExpense();
    await _claculateTotalIncome(null);
    await _claculateTotalExpense(null);
  }

  Future<void> calculateinitialTotalIncom(int? userid) async {
    await _claculateTotalIncome(userid);
    notifyListeners();
  }

  Future<void> calculateinitialTotalExpense(int? userid) async {
    await _claculateTotalExpense(userid);
    notifyListeners();
  }

  //insert function income
  Future<bool> insertIncome(IncomeModel income) async {
    if (_incomeBox == null) {
      await openBoxIncome();
    }
    await _incomeBox!.add(income);
    await _claculateTotalIncome(income.userid);
    notifyListeners();
    print(_incomeBox!.values.toList());
    _successincome = true;
    notifyListeners();
    return true;
  }

  //get all income perticular user
  Future<List<IncomeModel>> getAllIncome(int? userid) async {
    if (_incomeBox == null) {
      await openBoxIncome();
    }
    final shar = await SharedPreferences.getInstance();
    final id = await shar.getInt('id');
    print("id get first : ${id}");
    return _incomeBox!.values
        .where((income) =>
            userid == null ? income.userid == id : income.userid == userid)
        .toList();
  }

  //insert function expense
  Future<bool> insertExpense(ExpenseModel expense) async {
    if (_expenseBox == null) {
      await openBoxExpense();
    }
    await _expenseBox!.add(expense);
    await _claculateTotalExpense(expense.userid);
    notifyListeners();
    print(_expenseBox!.values.toList());
    _successexp = true;
    notifyListeners();
    return true;
  }

  //get all income perticular user
  Future<List<ExpenseModel>> getAllExpense(int? userid) async {
    print("getid : ${userid}");
    final shar = await SharedPreferences.getInstance();
    final id = await shar.getInt('id');
    print("id get first : ${id}");
    if (_expenseBox == null) {
      await openBoxExpense();
    }
    // Add null check
    if (_expenseBox == null) {
      throw Exception("Failed to open expense box");
    }
    print("expnn : ${_expenseBox!.values.toList()}");
    final loginuser = _expenseBox!.values
        .where((expense) =>
            userid == null ? expense.userid == id : expense.userid == userid)
        .toList();
    print(loginuser);
    notifyListeners();
    return loginuser;
  }

  //totoal income for perticular user

  Future<void> _claculateTotalIncome(int? userid) async {
    final List<IncomeModel> incomes = await getAllIncome(userid);
    _totalIncome = incomes.fold(
        0.0, (previousValue, income) => previousValue + income.amount!);
    notifyListeners();
  }

  //totoal expense for perticular user

  Future<void> _claculateTotalExpense(int? userid) async {
    final List<ExpenseModel> expenses = await getAllExpense(userid);
    _totalExpense = expenses.fold(
        0.0, (previousValue, expense) => previousValue + expense.amount!);
    notifyListeners();
  }

  Future<bool> deleteUserExpense(int? exid, BuildContext context) async {
    if (_expenseBox == null) {
      await openBoxExpense();
    }

    final expenseKey = _expenseBox!.keys.firstWhere((key) {
      final expen = _expenseBox!.get(key);
      return expen!.id == exid;
    }, orElse: () => null);

    if (expenseKey != null) {
      await _expenseBox!.delete(expenseKey);
      await calculateinitialTotalExpense(exid);
      _showDialog(context);
      notifyListeners();
      print('Expense with id $exid deleted successfully.');
      return true;
    } else {
      print('Expense with id $exid not found.');
      return false;
    }
  }

  Future<bool> deleteUserIncom(int? incid, BuildContext context) async {
    print(444444444444);
    if (_incomeBox == null) {
      await openBoxIncome();
    }

    final incomekey = _incomeBox!.keys.firstWhere((key) {
      final incom = _incomeBox!.get(key);
      return incom!.id == incid;
    }, orElse: () => null);

    if (incomekey != null) {
      await _incomeBox!.delete(incomekey);
      await calculateinitialTotalIncom(incid);
      _showDialog(context);
      notifyListeners();
      print('Expense with id $incid deleted successfully.');
      return true;
    } else {
      print('Expense with id $incid not found.');
      return false;
    }
  }

//delete  diloge box
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Schedule the dialog to close after 2 seconds
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });

        return Center(
          child: Container(
            height: 200,
            width: 200,
            child: Column(
              children: [
                Lottie.asset(
                  'assets/json/delete.json',
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "DELETE  SUCCESS",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  //

  //Success insert   diloge box
  void showDialogSuccess(BuildContext context, String nameex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Schedule the dialog to close after 2 seconds
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });

        return Center(
          child: Container(
            height: 200,
            width: 200,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Lottie.asset(
                    'assets/json/success.json',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
