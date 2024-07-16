import 'package:financemanagmentappprovider/models/user_model.dart';
import 'package:financemanagmentappprovider/services/auth_service_provider.dart';
import 'package:financemanagmentappprovider/services/fin_service_provider.dart';
import 'package:financemanagmentappprovider/widgets/dashboard_widget.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void initState() {
    print(123);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _fetchInitialData(context);
      });
    });
  }

  Future<void> _fetchInitialData(BuildContext context) async {
    final finService =
        Provider.of<FinanceExpAndIncomeProvider>(context, listen: false);
    final authService =
        Provider.of<AuthServiceProvider>(context, listen: false);
    final userModel = await authService.getCurrentUser();
    if (userModel != null) {
      finService.calculateinitialTotalIncom(userModel.id);
      finService.calculateinitialTotalExpense(userModel.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final finanprovider = Provider.of<FinanceExpAndIncomeProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("FINANCE MANAGMENT")),
        ),
        body: Consumer<AuthServiceProvider>(
          builder: (context, authService, child) {
            return FutureBuilder<UserModel?>(
              future: authService.getCurrentUser(),
              builder: (context, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      child: Lottie.asset(
                        'assets/json/loading.json',
                      ),
                    ),
                  );
                } else {
                  if (snapShot.hasData) {
                    final userData = snapShot.data;
                    finanprovider.totalExpense;
                    return CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/bgimg.jpeg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            "Welcome!",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "${userData!.name}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 26),
                                            overflow: TextOverflow
                                                .ellipsis, // This will add ellipsis (...) at the end
                                            maxLines:
                                                1, // This limits the text to a single line
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(context, "Profile");
                                      },
                                      child: CircleAvatar(
                                        child: Text(
                                          "${userData.name![0].toUpperCase()}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 26),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Divider(
                                  color: Color.fromARGB(255, 8, 209, 18),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                DashboardItemWidget(
                                  onTap1: () {
                                    print("view expense");
                                    Navigator.pushNamed(
                                      context,
                                      "ListExpense",
                                    );
                                  },
                                  onTap2: () {
                                    print("view income");
                                    Navigator.pushNamed(
                                      context,
                                      "ListIncome",
                                    );
                                  },
                                  titleOne:
                                      "Expense \n ${finanprovider.totalExpense}",
                                  titleTwo:
                                      "Income \n ${finanprovider.totalIncome}",
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                //fl chart
                                (finanprovider.totalExpense == 0 &&
                                        finanprovider.totalIncome == 0)
                                    ? Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Income VS Expense",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                            Lottie.asset(
                                              'assets/json/nodatafound.json',
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Income VS Expense",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                            const SizedBox(
                                              height: 40,
                                            ),
                                            AspectRatio(
                                              aspectRatio: 1.3,
                                              child: PieChart(
                                                PieChartData(
                                                  sectionsSpace: 5,
                                                  sections: [
                                                    PieChartSectionData(
                                                        radius: 50,
                                                        color: Color.fromARGB(
                                                            255, 149, 207, 14),
                                                        value: finanprovider
                                                            .totalExpense,
                                                        title: "Expense",
                                                        titleStyle: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.white)),
                                                    PieChartSectionData(
                                                        radius: 50,
                                                        color: Color.fromARGB(
                                                            255, 18, 129, 151),
                                                        value: finanprovider
                                                            .totalIncome,
                                                        title: "Income",
                                                        titleStyle: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.white))
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                const SizedBox(
                                  height: 40,
                                ),
                                DashboardItemWidget(
                                  onTap1: () {
                                    print("add income");
                                    Navigator.pushNamed(context, "Addincome",
                                        arguments: userData.id);
                                  },
                                  onTap2: () {
                                    Navigator.pushNamed(context, 'AddExpence',
                                        arguments: userData.id);
                                    print("add expence");
                                  },
                                  titleOne: "Add Income",
                                  titleTwo: "Add Expense",
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return Center(
                      child: Container(
                        height: 200,
                        width: 200,
                        child: Lottie.asset(
                          'assets/json/loading.json',
                        ),
                      ),
                    );
                  }
                }
              },
            );
          },
        ),
      ),
    );
  }
}
