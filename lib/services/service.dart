
import 'package:flutter/material.dart';
import 'package:flutter_jo/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_jo/shared/settings.dart' as settings;
Future saveUserId(id) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setString('userId', id);
  userId = id;
  print(userId);
  return true;
}

Future getUserId() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  print(sharedPreferences.getString('userId'));
  if (sharedPreferences.getString('userId') == null) {
    userId = '';
  } else {
    userId = sharedPreferences.getString('userId')!;
  }
  return userId;
}



void setHeader() {

  settings.headers = {
    'Accept': 'application/json',
   
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
