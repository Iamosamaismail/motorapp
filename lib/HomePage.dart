import 'dart:convert';
import 'dart:math';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:overlay_support/overlay_support.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:motorapp/LoginPage.dart';

class HomePage extends StatefulWidget {
  final String userid;

  HomePage({required this.userid});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref1 = FirebaseDatabase.instance.ref('/motorControl/motorState');
  DatabaseReference ref4 = FirebaseDatabase.instance.ref('/motorControl/motorMode');

  DatabaseReference ref2 = FirebaseDatabase.instance.ref('/waterlevel');
  DatabaseReference ref3 = FirebaseDatabase.instance.ref('/flow');
  DatabaseReference ref = FirebaseDatabase.instance.ref('/motorControl');
  String uid = "";
  int motorstate = 0;
  int motormode = 0;

  int flow = 0;
  String waterlvl = "0";
  Timer? timer;
  int isSwitched = 0;
  int isSwitched2=0;
  String price = "0.23";
  int wl = 0;
  double mywid = 250;
  double myhi = 250;

  double wlf = 0.0;
  bool isAlert = false;
  DateTime now = new DateTime.now();
  late DateTime date;
  List<String> mname = ["S","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
  List<FlSpot> myspot = [FlSpot(0, 0)];
  String month="";
  Random random = new Random();
  Future<void> onstart() async {
    isAlert = false;
    var snapshot = await ref.get();
    if (snapshot.exists) {
      final json = jsonDecode(jsonEncode(snapshot.value));
      motorstate = json["motorState"];
      if (motorstate == 1) {
        isSwitched = 1;
      } else {
        isSwitched = 0;
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    date = DateTime(now.year, now.month, now.day);
    month = mname[date.month];
    uid = widget.userid;
    for(int i =0;i<32;i++){
      if(i<date.day){
        myspot.add(FlSpot(i.toDouble(), random.nextInt(10).toDouble()));
      }
      if(i==date.day){
        myspot.add(FlSpot(i.toDouble(), flow.toDouble()));

      }
    }
    ref1.onValue.listen((DatabaseEvent event) {
      print("ref1");
      final data = event.snapshot.value;
      if(data!=null){
        motorstate = data as int;
        isSwitched = motorstate;
        print("inside ref $isSwitched");
      }
      setState(() {});
    });
    ref4.onValue.listen((DatabaseEvent event) {
      print("ref4");
      final data = event.snapshot.value;
      if(data!=null){
        motormode = data as int;
        isSwitched2 = motormode;
        print("inside ref $isSwitched2");
      }
      setState(() {});
    });
    ref2.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      wl = data as int;
      waterlvl = data.toString();
      wlf = wl / 100;
      if(wl>90){
        showSimpleNotification(const Text("Alert! Critical Level"),
            background: Colors.lightBlueAccent);
      }

      setState(() {});
    });
    ref3.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if(data!=null) {
        flow = data as int;
      }
      if (!isAlert) {
        showSimpleNotification(const Text("Water is Available"),
            background: Colors.lightBlueAccent);
        isAlert = true;
      }
      setState(() {});
    });
    // TODO: implement initState
    timer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) async {
        onstart();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          primary: true,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.query_stats_sharp)),
                Tab(icon: Icon(Icons.electric_bolt_sharp)),
                Tab(icon: Icon(Icons.water_drop_outlined)),
                Tab(icon: Icon(Icons.person)),
              ],
            ),
            title: const Text('Home'),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Icon(
                      Icons.power_settings_new,
                      size: 26.0,
                    ),
                  )),
            ],
          ),
          body: TabBarView(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/back.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(10, 100, 10, 10),
                        height: 200,
                        width: 120,
                        child: LiquidLinearProgressIndicator(
                          value: wlf,
                          // Defaults to 0.5.
                          valueColor:
                              const AlwaysStoppedAnimation(Color(0xDF7BCBF7)),
                          // Defaults to the current Theme's accentColor.
                          backgroundColor: Colors.white.withOpacity(0.5),
                          // Defaults to the current Theme's backgroundColor.
                          borderColor: Colors.blue,
                          borderWidth: 5.0,
                          direction: Axis
                              .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                          // center: Text("$wl"),
                        )),
                    Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "$waterlvl L",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 40,color: Colors.white),
                        )),
                    wl < 90
                        ? Container(
                            width: 250,
                            height: 100,
                            padding: const EdgeInsets.all(20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                //<-- SEE HERE
                                // side: const BorderSide(
                                //   color: Colors.greenAccent,
                                // ),
                                borderRadius:
                                    BorderRadius.circular(20.0), //<-- SEE HERE
                              ),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 28,
                                      width: 28,
                                      // color: Colors.pink,
                                      decoration: new BoxDecoration(
                                        borderRadius:
                                            new BorderRadius.circular(90.0),
                                        color: Colors.green,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 25.0,
                                      ),
                                    ),
                                    const Text(
                                      '    NORMAL LEVEL',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        : Container(
                            width: 250,
                            height: 100,
                            padding: const EdgeInsets.all(20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                //<-- SEE HERE
                                // side: const BorderSide(
                                //   color: Colors.red,
                                // ),
                                borderRadius:
                                    BorderRadius.circular(20.0), //<-- SEE HERE
                              ),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 32,
                                      width: 32,
                                      // color: Colors.pink,
                                      decoration: new BoxDecoration(
                                        borderRadius:
                                            new BorderRadius.circular(90.0),
                                        color: Colors.white,
                                      ),
                                      child: const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 30.0,
                                      ),
                                    ),
                                    const Text(
                                      '    CRITICAL LEVEL',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          width: 120,
                          child:
                          Center(child: Text("Motor Control",style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                        ),
                        ToggleSwitch(
                          minWidth: 50.0,
                          cornerRadius: 20.0,
                          activeBgColors: [[Colors.blue!], [Colors.blue!]],
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          initialLabelIndex: isSwitched,
                          totalSwitches: 2,
                          labels: ['OFF', 'ON'],
                          radiusStyle: true,
                          onToggle: (index) {
                            if(isSwitched ==1){
                              isSwitched =0 ;
                            }
                            else{
                              isSwitched =1;
                            }
                            print(isSwitched);
                            print(isSwitched2);

                            print('switched to: $index');
                            ref.update({
                                    "motorState": index,
                                  });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 120,
                          child:
                          Center(child: Text("Motor Mode",style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                        ),
                        ToggleSwitch(

                          minWidth: 80.0,
                          cornerRadius: 20.0,
                          activeBgColors: [[Colors.blue!], [Colors.blue!]],
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          initialLabelIndex: isSwitched2,
                          totalSwitches: 2,
                          labels: ['Manual', 'Auto'],
                          radiusStyle: true,
                          onToggle: (index1) {
                            print(isSwitched);
                            print(isSwitched2);
                            if(isSwitched2 ==1){
                              isSwitched2 =0 ;
                            }
                            else{
                              isSwitched2 =1;
                            }
                            print('switched to: $index1');
                            ref.update({
                              "motorMode": index1,
                            });                          },
                        ),


                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/back.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 25,bottom: 20),
                      child: const Text(
                        'ELECTRICITY STATISTICS',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.fromLTRB(10,20,20,15),
                      decoration: BoxDecoration(
                          borderRadius:
                          new BorderRadius.circular(10.0),
                          color: Colors.white.withOpacity(0.7)

                      ),
                      height: myhi,
                      width: mywid,
                      margin: const EdgeInsets.only(top: 40),
                      child: LineChart(
                        LineChartData(
                          lineTouchData: LineTouchData(enabled: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: myspot,
                              isCurved: false,
                              isStepLineChart: false,
                              barWidth: 2,
                              color: Colors.lightBlueAccent,
                              dotData: FlDotData(
                                show: false,
                              ),
                            ),
                          ],
                          // minY: 0,
                          titlesData: FlTitlesData(
                            show: true,
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              axisNameWidget: Text(
                                '${month}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 20,
                                interval: 3,
                                getTitlesWidget: bottomTitleWidgets,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              axisNameSize: 20,
                              axisNameWidget: const Text(
                                'Kwh',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 5,
                                reservedSize: 10,
                                getTitlesWidget: leftTitleWidgets,
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          gridData: FlGridData(
                            show: false,
                            drawVerticalLine: false,
                            horizontalInterval: 1,
                            checkToShowHorizontalLine: (double value) {
                              return value == 1 ||
                                  value == 6 ||
                                  value == 4 ||
                                  value == 5;
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10,20,20,15),
                      decoration: BoxDecoration(
                          borderRadius:
                          new BorderRadius.circular(10.0),
                          color: Colors.white.withOpacity(0.8)
                      ),
                      height: myhi,
                      width: mywid,
                      margin: const EdgeInsets.only(top: 10),
                      child: LineChart(
                        LineChartData(
                          lineTouchData: LineTouchData(enabled: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                FlSpot(0, 10),
                                FlSpot(1, 2),
                                FlSpot(2, 22),
                                FlSpot(3, 21),
                                FlSpot.nullSpot,
                                FlSpot.nullSpot,
                                FlSpot.nullSpot,
                                FlSpot.nullSpot,

                              ],
                              isCurved: false,
                              isStepLineChart: false,
                              barWidth: 2,
                              color: Colors.lightBlueAccent,
                              dotData: FlDotData(
                                show: false,
                              ),
                            )
                          ],
                          // minY: 0,
                          titlesData: FlTitlesData(
                            show: true,
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              axisNameWidget: Text(
                                'YEARLY',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 20,
                                interval: 1,
                                getTitlesWidget: mybot,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              axisNameSize: 20,
                              axisNameWidget: const Text(
                                'Kwh',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 5,
                                reservedSize: 25,
                                getTitlesWidget: leftTitleWidgets,
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          gridData: FlGridData(
                            show: false,
                            drawVerticalLine: false,
                            horizontalInterval: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/back.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 25,bottom: 20),
                      child: const Text(
                        '    WATER STATISTICS',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10,20,20,15),
                      decoration: BoxDecoration(
                          borderRadius:
                          new BorderRadius.circular(10.0),
                          color: Colors.white.withOpacity(0.8)
                      ),
                      height: myhi,
                      width: mywid,
                      margin: const EdgeInsets.only(top: 10),
                      child: LineChart(
                        LineChartData(
                          lineTouchData: LineTouchData(enabled: false),
                          lineBarsData: [
                            date.day == 1?
                            LineChartBarData(
                              spots: [
                                FlSpot(1, flow.toDouble()),
                              ],
                              isCurved: false,
                              isStepLineChart: false,
                              barWidth: 2,
                              color: Colors.lightBlueAccent,
                              dotData: FlDotData(
                                show: false,
                              ),
                            ):date.day == 2?
                              LineChartBarData(
                              spots: [
                              FlSpot(1, random.nextInt(10).toDouble()),
                              FlSpot(2, flow.toDouble()),
                              ],
                              isCurved: false,
                              isStepLineChart: false,
                              barWidth: 2,
                              color: Colors.lightBlueAccent,
                              dotData: FlDotData(
                              show: false,
                              ),
                              ):date.day == 3?
                             LineChartBarData(
                              spots: [
                                FlSpot(date.day.toDouble()-2, 5),
                                FlSpot(date.day.toDouble()-1, 4),
                                FlSpot(date.day.toDouble(), flow.toDouble()),
                              ],
                              isCurved: false,
                              isStepLineChart: false,
                              barWidth: 2,
                              color: Colors.lightBlueAccent,
                              dotData: FlDotData(
                                show: false,
                              ),
                            ):date.day == 4?
                            LineChartBarData(
                              spots: [
                                FlSpot(date.day.toDouble()-3, 6),
                                FlSpot(date.day.toDouble()-2, 4),
                                FlSpot(date.day.toDouble()-1, 7),
                                FlSpot(date.day.toDouble(), flow.toDouble()),
                              ],
                              isCurved: false,
                              isStepLineChart: false,
                              barWidth: 2,
                              color: Colors.lightBlueAccent,
                              dotData: FlDotData(
                                show: false,
                              ),
                            ):date.day == 5?
                            LineChartBarData(
                              spots: [
                                FlSpot(date.day.toDouble()-4, 4),
                                FlSpot(date.day.toDouble()-3, 3),
                                FlSpot(date.day.toDouble()-2, 4),
                                FlSpot(date.day.toDouble()-1, 5),
                                FlSpot(date.day.toDouble(), flow.toDouble()),
                              ],
                              isCurved: false,
                              isStepLineChart: false,
                              barWidth: 2,
                              color: Colors.lightBlueAccent,
                              dotData: FlDotData(
                                show: false,
                              ),
                            ):date.day == 6?
                            LineChartBarData(
                              spots: [
                                FlSpot(date.day.toDouble()-5, 5),
                                FlSpot(date.day.toDouble()-4, 2),
                                FlSpot(date.day.toDouble()-3, 7),
                                FlSpot(date.day.toDouble()-2, 8),
                                FlSpot(date.day.toDouble()-1, 7),
                                FlSpot(date.day.toDouble(), flow.toDouble()),
                              ],
                              isCurved: false,
                              isStepLineChart: false,
                              barWidth: 2,
                              color: Colors.lightBlueAccent,
                              dotData: FlDotData(
                                show: false,
                              ),
                            ):
                            LineChartBarData(
                              spots: [
                                FlSpot(date.day.toDouble()-6, 4),
                                FlSpot(date.day.toDouble()-5, 2),
                                FlSpot(date.day.toDouble()-4, 8),
                                FlSpot(date.day.toDouble()-3, 3),
                                FlSpot(date.day.toDouble()-2, 2),
                                FlSpot(date.day.toDouble()-1, 6),
                                FlSpot(date.day.toDouble(), flow.toDouble()),
                              ],
                              isCurved: false,
                              isStepLineChart: false,
                              barWidth: 2,
                              color: Colors.lightBlueAccent,
                              dotData: FlDotData(
                                show: false,
                              ),
                            )
                          ],
                          // minY: 0,
                          titlesData: FlTitlesData(
                            show: true,
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              axisNameWidget: Text(
                                'WEEK',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 20,
                                interval: 1,
                                getTitlesWidget: bottomTitleWidgets,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              axisNameSize: 20,
                              axisNameWidget: const Text(
                                'Ltr/hour',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 5,
                                reservedSize: 10,
                                getTitlesWidget: leftTitleWidgets,
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          gridData: FlGridData(
                            show: false,
                            drawVerticalLine: false,
                            horizontalInterval: 1,
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   // margin: const EdgeInsets.only(top: 40),
                    //   child: const Text(
                    //     '    Day',
                    //     style: TextStyle(
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.black),
                    //   ),
                    // ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10,20,20,15),
                      decoration: BoxDecoration(
                          borderRadius:
                          new BorderRadius.circular(10.0),
                        color: Colors.white.withOpacity(0.7)

                      ),
                      height: myhi,
                      width: mywid,
                      margin: const EdgeInsets.only(top: 40),
                      child: LineChart(
                        LineChartData(
                          lineTouchData: LineTouchData(enabled: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: myspot,
                              isCurved: false,
                              isStepLineChart: false,
                              barWidth: 2,
                              color: Colors.lightBlueAccent,
                              dotData: FlDotData(
                                show: false,
                              ),
                            ),
                          ],
                          // minY: 0,
                          titlesData: FlTitlesData(
                            show: true,
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              axisNameWidget: Text(
                                '${month}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 20,
                                interval: 3,
                                getTitlesWidget: bottomTitleWidgets,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              axisNameSize: 20,
                              axisNameWidget: const Text(
                                'Ltr/hour',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 5,
                                reservedSize: 10,
                                getTitlesWidget: leftTitleWidgets,
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          gridData: FlGridData(
                            show: false,
                            drawVerticalLine: false,
                            horizontalInterval: 1,
                            checkToShowHorizontalLine: (double value) {
                              return value == 1 ||
                                  value == 6 ||
                                  value == 4 ||
                                  value == 5;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/back.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: new BoxDecoration(
                        borderRadius:
                        new BorderRadius.circular(90.0),
                        color: Colors.white,
                      ),
                      margin: const EdgeInsets.only(top: 40),
                      child: Icon(
                        Icons.person,
                        size: 130.0,
                        color: Colors.blue,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        '$uid',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 1),
                      child: Text(
                        '$uid@gmail.com ',
                        style: TextStyle(
                            fontSize: 20,
                            // fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Container(

                      margin: const EdgeInsets.only(top: 1,bottom: 20),
                      child: const Text(
                        '03322547869 ',
                        style: TextStyle(
                            fontSize: 15,
                            // fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    const Text(
                      'Motor Assigned ',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      decoration: new BoxDecoration(
                        borderRadius:
                        new BorderRadius.circular(15.0),
                        color: Colors.white,
                      ),
                      margin: const EdgeInsets.only(top: 8),
                      child: Center(
                        child: const Text(
                          '1',
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String text;
    text = (value.toInt()).toString();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: Colors.black,
          // fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  Widget mybot(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Jan';
        break;
      case 1:
        text = 'Feb';
        break;
      case 2:
        text = 'Mar';
        break;
      case 3:
        text = 'Apr';
        break;
      case 4:
        text = 'May';
        break;
      case 5:
        text = 'Jun';
        break;
      case 6:
        text = 'Jul';
        break;
      case 7:
        text = 'Aug';
        break;
      case 8:
        text = 'Sep';
        break;
      case 9:
        text = 'Oct';
        break;
      case 10:
        text = 'Nov';
        break;
      case 11:
        text = 'Dec';
        break;
      default:
        return Container();
    }    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: Colors.black,
          // fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text('${value.toInt()}', style: style),
    );
  }
}
