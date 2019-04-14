import 'package:flutter/material.dart';
import 'package:flutter_login/auth_provider.dart';
import './login_page.dart';
import 'auth.dart';
import './list_page.dart';

class LoginCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BaseAuth auth = AuthProvider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          final bool loggedIn = snapshot.hasData;
          return loggedIn ? ListPage() : LoginPage();
        }
        return _buildWaitingScreen();
      },
    );
  }

  Widget _buildWaitingScreen(){
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}