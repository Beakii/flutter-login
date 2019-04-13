import 'package:flutter/material.dart';
import './login_page.dart';
import 'auth.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Favorite List",
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: LoginPage(auth: Auth()),
    );
  }
}