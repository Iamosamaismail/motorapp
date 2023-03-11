import 'dart:async';
import 'package:flutter/material.dart';
import 'package:motorapp/HomePage.dart';
import 'package:page_transition/page_transition.dart';
import '../Bouncing.dart';
import 'package:overlay_support/overlay_support.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = '';

  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  bool isloading = true;
  String email = '';
  String password = '';
  String u1 = "muzammil";
  String p1 = "muzammil";
  String u2 = "bilal";
  String p2 = "bilal";
  // String Ura = 'http://182.176.105.147:6363/api/evan/user/signup-password?';

  String error = '';

  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/back.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Container(
                //     decoration: const BoxDecoration(
                //       image: DecorationImage(
                //         image: AssetImage("assets/icon/logo.png"),
                //       ),
                //     ),
                //     // alignment: Alignment.bottomCenter,
                //     height: 210,
                //     padding: const EdgeInsets.all(5),
                //     child: const Text("Login",
                //         style: TextStyle(
                //             fontWeight: FontWeight.bold, fontSize: 50))),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage("assets/icon/logo.png"),
                      ),
                    ),
                    // alignment: Alignment.bottomCenter,
                    height: 80,
                    width: 200,
                    padding: const EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 100),
                    ),
                _keyboardIsVisible()
                    ? const SizedBox(
                        height: 10,
                      )
                    : const SizedBox(
                        height: 60,
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
                                borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                    style: BorderStyle.none),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                    style: BorderStyle.none),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                    style: BorderStyle.none),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                    style: BorderStyle.none),
                              ),
                              hintStyle:
                                  TextStyle(color: Colors.grey.withOpacity(.8)),
                              prefixIcon: const Icon(Icons.perm_identity_outlined),
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
                          obscureText: true,
                          onChanged: (val2) {
                            setState(() => password = val2);
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                    style: BorderStyle.none),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                    style: BorderStyle.none),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                    style: BorderStyle.none),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
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
                              prefixIcon: const Icon(Icons.lock_open_outlined),
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
                    ? const SizedBox(
                        height: 10,
                      )
                    : const SizedBox(
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
                              gradient: const LinearGradient(
                                colors: <Color>[
                                  Colors.blueAccent,
                                  Colors.blue,
                                  Colors.deepPurple,
                                ],
                              ),
                              boxShadow: const [
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
                                foregroundColor: Colors.white,
                                //textStyle: const TextStyle(fontSize: 13),
                              ),
                              onPressed: () async {
                                if (username.toLowerCase() == u1) {
                                  if(password.toLowerCase() == p1){
                                    setState(() {
                                      isloading = false;
                                    });
                                    Future.delayed(const Duration(milliseconds: 3000), () {
                                      Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.fade,
                                              child: HomePage(userid: u1,)));

                                    });
                                  }
                                  else{
                                    showSimpleNotification(const Text("Wrong Password"),
                                        background: Colors.lightBlueAccent);
                                  }
                                }
                                else if (username.toLowerCase() == u2) {
                                  if(password.toLowerCase() == p2){
                                    setState(() {
                                      isloading = false;
                                    });
                                    Future.delayed(const Duration(milliseconds: 3000), () {
                                      Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.fade,
                                              child: HomePage(userid: u2,)));

                                    });
                                  }
                                  else{
                                    showSimpleNotification(const Text("Wrong Password"),
                                        background: Colors.lightBlueAccent);
                                  }
                                }
                                else{
                                  showSimpleNotification(const Text("UserName Not exists"),
                                      background: Colors.lightBlueAccent);
                                }

                              }
                              ,
                              child:
                                  const Text("LOGIN"),
                            ))
                        : const CircularProgressIndicator(),
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
                          : const Expanded(
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
                                    const Text("Need an account?",
                                        style: TextStyle(color: Colors.white)),
                                    TextButton(
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                      ),
                                      onPressed: () {},
                                      child: const Text('Signup'),
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
