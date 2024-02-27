
import 'dart:async';

import 'package:en3am_app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../functions/general_function.dart';
import 'auth/auth_home.dart';
import 'home/home.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  checkLogin() async {
    bool guest = await GeneralFunctions.checkIfGuest();

    if (!guest) {
      if (context.mounted)
        {
          Navigator.pushReplacement(context,MaterialPageRoute(
              builder: (context) => const Home()));
        }

    } else {
      //check skip
      final prefs = await SharedPreferences.getInstance();
      const key = 'skip';
      final isSkip = prefs.get(key) ?? 0;

      if(isSkip == "1")
        {
          if (context.mounted)
          {
            Navigator.pushReplacement(context,MaterialPageRoute(
                builder: (context) => const Home()));
          }
        }else{
          if (context.mounted)
          {
            Navigator.pushReplacement(context,MaterialPageRoute(
                builder: (context) => const AuthHome()));
          }
        }

    }

  }

  void startTimer() {
    
    Timer.periodic(const Duration(seconds: 3), (time) {
      checkLogin();
      time.cancel();
    });
  }

  @override
  initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
          child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(
                  child: Image(
                    image: const AssetImage(
                      "assets/images/logo.png",
                    ),
                    width: MediaQuery.of(context).size.width / 1.5,
                    //height: MediaQuery.of(context).size.height,
                    fit: BoxFit.fitWidth,
                  )))),
    );
  }
}
