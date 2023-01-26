import 'package:flutter/material.dart';
import 'Login_Screen.dart';
import 'Services/AuthenticationServices.dart';

class SinginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<SinginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final AuthenticationServices _auth = AuthenticationServices();

  String _Fname = "";
  String _Lname = "";
  String _Email = "";
  String _ConEmail = "";
  String _VRNumber = "";
  String _Password = "";
  String _ConPassword = "";

  Widget _CreateTextFeald(value, len, hidetext) {
    return TextFormField(
      maxLength: len,
      obscureText: hidetext,
      decoration: InputDecoration(hintText: value),
      validator: (text) {
        if (text.toString().isEmpty) {
          return '$value cannot be empty';
        }

        if (value == 'Password' || value == 'Confirm Password') {
          if (!(_Password == _ConPassword)) {
            return 'Password doesnt match';
          }
        }

        if (value == 'Email' || value == 'Confirm Email') {
          if (!(_Email == _ConEmail)) {
            return 'Email doesnt match';
          }
        }

        return null;
      },
      onSaved: (text) {
        if (value == 'First Name') {
          _Fname = text.toString();
        } else if (value == 'Last Name') {
          _Lname = text.toString();
        } else if (value == 'Email') {
          _Email = text.toString();
        } else if (value == 'Confirm Email') {
          _ConEmail = text.toString();
        } else if (value == 'Vehicle Registration Number') {
          _VRNumber = text.toString();
        } else if (value == 'Password') {
          _Password = text.toString();
        } else if (value == 'Confirm Password') {
          _ConPassword = text.toString();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Container(
            margin: const EdgeInsets.all(24.0),
            child: Column(
              children: <Widget>[
                _CreateTextFeald('First Name', 20, false), //call function
                _CreateTextFeald('Last Name', 20, false),
                _CreateTextFeald('Email', 30, false),
                _CreateTextFeald('Confirm Email', 30, false),
                _CreateTextFeald('Password', 12, true),
                _CreateTextFeald('Confirm Password', 12, true),
                _CreateTextFeald('Vehicle Registration Number', 12, false),

                SizedBox(
                  height: 10,
                ),
                Container(
                  child: RaisedButton(
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: Text('Sign in'),
                    onPressed: () {
                      _formkey.currentState!.save();
                      if (_formkey.currentState!.validate()) {
                        print('fname = ' + _Fname);
                        print('lname = ' + _Lname);
                        print('email = ' + _Email);
                        print('conemail = ' + _ConEmail);
                        print('VR = ' + _VRNumber);
                        print('pass = ' + _Password);
                        print('Cpas = ' + _ConPassword);

                        //database connection
                        createUser();

//                            Navigator.defaultGenerateInitialRoutes(navigator, initialRouteName)
                      } else {
                        _Fname = "";
                        _Lname = "";
                        _Email = "";
                        _ConEmail = "";
                        _VRNumber = "";
                        _Password = "";
                        _ConPassword = "";
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createUser() async {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)=>Center(child: CircularProgressIndicator(),)
    );

    dynamic result =
        await _auth.createNewUser(_Email, _Password, _Fname, _Lname, _VRNumber);
    if (result == null) {
      print("Email is not valide");
    } else {
      print(result.toString());
      _Fname = "";
      _Lname = "";
      _Email = "";
      _ConEmail = "";
      _VRNumber = "";
      _Password = "";
      _ConPassword = "";
      // Navigator.pop(
      //   context,
      //   MaterialPageRoute(builder: (context) => LoginPage()),
      // );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully Registered to Easy Highway Pay'),
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}
