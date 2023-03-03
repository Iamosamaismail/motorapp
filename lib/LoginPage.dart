import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:motorapp/HomePage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:page_transition/page_transition.dart';
import 'package:simple_animations/simple_animations.dart';
import '../Bouncing.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late FirebaseAuth _auth;
  late User _user;

  // String password = '';
  String username = '';

  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

  bool isloading = true;
  String email = '';
  String password = '';
  String u1 = "osama";
  String p1 = "123";
  String u2 = "adnan";
  String p2 = "1234";


  // String Ura = 'http://182.176.105.147:6363/api/evan/user/signup-password?';

  String error = '';

  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    alignment: Alignment.bottomCenter,
                    height: 210,
                    padding: const EdgeInsets.all(5),
                    child: const Text("Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30))),
                _keyboardIsVisible()
                    ? const SizedBox(
                        height: 0,
                      )
                    : const SizedBox(
                        height: 50,
                      ),
                Form(
                  key: formKey1,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 1.4,
                        margin: const EdgeInsets.only(bottom: 20),

                        //color: Colors.white,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 2.0)
                          ],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextFormField(
                          onChanged: (val1) {
                            setState(() => username = val1);
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                    style: BorderStyle.none),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                    style: BorderStyle.none),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                    style: BorderStyle.none),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                    style: BorderStyle.none),
                              ),
                              hintStyle:
                                  TextStyle(color: Colors.grey.withOpacity(.8)),
                              prefixIcon: Icon(Icons.perm_identity_outlined),
                              hintText: "Enter your username"),
                          validator: (String? val1) {
                            return (val1!.isEmpty) ? 'Enter Username' : null;
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.4,

                        //color: Colors.white,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 2.0)
                          ],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextFormField(
                          onChanged: (val2) {
                            setState(() => password = val2);
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                    style: BorderStyle.none),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                    style: BorderStyle.none),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                    style: BorderStyle.none),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                    style: BorderStyle.none),
                              ),

                              // focusedBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(30),
                              //   borderSide: BorderSide(color: Colors.red,width: 2,style: BorderStyle.solid ),
                              // ),
                              hintStyle:
                                  TextStyle(color: Colors.grey.withOpacity(.8)),
                              prefixIcon: Icon(Icons.lock_open_outlined),
                              hintText: "Enter password"),
                          validator: (String? val1) {
                            return (val1!.isEmpty) ? 'Enter Password' : null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 50, top: 10),
                  width: MediaQuery.of(context).size.width,
                ),
                _keyboardIsVisible()
                    ? SizedBox(
                        height: 10,
                      )
                    : SizedBox(
                        height: 30,
                      ),
                Bouncing(
                  onPress: () {},
                  child: Center(
                    child: isloading
                        ? Container(
                            width: MediaQuery.of(context).size.width / 1.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Colors.red,
                                  Color(0xFFD23E19),
                                  Color(0xFFF57542),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26, blurRadius: 5.0)
                              ],
                            ),
                            child: TextButton(
                              //splashFactory: NoSplash.splashFactory,

                              style: TextButton.styleFrom(
                                shadowColor: Colors.black,
                                //minimumSize: Size(width /1.7, 10),
                                //maximumSize: Size(width / 2, 20),
                                padding: const EdgeInsets.all(10.0),
                                primary: Colors.white,
                                //textStyle: const TextStyle(fontSize: 13),
                              ),
                              onPressed: () async {
                                print(username);
                                print(password);

                                if (username == u1) {
                                  if(password == p1){
                                    setState(() {
                                      isloading = false;
                                      print("false");

                                    });
                                    Future.delayed(Duration(milliseconds: 3000), () {
                                      Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.fade,
                                              child: HomePage(userid: u1,)));

                                    });
                                  }
                                }
                                if (username == u2) {
                                  if(password == p2){
                                    setState(() {
                                      isloading = false;
                                      print("false");

                                    });
                                    Future.delayed(Duration(milliseconds: 3000), () {
                                      Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.fade,
                                              child: HomePage(userid: u2,)));

                                    });
                                  }
                                }

                              },
                              child:
                                  const Text("Show my energy consumption   "),
                            ))
                        : CircularProgressIndicator(),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: _keyboardIsVisible()
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.start,
                    children: [
                      _keyboardIsVisible()
                          ? const SizedBox(
                              height: 0,
                            )
                          : Expanded(
                              child: SizedBox(
                                height: 520,
                              ),
                            ),
                      !_keyboardIsVisible()
                          ? Container(
                            padding: const EdgeInsets.only(bottom: 100),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Need an account?",
                                        style: TextStyle(color: Colors.grey)),
                                    TextButton(
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.blue),
                                      ),
                                      onPressed: () {},
                                      child: Text('Signup'),
                                    ),
                                  ]),
                            )
                          : const SizedBox(
                              height: 510,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
