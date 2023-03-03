import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  final String userid;
  HomePage({required this.userid});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref1 =
  FirebaseDatabase.instance.ref('/motor');
  DatabaseReference ref2 =
  FirebaseDatabase.instance.ref('/waterlevel');
  DatabaseReference ref =
  FirebaseDatabase.instance.ref('/');

  String motorstate="";
  String waterlvl ="";
  Timer? timer;
  bool isSwitched = true;
  String price = "0.23";
  int wl =0;
  Future<void> onstart() async {

    var snapshot = await ref.get();
    if(snapshot.exists) {
      var data = snapshot.value!;
      final json = jsonDecode(jsonEncode(snapshot.value));
      motorstate = json["motor"].toString();
      if(motorstate == "ON"){
        isSwitched = true;
      }
      else{
        isSwitched = false;

      }
      setState(() {

      });
    }

  }

    @override
  void initState() {
      ref1.onValue.listen((DatabaseEvent event) {
        final data = event.snapshot.value;
        motorstate = data.toString();
        setState(() {

        });
      });
      ref2.onValue.listen((DatabaseEvent event) {
        final data = event.snapshot.value;
        waterlvl = data.toString();
        wl = int.tryParse(waterlvl)!;
        setState(() {

        });
      });
      // TODO: implement initState
    timer = Timer.periodic(
      const Duration(seconds: 3),
          (timer) async {
        onstart();

      },
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("HOME"),
      ),
      body: Column(
        children: [
          Container(
              
              padding: EdgeInsets.all(20),
              child: Text("Water Level in Tank = $waterlvl")),
          wl > 50?
          Container(

              padding: EdgeInsets.all(20),
              child: Text("NOTIFICATION = WATER LEVEL HIGH"))
          :   Container(

              padding: EdgeInsets.all(20),
              child: Text("NOTIFICATION = WATER LEVEL NORMAL")),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Switch(
                // activeThumbImage:
                // AssetImage("assets/images/icon.png"),
                activeColor: Colors.white,
                activeTrackColor: Colors.red,
                //activeThumbImage: ImageProvider,
                value: isSwitched,
                onChanged: (value) async {
                  if(value){
                    await ref.update({
                      "motor": "ON",

                    });
                  }
                  else{
                    await ref.update({
                      "motor": "OFF",

                    });
                  }


                  setState(() {
                    // priceinfloat = priceinfloat / priceinfloat;
                    isSwitched = value;

                  });
                },
              ),
              Container(
                height: 40,
                width: 200,
                child:Center(child: Text("MOTOR STATUS $motorstate")),
              ),

            ],
          ),
        ],
      ),
    );
  }
}