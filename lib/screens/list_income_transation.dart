import 'package:financemanagmentappprovider/models/income_model.dart';
import 'package:financemanagmentappprovider/services/auth_service_provider.dart';
import 'package:financemanagmentappprovider/services/fin_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListIncomeTransation extends StatefulWidget {
  const ListIncomeTransation({Key? key}) : super(key: key);

  @override
  _ListIncomeTransationState createState() => _ListIncomeTransationState();
}

class _ListIncomeTransationState extends State<ListIncomeTransation> {
  void initState() {
    print(123);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData(context);
    });
  }

  Future<void> _fetchInitialData(BuildContext context) async {
    print(123);
    final finService =
        Provider.of<FinanceExpAndIncomeProvider>(context, listen: false);
    final authService =
        Provider.of<AuthServiceProvider>(context, listen: false);

    final userModel = await authService.getCurrentUser();
    if (userModel != null) {
      finService.getAllIncome(userModel.id);
      finService.calculateinitialTotalIncom(userModel.id);
      finService.calculateinitialTotalExpense(userModel.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final finservice =
        Provider.of<FinanceExpAndIncomeProvider>(context, listen: false);
    final authservice =
        Provider.of<AuthServiceProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("LIST OF INCOME"),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bgimg.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder(
              future: authservice.getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    final userdata = snapshot.data;
                    return FutureBuilder<List<IncomeModel>>(
                      future: finservice.getAllIncome(userdata!.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          if (snapshot.hasData) {
                            final List<IncomeModel> income = snapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Total Expense : ${finservice.totalIncome}",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                  overflow: TextOverflow
                                      .ellipsis, // This will add ellipsis (...) at the end
                                  maxLines:
                                      1, // This limits the text to a single line
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Divider(
                                  color: Colors.green,
                                  thickness: 2,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: income.length,
                                    itemBuilder: (context, index) {
                                      final inco = income[index];
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Adjust the radius as needed
                                          side: BorderSide(
                                            // color: const Color.fromARGB(
                                            //     255, 33, 243, 68), // Border color
                                            width: 2.0,
                                            // Border width
                                          ),
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return Center(
                                                  child: Container(
                                                    height: 300,
                                                    width: 250,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 1,
                                                          blurRadius: 5,
                                                          offset: Offset(0,
                                                              3), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Text(
                                                            "Category : ${inco.category}"),
                                                        Text(
                                                            "Description : ${inco.description}"),
                                                        Text(
                                                            "Amount : ${inco.amount}"),
                                                        Text("Date And Time"),
                                                        Text(
                                                            "${inco.createdAt}"),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                finservice
                                                                    .getAllIncome(
                                                                        inco.userid);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Icon(Icons
                                                                  .backspace),
                                                            ),
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                Navigator.pop(
                                                                    context);
                                                                await finservice
                                                                    .deleteUserIncom(
                                                                  inco.id,
                                                                  context,
                                                                );
                                                                setState(() {
                                                                  _fetchInitialData(
                                                                      context);
                                                                });
                                                              },
                                                              child: Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Icon(
                                                                Icons.edit,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          title: Text("${inco.category}"),
                                          subtitle: Text("${inco.amount} Rs"),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
