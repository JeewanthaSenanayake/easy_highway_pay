import 'package:flutter/material.dart';
import 'Signin_Screen.dart';
import 'ResetPassword.dart';
import 'Home_Screen.dart';
import 'Services/AuthenticationServices.dart';
import 'package:easy_highway_pay/Other_Pages/DatabaseManager/DatabaseManager.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<LoginPage> {
  String VRNumber = "";
  final GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();

  final AuthenticationServices _auth = AuthenticationServices();

  String _LogEmail = "";
  String _LogPassword = "";
  bool UsernamePassword = false;

  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Color(0xd050505),
        appBar: AppBar(
          title: Text('Welcome'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formkey1,
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'EASY HIGHWAY PAY',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
//                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      validator: (text) {
                        if (text.toString().isEmpty) {
                          return 'Email can not be empty';
                        }

                        if (UsernamePassword) {
                          return 'Email & Password are doesnot match';
                        }

                        return null;
                      },
                      onSaved: (text) {
                        _LogEmail = text.toString();
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      obscureText: true,
//                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      validator: (text) {
                        if (text.toString().isEmpty) {
                          return 'Password cannot be empty';
                        }

                        if (UsernamePassword) {
                          return 'Email & Password are does not match';
                        }

                        return null;
                      },
                      onSaved: (text) {
                        _LogPassword = text.toString();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    onPressed: () {
                      //forgot password screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => PasswordReset()),
                      );
                    },
                    textColor: Colors.blue,
                    child: Text('Forgot Password'),
                  ),
                  Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text('Login'),
                        onPressed: () {
                          if (_formkey1.currentState!.validate()) {
                            _formkey1.currentState!.save();
                            logInUser();
                          } else {
                            _LogEmail = "";
                            _LogPassword = "";
                            UsernamePassword = false;
                          }
                        },
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      child: Row(
                    children: <Widget>[
                      Text('Does not have account?'),
                      FlatButton(
                        textColor: Colors.blue,
                        child: Text(
                          'Sign in',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          //signup screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SinginPage()),
                          );
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ))
                ],
              ),
            )));
  }

  void logInUser() async {

    dynamic result = await _auth.loginUser(_LogEmail, _LogPassword);

    
    if (result == null) {
      print("Login faild");
      UsernamePassword = true;
      _formkey1.currentState!.validate();
    } else {
      _LogEmail = "";
      _LogPassword = "";
      print("Login sucsesful");

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage(uid: result)));
    }
  }
}
