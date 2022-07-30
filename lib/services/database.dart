import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:toast/toast.dart';

class DbAservice {
  final droneDatabase = FirebaseFirestore.instance;
  Future<void> insertDroneData(
    String droneId,
    String droneManufacturer,
    String droneService,
    String dateManufactured,
    String droneWeight,
  ) async {
    return await droneDatabase.collection("Drones").add({
      "droneTag": droneId,
      "droneManufacturer": droneManufacturer,
      "droneService": droneService,
      "dateManufactured": dateManufactured,
      "droneWeight": droneWeight,
    }).then((value) {
      showToast("Show Long Toast", duration: Toast.lengthLong);
    });
  }

  void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }
}
