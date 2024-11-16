import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'amount_calculator_page.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('dataBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Denomination',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:const AmountCalculator(),
    );
  }
}
