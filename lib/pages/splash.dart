import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_jo/controllers/login.dart';
import 'package:flutter_jo/models/user.dart';
import 'package:flutter_jo/pages/login.dart';
import 'package:flutter_jo/pages/profile.dart';
import 'package:flutter_jo/services/service.dart';
import 'package:flutter_jo/shared/shared.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkData();
  }

  checkData() {
    Timer(Duration(seconds: 3), () async {
      getUser().then((onValue) {
        print(onValue);
        if (onValue == {}) {
          print("Need Login");
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const LoginPage(),
            ),
          );
        } else {
          print("go To Profile");

          //get user data by api

          //userModelData  = UserModel(id: '', name: '');

          LoginController loginController = LoginController();
          loginController.getAllData().then((onValue) {
            print(onValue);
          });
          /*     loginController.loginApi().then((apiValue) {
            if (apiValue['data']['EmpName'] == null) {
              print("Error");
            } else {
              userModelData = UserModel(
                  id: apiValue['data']['CurrentEmpID'],
                  name: apiValue['data']['EmpName']);
              saveUser(onValue['id'], onValue['password'], onValue['token']);
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => ProfilePage(),
                ),
              );
            }
          });
       */
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Splash"),
      ),
    );
  }
}
