import 'package:financemanagmentappprovider/constantes/colors.dart';
import 'package:financemanagmentappprovider/models/expense_model.dart';
import 'package:financemanagmentappprovider/services/fin_service_provider.dart';
import 'package:financemanagmentappprovider/widgets/app_button.dart';
import 'package:financemanagmentappprovider/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class AddExpense extends StatefulWidget {
  final userid;
  const AddExpense({Key? key, this.userid}) : super(key: key);

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController _descController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  final _expenseKey = GlobalKey<FormState>();

  String? _selectedCategories;

  var expenseCategories = [
    'Housing',
    'Transportation',
    'Food and Groceries',
    'Healthcare',
    'Debt Payments',
    'Entertainment',
    'Personal Care',
    'Clothing and Accessories',
    'Utilities and Bills',
    'Savings and Investments',
    'Education',
    'Travel',
  ];
  @override
  Widget build(BuildContext context) {
    final finanprovider = Provider.of<FinanceExpAndIncomeProvider>(context);
    final String userid =
        ModalRoute.of(context)!.settings.arguments!.toString();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Expense"),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bgimg.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.all(20),
          child: Form(
            key: _expenseKey,
            child: Column(
              children: [
                DropdownButtonFormField(
                  dropdownColor: ScaffoldColor,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: "Select Category",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 253, 251,
                              251)), // Color when the dropdown is not focused
                      borderRadius: BorderRadius.circular(
                          10), // Add border radius if needed
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .blue), // Color when the dropdown is focused
                      borderRadius: BorderRadius.circular(5),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey), // Default border color
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  // elevation: 8,

                  icon: Icon(Icons.arrow_downward),
                  borderRadius: BorderRadius.circular(5),
                  value: _selectedCategories,
                  hint: Text(
                    'Select Category',
                    style: TextStyle(color: Colors.white),
                  ),

                  items: expenseCategories
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      print(newValue);
                      _selectedCategories = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Description is Mandatory";
                      } else {
                        return null;
                      }
                    },
                    controller: _descController,
                    hintText: "Description"),
                SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                    type: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter a Valid Amount";
                      } else {
                        return null;
                      }
                    },
                    controller: _amountController,
                    hintText: "Enter the Amount"),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: AppButton(
                    height: 50,
                    width: 250,
                    color: Color.fromARGB(255, 6, 212, 99),
                    onTap: () async {
                      if (_expenseKey.currentState!.validate()) {
                        print("Add expense");
                        print("user id expense : ${userid}");
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return Center(
                              child: Container(
                                height: 200,
                                width: 200,
                                child: Lottie.asset(
                                  'assets/json/loading.json',
                                ),
                              ),
                            );
                          },
                        );
                        finanprovider
                            .getAllExpense(int.parse(userid))
                            .then((value) async {
                          final iu1 = value.toList();
                          final id = iu1.isEmpty ? 1 : iu1.last.id! + 1;
                          ExpenseModel exp = ExpenseModel(
                            id: id,
                            userid: int.parse(userid),
                            amount: double.parse(_amountController.text.trim()),
                            category: _selectedCategories,
                            description: _descController.text.trim(),
                            createdAt: DateTime.now(),
                          );
                          final added = await finanprovider.insertExpense(exp);
                          await Future.delayed(Duration(seconds: 2));
                          //loading pop
                          Navigator.pop(context);
                          if (added == true) {
                            Navigator.pop(context);
                            finanprovider.showDialogSuccess(
                                context, "EXPENSE ADDED");
                          }
                        });

                        // finanprovider.getAllExpense(int.parse(userid));
                      }
                    },
                    child: Text("ADD EXPENSE"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
