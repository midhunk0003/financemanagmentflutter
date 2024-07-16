import 'package:financemanagmentappprovider/constantes/colors.dart';
import 'package:financemanagmentappprovider/models/income_model.dart';
import 'package:financemanagmentappprovider/services/fin_service_provider.dart';
import 'package:financemanagmentappprovider/widgets/app_button.dart';
import 'package:financemanagmentappprovider/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Addincome extends StatefulWidget {
  final userid;
  const Addincome({Key? key, this.userid}) : super(key: key);

  @override
  State<Addincome> createState() => _AddincomeState();
}

class _AddincomeState extends State<Addincome> {
  TextEditingController _descController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  final _incomeKey = GlobalKey<FormState>();

  String? _selectedCategories;

  var incomeCategories = [
    'Salary/Wages',
    'Freelance/Consulting',
    'Investment Income',
    'Business Income',
    'Side Hustle',
    'Pension/Retirement',
    'Alimony/Child Support',
    'Gifts/Inheritance',
    'Royalties',
    'Savings Withdrawal',
    'Bonus/Incentives',
    'Commissions',
    'Grants/Scholarships',
    'Rental Income',
    'Dividends',
  ];

  @override
  Widget build(BuildContext context) {
    final finanprovider = Provider.of<FinanceExpAndIncomeProvider>(context);
    final String userid =
        ModalRoute.of(context)!.settings.arguments!.toString();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Income"),
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
            key: _incomeKey,
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

                  items: incomeCategories
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
                    onTap: () {
                      if (_incomeKey.currentState!.validate()) {
                        print("Add Income");
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
                            .getAllIncome(int.parse(userid))
                            .then((value) async {
                          final iu1 = value.toList();
                          final id = iu1.isEmpty ? 1 : iu1.last.id! + 1;
                          IncomeModel incom = IncomeModel(
                            id: id,
                            userid: int.parse(userid),
                            amount: double.parse(_amountController.text.trim()),
                            category: _selectedCategories,
                            description: _descController.text.trim(),
                            createdAt: DateTime.now(),
                          );
                          final added = await finanprovider.insertIncome(incom);
                          await Future.delayed(Duration(seconds: 2));
                          //loading pop
                          Navigator.pop(context);
                          if (added == true) {
                            Navigator.pop(context);
                            finanprovider.showDialogSuccess(
                                context, "EXPENSE ADDED");
                          }
                        });
                      }
                    },
                    child: Text("ADD INCOME"),
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
