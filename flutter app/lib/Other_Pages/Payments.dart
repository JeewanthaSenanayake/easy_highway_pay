import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'DatabaseManager/DatabaseManager.dart';



// import 'package:dio/dio.dart';

class Payments extends StatefulWidget {
  String uid;
  Payments({required this.uid});

  @override
  State<StatefulWidget> createState() => _State1(uid);
}

class _State1 extends State<Payments> {
  String uid;
  _State1(this.uid);

  bool loading = true;

  dynamic pay = "Calculating...";

  dynamic UserData = {
    'fname': "Loading...",
    'lname': "Loading...",
    'vnumber': "Loading..."
  };

  dynamic VehicleData = {
    'entrance': "Loading...",
    'exit': "Loading...",
    'exdate': "Loading...",
    'extime': "Loading...",
  };

  @override
  void initState() {
    super.initState();
    getDataBaseData();
  }

  getDataBaseData() async {
    dynamic UserResalts = await DatabaseManager().getUserDatails(uid);
    dynamic VehicleResalts = await DatabaseManager().getVehicleDatails(uid);
    dynamic PaymentResalts = await DatabaseManager().paymentDatails(uid);

    setState(() {
      UserData = UserResalts;
      VehicleData = VehicleResalts;
      pay = PaymentResalts;
      loading = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text('Payments'),
      ),
      body: SingleChildScrollView(
          child: loading?
          Container(
              alignment: Alignment.center,
              height:100,
              child: Center(
                child: CircularProgressIndicator(),
              )):Column(children: <Widget>[
        const SizedBox(height: 20),
        Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(15),
            child: Text(
              "Pay & Go",
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 0, 0),
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            )),
        const SizedBox(height: 40),
        Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: Text(
              "Vehicle Number:\t\t${UserData['vnumber']}\n\nEntrance:\t\t${VehicleData['entrance']}\n\nExit:\t\t${VehicleData['exit']}\n\nDate:\t\t${VehicleData['exdate']}\n\nTime:\t\t${VehicleData['extime']}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            )),
        const SizedBox(height: 40),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: Text(
            "Rs:$pay",
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 0, 0),
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          child: RaisedButton(
            color: Colors.blueAccent,
            textColor: Colors.white,
            child: Text('Pay'),

            onPressed: () {
              print("object");
            },
//            {
//              Navigator.of(context).push(MaterialPageRoute(
//                builder: (context) => Payments(uid: uid),
//              ));
//            },
          ),
        )
      ])),
    );
  }
}
