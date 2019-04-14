import 'package:flutter/material.dart';
import 'auth_provider.dart';
import 'auth.dart';
import './login_check.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: 'Flutter login demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: LoginCheck(),
      ),
    );
  }
}