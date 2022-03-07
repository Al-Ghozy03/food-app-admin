// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:admin_aplikasi_food/add_food.dart';
import 'package:admin_aplikasi_food/dashboard.dart';
import 'package:admin_aplikasi_food/update.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(fontFamily: "popins"),
      initialRoute: "/",
      routes: {
        "/": (context) => Dashboard(),
        "/post": (context) => AddFood(),
        "/update": (context) =>
            new Update(data: ModalRoute.of(context)?.settings.arguments as Map),
      },
    );
  }
}
