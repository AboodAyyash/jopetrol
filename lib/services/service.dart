import 'package:flutter/material.dart';
import 'package:flutter_jo/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_jo/shared/settings.dart' as settings;

Future saveUser(id, password, token) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setString('userId', id);
  await sharedPreferences.setString('userPassword', password);
  await sharedPreferences.setString('token', token);

  return true;
}

Future getUser() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  print(sharedPreferences.getString('userId'));
  var userData = {};
  userData = {
    'id': sharedPreferences.getString('userId'),
    'password': sharedPreferences.getString('userPassword'),
    'token': sharedPreferences.getString('token'),
  };
  return userData;
}

void setHeader() {
  settings.headers = {
    'Content-Type': 'application/json',
  };
}

String replaceNumbers(value) {
  value = value.replaceAll(RegExp(r'٠'), '0');
  value = value.replaceAll(RegExp(r'١'), '1');
  value = value.replaceAll(RegExp(r'٢'), '2');
  value = value.replaceAll(RegExp(r'٣'), '3');
  value = value.replaceAll(RegExp(r'٤'), '4');
  value = value.replaceAll(RegExp(r'٥'), '5');
  value = value.replaceAll(RegExp(r'٦'), '6');
  value = value.replaceAll(RegExp(r'٧'), '7');
  value = value.replaceAll(RegExp(r'٨'), '8');
  value = value.replaceAll(RegExp(r'٩'), '9');

  return value;
}
