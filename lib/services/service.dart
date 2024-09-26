import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jo/shared/shared.dart';
import 'package:intl/intl.dart';
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
  String id = sharedPreferences.getString('userId') ?? "";
  String password = sharedPreferences.getString('userPassword') ?? "";
  String token = sharedPreferences.getString('token') ?? "";
  if (id != '' && password != '' && token != '') {
    userData = {
      'id': sharedPreferences.getString('userId'),
      'password': sharedPreferences.getString('userPassword'),
      'token': sharedPreferences.getString('token'),
    };
  }

  return userData;
}

void setHeader(body) {
  String xDate = dateToUtc();
  String xToken = convertToHMac(// 0-10 +.+ 0-10
      "${convertToHMac( //hmac result ==> xDate 0-10
              convertToBase64( //base 64 result
                  convertToMd5(xDate))) //md5 result
          .toString().substring(0, 10)}.${convertToHMac( //hmac ==> body 0-10
          convertToBase64( //base 64
              convertToMd5( // md5
                  body.toString()))).toString().substring(0, 10)}");

  settings.headers = {
    'Content-Type': 'application/json',
    'X-Token': xToken,
    'X-Body': body.toString(),
    'X-Timestamp': xDate,
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

String dateToUtc() {
  final dateUtc = DateTime.now().toUtc();

  String formattedTimestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateUtc);

  return replaceNumbers(formattedTimestamp);
}

String convertToMd5(value) {
  String originalString = value;

  // Convert the string to bytes
  List<int> bytes = utf8.encode(originalString);

  // Generate the MD5 hash
  Digest digest = md5.convert(bytes);

  // Convert the hash to a hexadecimal string
  String md5Hash = digest.toString();
  return md5Hash;
}

String convertToBase64(String value) {
  // Convert the string to bytes
  List<int> bytes = utf8.encode(value);

  // Encode the bytes to Base64
  String base64String = base64Encode(bytes);

  return base64String;
}

String convertToHMac(value) {
  String originalString = value;
  String secretKey = value; // Replace with your actual secret key

  // Convert the string and key to bytes
  List<int> bytes = utf8.encode(originalString);
  List<int> key = utf8.encode(secretKey);

  // Generate the HMAC using SHA256
  Hmac hmacSha256 = Hmac(sha256, key); // You can use other hash algorithms too
  Digest digest = hmacSha256.convert(bytes);

  // Convert the HMAC to a hexadecimal string
  String hmac = digest.toString();

  return hmac;
}




void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}


void setupFirebaseMessagingListeners() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Notification title: ${message.notification!.title}');
      print('Notification body: ${message.notification!.body}');
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    print(message.data);
    /* 
    message.data = {'title':"",body:"",payload:"",image:""}
     */
    if(message.data['payload'] == "leave"){
      //navigate to leave page
    }
  });
}


void getToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken();
  print("FCM Token: $token");
}

