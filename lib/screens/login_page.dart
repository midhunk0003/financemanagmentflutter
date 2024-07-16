import 'package:financemanagmentappprovider/services/auth_service_provider.dart';
import 'package:financemanagmentappprovider/widgets/app_button.dart';
import 'package:financemanagmentappprovider/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passworController = TextEditingController();

  final _loginKey = GlobalKey<FormState>();

  void showAlertDialog(BuildContext context) {
    // Set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text("Incorrect email or password."),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    // Show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginuserpro = Provider.of<AuthServiceProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          height: double.infinity,
          width: double.infinity,
          child: Form(
              key: _loginKey,
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          controller: emailController,
                          hintText: "Email",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter email address";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFormField(
                          obscureText: true,
                          controller: passworController,
                          hintText: "Password",
                          focusedBorder: OutlineInputBorder(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter Password";
                            } else if (value.length < 6) {
                              return "password must be greater than 6";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AppButton(
                          width: 250,
                          height: 50,
                          color: Color.fromARGB(255, 6, 212, 99),
                          onTap: () async {
                            print("login");
                            if (_loginKey.currentState!.validate()) {
                              print(emailController.text);
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
                              final user = await loginuserpro.loginUser(
                                context,
                                emailController.text,
                                passworController.text,
                              );
                              await Future.delayed(Duration(seconds: 2));
                              Navigator.pop(context);
                              if (user != null) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  "Home",
                                  (route) => false,
                                );
                              } else {
                                showAlertDialog(context);
                              }
                            }
                          },
                          child: Text("LOGIN"),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "I dont have a account",
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                print("register");
                                Navigator.pushNamed(context, 'Register');
                              },
                              child: Text(
                                "REGISTER",
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
