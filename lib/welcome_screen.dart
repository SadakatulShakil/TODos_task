import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:to_dos/home/homepage.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  Future<bool>_checkFirstTime()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('first_time') ?? true;
  }

  Future<void>_setFirstTime()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time', false);
  }

  @override
  void initState() {
    super.initState();
    _checkFirstTime().then((isFirstTime){
      if(isFirstTime){
        _setFirstTime();
        Timer(Duration(seconds: 3), ()=>
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (Context)=>FinalView())));
      }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (Context)=>FinalView()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/gif/splash.gif'),
          ],
        ),
      ),
    );

  }


}
