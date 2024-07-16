import 'dart:ffi';

import 'package:financemanagmentappprovider/services/auth_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    checkLoginState();
    super.initState();
  }

  Future<void> checkLoginState() async {
    await Future.delayed(Duration(seconds: 4));
    final authservice =
        Provider.of<AuthServiceProvider>(context, listen: false);

    final isloggedin = await authservice.isUserLogedIn();
    if (isloggedin) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        "Home",
        (route) => false,
      );
    } else {
      Navigator.pushReplacementNamed(context, 'Login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bgimg.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ui logo image image
            Image.asset(
              'assets/images/logo.png',
              height: 150,
              width: 150,
            ),
            SizedBox(
              height: 50,
            ),
            Align(
              alignment: Alignment(0, 2),
              child: Container(
                height: 200,
                width: 200,
                child: Lottie.asset(
                  'assets/json/loading.json',
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
