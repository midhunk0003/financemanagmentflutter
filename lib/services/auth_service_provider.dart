import 'package:financemanagmentappprovider/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServiceProvider extends ChangeNotifier {
  //user db

  Box<UserModel>? _userBox;
  static const String _loggedinkey = 'isloggedin';

  Future<void> openBox() async {
    _userBox = await Hive.openBox('users');
  }

  // //clear box
  Future<void> clearBox() async {
    _userBox = await Hive.openBox('users');
    print(_userBox!.values);
    _userBox!.clear();
  }

  //register user

  Future<bool> registerUser(UserModel user) async {
    if (_userBox == null) {
      await openBox();
    }

    await _userBox!.add(user);
    notifyListeners();
    print("success");
    print("register box user :${_userBox!.values}");
    return true;
  }

  // get all register user

  Future<List<UserModel>> getAllUser() async {
    if (_userBox == null) {
      await openBox();
    }
    print(_userBox!.values.toList());
    return _userBox!.values.toList();
  }

  // login user
  Future<UserModel?> loginUser(
      BuildContext context, String? email, String? password) async {
    if (_userBox == null) {
      await openBox();
    }

    print("login user : ${_userBox!.values.toList()}");

    for (var user in _userBox!.values) {
      print(user);
      if (user.email == email && user.password == password) {
        //successfully logged in store key in shared prefrence
        await setLoggedinState(true, user.id);
        print("login user ${user}");
        return user;
      }
    }
    return null;
  }

  //store value to shared prefrence

  Future<void> setLoggedinState(bool isLoggedIn, int? id) async {
    final shared = await SharedPreferences.getInstance();

    await shared.setBool(_loggedinkey, isLoggedIn);
    //insert id of login user
    await shared.setInt('id', id!);
  }

  //key exist or not

  Future<bool> isUserLogedIn() async {
    final shared = await SharedPreferences.getInstance();
    return shared.getBool(_loggedinkey) ?? false;
  }

  ///get current user
  Future<UserModel?> getCurrentUser() async {
    if (_userBox == null) {
      await openBox();
    }
    final isLoggedinn = await isUserLogedIn();
    if (isLoggedinn) {
      final loggidinuserid = await getLoggedinIdUser();
      print(loggidinuserid);
      for (var user in _userBox!.values) {
        if (user.id == loggidinuserid) {
          print("current user :${user}");
          return user;
        }
      }
    }
    return null;
  }

  Future<int?> getLoggedinIdUser() async {
    final sher = await SharedPreferences.getInstance();
    final id = await sher.getInt('id');
    return id;
  }

  Future<bool> logout() async {
    final shared = await SharedPreferences.getInstance();
    await shared.clear();
    return true;
  }

  //wrong email and password

  Future<bool> updateProfile(UserModel user, int userid) async {
    if (_userBox == null) {
      await openBox();
    }
    print(user);
    await _userBox?.put(userid, user);
    return true;
  }
}
