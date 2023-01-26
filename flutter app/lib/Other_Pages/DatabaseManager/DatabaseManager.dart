import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  final profileList = FirebaseFirestore.instance.collection("accountInfo");

  Future<void> createUserAccount(
      String fname, String lname, String vnumber, String uid) async {
    return await profileList
        .doc(uid)
        .set({'fname': fname, 'lname': lname, 'vnumber': vnumber});
  }

  Future<dynamic> getUserDatails(String uid) async {
    final userInfo =
        FirebaseFirestore.instance.collection("accountInfo").doc(uid);
    dynamic UserDatils;
    try {
      await userInfo.get().then((QuerySnapshot) {
        UserDatils = QuerySnapshot.data();
      });
      return UserDatils;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<dynamic> getVehicleDatails(String uid) async {
    final userInfo =
        FirebaseFirestore.instance.collection("accountInfo").doc(uid);
    dynamic UserDatils;
    dynamic VehicleDetails;
    try {
      await userInfo.get().then((QuerySnapshot) {
        UserDatils = QuerySnapshot.data();
      });
      final vehicleInfo = FirebaseFirestore.instance
          .collection("Vehical")
          .doc(UserDatils['vnumber']);
      try {
        await vehicleInfo.get().then((QuerySnapshot) {
          VehicleDetails = QuerySnapshot.data();
        });
        return VehicleDetails;
      } catch (e) {
        print(e.toString());
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<dynamic> paymentDatails(String uid) async {
    final userInfo =
        FirebaseFirestore.instance.collection("accountInfo").doc(uid);
    dynamic UserDatils;
    dynamic VehicleDetails;
    dynamic distance1;
    dynamic distance2;
    dynamic payment;
    try {
      await userInfo.get().then((QuerySnapshot) {
        UserDatils = QuerySnapshot.data();
      });
      final vehicleInfo = FirebaseFirestore.instance
          .collection("Vehical")
          .doc(UserDatils['vnumber']);
      try {
        await vehicleInfo.get().then((QuerySnapshot) {
          VehicleDetails = QuerySnapshot.data();
        });
      } catch (e) {
        print(e.toString());
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }

    final distanceInfo1 = FirebaseFirestore.instance
        .collection("Place")
        .doc(VehicleDetails['entrance']);
    final distanceInfo2 = FirebaseFirestore.instance
        .collection("Place")
        .doc(VehicleDetails['exit']);
    try {
      await distanceInfo1.get().then((QuerySnapshot) {
        distance1 = QuerySnapshot.data();
      });

      await distanceInfo2.get().then((QuerySnapshot) {
        distance2 = QuerySnapshot.data();
      });
    } catch (e) {
      print(e.toString());
      return null;
    }

    double d2 = double.parse(distance2['distance']);
    double d1 = double.parse(distance1['distance']);

    final payInfo =
        FirebaseFirestore.instance.collection("Fee").doc('FeePer1Km');
    try {
      await payInfo.get().then((QuerySnapshot) {
        payment = QuerySnapshot.data();
      });
    } catch (e) {
      print(e.toString());
      return null;
    }

    double finalPayment = (d2 - d1).abs() * double.parse(payment['fee']);

    return finalPayment.abs().toStringAsFixed(2); //round off
  }
}
