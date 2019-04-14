import 'package:flutter/material.dart';
//import 'auth.dart';
import 'auth_provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType{
  login,
  register
}

class _LoginPageState extends State<LoginPage> {

  final formKey = GlobalKey<FormState>();
  FormType _formType = FormType.login;

  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Favorites List - Login"),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildFormTextInputs() + buildFormButtons()
            ),
          ),
        ),
      ),
    );
  }

  bool formSave(){
    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }

  void formSubmit() async {
    if(formSave()){
      try{
        var auth = AuthProvider.of(context).auth;
        if(_formType == FormType.login){
          String user = await auth.signInWithEmailAndPassword(_email, _password);
          print(user);
        }
        else{
          String user = await auth.createUserWithEmailAndPassword(_email, _password);
          print(user);
        }
      }
      catch (e){
        buildErrorDialog(e);
        print(e);
      }
    }
  }

    void googleFormSubmit() async {
    try{
      final auth = AuthProvider.of(context).auth;
        GoogleSignIn _googleSignin = GoogleSignIn(
          scopes: <String>[
            'email', 
            'https://www.googleapis.com/auth/contacts.readonly'
          ]
        );
      await auth.signInWithGoogle(_googleSignin);
    }
    catch (e){
      buildErrorDialog(e);
      print(e);
    }
  }

  void changeFormType(){
    formKey.currentState.reset();

    setState(() {
     if(_formType == FormType.login){
       _formType = FormType.register;
     }
     else{
       _formType = FormType.login;
     }
    });
  }

  Future<void> buildErrorDialog(dynamic e) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(e.toString()), //Change e.toString() to a function that will return a string based on the type of error.
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> buildFormTextInputs(){
    return <Widget>[     
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? 'Please enter your email' : null,
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        validator: (value) => value.isEmpty ? 'Please enter your password' : null,
        onSaved: (value) => _password = value,
        obscureText: true,
      )
    ];
  }

  List<Widget> buildFormButtons(){

    if(_formType == FormType.login){
      return <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              SignInButton(
                Buttons.Email,
                onPressed: formSubmit,
              ),
              SignInButton(
                Buttons.GoogleDark,
                onPressed: googleFormSubmit,
              ),
              FlatButton(
                child: Text('Create an Account', style: TextStyle(fontSize: 20),),
                onPressed: changeFormType,
              )
            ],
          ),
        )
      ];
    }
    else{
      return <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              SignInButton(
                Buttons.Email,
                text: 'Register',
                onPressed: formSubmit,
              ),
              FlatButton(
                child: Text('Already Have an Account', style: TextStyle(fontSize: 20),),
                onPressed: changeFormType,
              )
            ],
          ),
        )
      ];
    }
  }
}