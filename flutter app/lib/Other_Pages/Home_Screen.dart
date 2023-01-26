import 'package:flutter/material.dart';
import 'Payments.dart';
import 'Services/AuthenticationServices.dart';
import 'DatabaseManager/DatabaseManager.dart';


class HomePage extends StatefulWidget {
  String uid;
  HomePage({required this.uid});

  @override
  State<StatefulWidget> createState() => _State(uid);
}

class _State extends State<HomePage> {
  bool loading = true;
  bool isDataHear = false;

  @override
  void initState() {
    super.initState();
    getDataBaseData();
  }

  String uid;
  _State(this.uid);

  final AuthenticationServices _auth = AuthenticationServices();

  dynamic UserData = {
    'fname': "Loading...",
    'lname': "Loading...",
    'vnumber': "Loading..."
  };

  dynamic VehicleData = {
    'entrance': "Loading...",
    'exit': "Loading...",
    'date': "Loading...",
    'time': "Loading...",
  };





  getDataBaseData() async {

    dynamic UserResalts = await DatabaseManager().getUserDatails(uid);
    dynamic VehicleResalts = await DatabaseManager().getVehicleDatails(uid);

    setState(() {
      UserData = UserResalts;
      VehicleData = VehicleResalts;
      loading = false;
      if(VehicleData.toString()=="null") {
        isDataHear = true;
      }else{
        isDataHear = false;
      }

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          RaisedButton(
            onPressed: () async {
              await _auth.singOut().then((reslts) {
                Navigator.of(context).pop(true);
              });
            },
            child: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            color: Colors.blue,
          )
        ],
        title: Text("Welcome"),
      ),
      body: SingleChildScrollView(
          child: loading?
          Container(
              alignment: Alignment.center,
              height:100,
              child: Center(
                child: CircularProgressIndicator(),
              )):
              isDataHear?Container(
                  alignment: Alignment.center,
                  height:100,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "You are not on a Highway",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )
              ):
                Column(
                    children: <Widget>[
                        const SizedBox(height: 20),
                        Container(
                          alignment: Alignment.topCenter,
                           padding: const EdgeInsets.all(15),
                            child: Text(
                                "Hi ${UserData['fname']} ${UserData['lname']}",
                                  style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 0, 0),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  ),
                                ),
                            ),
                      const SizedBox(height: 40),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Vehicle Number:\t\t${UserData['vnumber']}\n\nEntrance:\t\t${VehicleData['entrance']}\n\nDate:\t\t${VehicleData['endate']}\n\nTime:\t\t${VehicleData['entime']}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                    const SizedBox(height: 70),
                    Container(
                    child: RaisedButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: Text('Contiune'),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Payments(uid: uid),
                        ));
                      },
                    ),
                  )
      ])),
    );
  }
}
