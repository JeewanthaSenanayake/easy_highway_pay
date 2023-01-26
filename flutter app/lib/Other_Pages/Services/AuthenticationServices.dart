import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_highway_pay/Other_Pages/DatabaseManager/DatabaseManager.dart';

class AuthenticationServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //registration

  Future createNewUser(String email, String password, String fname,
      String lname, String vnumber) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //Add data to data base
      await DatabaseManager()
          .createUserAccount(fname, lname, vnumber, result.user!.uid);
      return result.user;
    } catch (e) {
      print(e.toString());
    }
  }

  //singin

  Future loginUser(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user!.uid;
    } catch (e) {
      print(e.toString());
    }
  }

  //sinout

  Future singOut() async {
    try {
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
