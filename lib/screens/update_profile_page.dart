import 'package:financemanagmentappprovider/models/user_model.dart';
import 'package:financemanagmentappprovider/services/auth_service_provider.dart';
import 'package:financemanagmentappprovider/widgets/app_button.dart';
import 'package:financemanagmentappprovider/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class UpdateProfilePage extends StatelessWidget {
  final int? userId;
  UpdateProfilePage({Key? key, this.userId}) : super(key: key);

  TextEditingController _nameController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  TextEditingController _conformpasswordController = TextEditingController();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _phoneController = TextEditingController();

  final _regKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authserviceprovider = Provider.of<AuthServiceProvider>(context);
    final String userid =
        ModalRoute.of(context)!.settings.arguments!.toString();
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bgimg.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          width: double.infinity,
          height: double.infinity,
          child: Form(
              key: _regKey,
              child: FutureBuilder(
                future: authserviceprovider.getCurrentUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData) {
                      final userdata = snapshot.data;
                      _emailController.text = userdata!.email ?? "";
                      _nameController.text = userdata.name ?? "";
                      _phoneController.text = userdata.phone ?? "";
                      _passwordController.text = userdata.password ?? "";
                      return CustomScrollView(
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "UPDATE PROFILE",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                CustomTextFormField(
                                  controller: _emailController,
                                  hintText: "${userdata!.email}",
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "enter email";
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
                                  controller: _passwordController,
                                  hintText: "Password",
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "enter password";
                                    } else if (value.length < 8) {
                                      return "password must br greater tahn 8";
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
                                  controller: _conformpasswordController,
                                  hintText: "Conform Password",
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "enter conform password";
                                    } else if (value.length < 8) {
                                      return "conform password must be greater than 8";
                                    } else if (value !=
                                        _passwordController.text) {
                                      return "password does not match";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomTextFormField(
                                  controller: _nameController,
                                  hintText: "Name",
                                  validator: (Value) {
                                    if (Value!.isEmpty) {
                                      return "enter name";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomTextFormField(
                                  controller: _phoneController,
                                  hintText: "Phone",
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "enter phone ";
                                    } else if (value.length < 10 ||
                                        value.length > 10) {
                                      return "enter valid phone number ex 10 digit";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                AppButton(
                                  height: 50,
                                  width: 250,
                                  color: Color.fromARGB(255, 6, 212, 99),
                                  onTap: () async {
                                    // if (_regKey.currentState!.validate()) {
                                    print("update profile");

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
                                    print(userid);

                                    UserModel user = UserModel(
                                      id: userdata.id,
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                      name: _nameController.text.trim(),
                                      phone: _phoneController.text.trim(),
                                      status: 1,
                                    );

                                    final res = await authserviceprovider
                                        .updateProfile(user, userdata.id!);
                                    await Future.delayed(Duration(seconds: 2));
                                    Navigator.pop(context);

                                    if (res == true) {
                                      Navigator.pop(context);
                                    }

                                    // }
                                  },
                                  child: Text("UPDATE PROFILE"),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                },
              )),
        ),
      ),
    );
  }
}
