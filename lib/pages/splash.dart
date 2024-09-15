import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_jo/models/user.dart';
import 'package:flutter_jo/pages/login.dart';
import 'package:flutter_jo/pages/profile.dart';
import 'package:flutter_jo/services/service.dart';
import 'package:flutter_jo/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      getUserId().then((onValue) {
        print(onValue);
        if (onValue == '') {
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

          userModelData  = UserModel(password: '', name: '');

          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const LoginPage(),
            ),
          );
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
