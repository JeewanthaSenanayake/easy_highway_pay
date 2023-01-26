import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Services/AuthenticationServices.dart';


class PasswordReset extends StatefulWidget {
  const PasswordReset({Key? key}) : super(key: key);

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {

  final GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();
  final AuthenticationServices _auth = AuthenticationServices();

  String _LogEmail = "";
  bool UsernamePassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formkey1,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 130,
                ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                    ' Receive an email to\nreset your password',
                    style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 30),
                    )
    ),
              SizedBox(
                height: 50,
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

                    return null;
                  },
                  onSaved: (text) {
                    _LogEmail = text.toString();
                  },
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text('Reset Password'),
                    onPressed: () {
                      if (_formkey1.currentState!.validate()) {
                        _formkey1.currentState!.save();
                        varifEmail(_LogEmail,context);
                      } else {
                        _LogEmail = "";
                        UsernamePassword = false;
                      }
                    },
                  )),]),)));
  }
  Future  varifEmail(String email, BuildContext context) async{
    
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)=>Center(child: CircularProgressIndicator(),)
    );
    
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent'),
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    }on FirebaseAuthException catch(e){
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This emil does not have an account"),
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}
