import 'package:flutter/material.dart';
import 'package:smartfarm/constants/smartfarmer_constants.dart';
import 'package:smartfarm/screen/info_page.dart';
import 'package:smartfarm/screen/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartFarmer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: InfoPage(),
      home: LoginPage(),
    );
  }
}

