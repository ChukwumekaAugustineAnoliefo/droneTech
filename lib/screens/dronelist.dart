import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:droneapp/constants/color_constants.dart';
import 'package:droneapp/widgets/inputWidget.dart';
import 'package:droneapp/widgets/reusable_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DronTechList extends StatefulWidget {
  DronTechList({Key? key}) : super(key: key);

  @override
  State<DronTechList> createState() => _DronTechListState();
}

enum Status { serviced, notserviced }

class _DronTechListState extends State<DronTechList> {
  Status _serviced = Status.serviced;
  TextEditingController droneId = TextEditingController();
  TextEditingController droneDate = TextEditingController();

  TextEditingController droneWeight = TextEditingController();
  TextEditingController droneManufacturer = TextEditingController();
  final droneDatabase = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  void dispose() {
    droneId.dispose();
    droneWeight.dispose();
    droneManufacturer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Drone List')),
      body: SafeArea(
          child: FutureBuilder<QuerySnapshot>(
              future: droneDatabase.collection('Drones').get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> arrData = snapshot.data!.docs;
                  return ListView(
                    children: arrData.map((data) {
                      return Card(
                        elevation: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Drone Tag: " + data['droneTag'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                "Drone Manufacturer: " +
                                    data['droneManufacturer'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 14),
                              ),
                              Text(
                                "Status: " + data['droneService'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 14),
                              ),
                              Text(
                                "Manufactured Date: " +
                                    data['dateManufactured'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 14),
                              ),
                              Text(
                                "Drone Weight: " + data['droneWeight'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                  // return Text("Data found");
                } else {
                  return Text("Data not found");
                }
              })),
      floatingActionButton: FloatingActionButton(
        backgroundColor: floatActionBtnBgcolor,
        onPressed: () {
          showModalBottomSheet<void>(
              // backgroundColor: defaultTextColor,
              isScrollControlled: true,
              elevation: 30,
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (context, StateSetter setState) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          InpuTextField(
                            hintTexts: 'Enter Drone ID',
                            controller: droneId,
                            secure: false,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InpuTextField(
                            hintTexts: 'Enter Drone Weight',
                            controller: droneWeight,
                            secure: false,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InpuTextField(
                            hintTexts: 'Enter Drone Manufacturer',
                            controller: droneManufacturer,
                            secure: false,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            title: Text('Serviced'),
                            leading: Radio<Status>(
                                activeColor: Colors.green,
                                value: Status.serviced,
                                groupValue: _serviced,
                                onChanged: (Status? value) {
                                  setState(() {
                                    _serviced = value!;
                                    print(_serviced);
                                  });
                                }),
                          ),
                          ListTile(
                            title: Text('Not Serviced'),
                            leading: Radio<Status>(
                                activeColor: Colors.green,
                                value: Status.notserviced,
                                groupValue: _serviced,
                                onChanged: (Status? value) {
                                  setState(() {
                                    _serviced = value!;
                                    print(_serviced);
                                  });
                                }),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: TextField(
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  icon: Icon(Icons.calendar_today),
                                  labelText: "Enter date of acquisition"),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(3100),
                                );
                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  setState(
                                    () {
                                      droneDate.text = formattedDate;
                                    },
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Date not selected')));
                                }
                              },
                              controller: droneDate,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ReUsableBtn(
                            btnText: "Submit",
                            onPress: () async {
                              if (droneId.text.isNotEmpty &&
                                  droneDate.text.isNotEmpty &&
                                  droneManufacturer.text.isNotEmpty &&
                                  _serviced.name.isNotEmpty &&
                                  droneWeight.text.isNotEmpty) {
                                _insertDroneData(
                                    droneId.text,
                                    droneManufacturer.text,
                                    _serviced.name,
                                    droneDate.text,
                                    droneWeight.text);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'please enter all fields values')));
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                });
              });
        },
        child: Icon(
          Icons.add,
          color: FloatActionBtnColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _insertDroneData(
    String droneId,
    String droneManufacturer,
    String droneService,
    String dateManufactured,
    String droneWeight,
  ) {
    droneDatabase.collection("Drones").add({
      "droneTag": droneId,
      "droneManufacturer": droneManufacturer,
      "droneService": droneService,
      "dateManufactured": dateManufactured,
      "droneWeight": droneWeight,
    }).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Data Added')));
    });
  }
}
