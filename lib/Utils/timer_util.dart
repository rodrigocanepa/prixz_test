import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prixz_test/Screens/main_screen.dart';

class TimerUtil{

  void startTimer(BuildContext context) async{
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen ()
        )
    );
  }
}