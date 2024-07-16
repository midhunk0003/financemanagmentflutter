import 'package:financemanagmentappprovider/services/auth_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService =
        Provider.of<AuthServiceProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text("PROFILE"),
        ),
        body: FutureBuilder(
          future: authService.getCurrentUser(),
          builder: (ontext, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                final userdata = snapshot.data;
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/bgimg.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: EdgeInsets.all(30),
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "USER NAME : ${userdata!.name}",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "USER EMAIL : ${userdata.email}",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "USER PHONE : ${userdata.phone}",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      // Text(
                      //   "USER STATUS : ${userdata.status}",
                      //   style: TextStyle(fontSize: 24, color: Colors.white),
                      // ),
                      SizedBox(
                        height: 30,
                      ),

                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              print("Log out");
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return Center(
                                    child: Container(
                                      height: 100,
                                      width: 250,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Icon(Icons.backspace),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  final log = await authService
                                                      .logout();
                                                  if (log == true) {
                                                    Navigator
                                                        .pushNamedAndRemoveUntil(
                                                            context,
                                                            "Login",
                                                            (route) => false);
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.check,
                                                  color: Color.fromARGB(
                                                      255, 83, 204, 13),
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
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                color: Color.fromARGB(176, 192, 185, 185),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(
                                    "Log Out",
                                    style: TextStyle(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Icon(
                                    Icons.logout,
                                    size: 30,
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            onTap: () {
                              print("edit profile");
                              Navigator.pushNamed(context, 'updateProfile',
                                  arguments: userdata.id);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                color: Color.fromARGB(176, 192, 185, 185),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(
                                    "EDIT PROFILE",
                                    style: TextStyle(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Icon(
                                    Icons.edit,
                                    size: 30,
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          },
        ));
  }
}
