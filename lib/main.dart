import 'package:financemanagmentappprovider/constantes/colors.dart';
import 'package:financemanagmentappprovider/models/expense_model.dart';
import 'package:financemanagmentappprovider/models/income_model.dart';
import 'package:financemanagmentappprovider/models/user_model.dart';
import 'package:financemanagmentappprovider/screens/addExpense.dart';
import 'package:financemanagmentappprovider/screens/addincome.dart';
import 'package:financemanagmentappprovider/screens/home.dart';
import 'package:financemanagmentappprovider/screens/list_expense_transaction.dart';
import 'package:financemanagmentappprovider/screens/list_income_transation.dart';
import 'package:financemanagmentappprovider/screens/login_page.dart';
import 'package:financemanagmentappprovider/screens/profile_page.dart';
import 'package:financemanagmentappprovider/screens/register_page.dart';
import 'package:financemanagmentappprovider/screens/splash_page.dart';
import 'package:financemanagmentappprovider/screens/update_profile_page.dart';
import 'package:financemanagmentappprovider/services/auth_service_provider.dart';
import 'package:financemanagmentappprovider/services/fin_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(UserModelAdapter().typeId)) {
    Hive.registerAdapter(UserModelAdapter());
  }
  if (!Hive.isAdapterRegistered(IncomeModelAdapter().typeId)) {
    Hive.registerAdapter(IncomeModelAdapter());
  }
  if (!Hive.isAdapterRegistered(ExpenseModelAdapter().typeId)) {
    Hive.registerAdapter(ExpenseModelAdapter());
  }

  await AuthServiceProvider().openBox();
  await FinanceExpAndIncomeProvider().openBoxIncome();
  await FinanceExpAndIncomeProvider().openBoxExpense();
  // await FinanceExpAndIncomeProvider().clearBoxexp();
  // await FinanceExpAndIncomeProvider().clearBoxinc();
  // await AuthServiceProvider().clearBox();
  // await AuthServiceProvider().logout();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthServiceProvider()),
        ChangeNotifierProvider(
            create: (context) => FinanceExpAndIncomeProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(
            appBarTheme: AppBarTheme(color: Color.fromARGB(255, 68, 70, 75)),
            scaffoldBackgroundColor: ScaffoldColor,
            textTheme: TextTheme(
                displaySmall: TextStyle(color: Colors.white, fontSize: 16))),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashPage(),
          'Login': (context) => LoginPage(),
          'Register': (context) => RegisterPage(),
          'Home': (context) => Home(),
          'AddExpence': (context) => AddExpense(),
          'Addincome': (context) => Addincome(),
          'Profile': (context) => ProfilePage(),
          'updateProfile': (context) => UpdateProfilePage(),
          'ListExpense': (context) => ListExpenseTransaction(),
          'ListIncome': (context) => ListIncomeTransation(),
        },
      ),
    );
  }
}
