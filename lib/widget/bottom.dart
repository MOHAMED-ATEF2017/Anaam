// ignore_for_file: library_private_types_in_public_api, unused_local_variable

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../config/colors.dart';
import '../functions/general_function.dart';
import '../pages/chat/chat_details.dart';
import '../pages/home/home.dart';
import '../pages/orders/orders.dart';


FloatingActionButton buildFloatingActionBtn(context) {
  return FloatingActionButton(
    onPressed: () async {
      bool guest = await GeneralFunctions.checkIfGuest();

      if (guest) {
        if (context.mounted)
        {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('من فضلك قم بتسجيل الدخول'),
          ),);

        }
      }else{
        Navigator.push(context,MaterialPageRoute(builder: (_) => const ChatDetails()));
      }

    },
    backgroundColor: AppColors.white,
    child: Image.asset('assets/images/icons/more_circle.png')

  );
}

AnimatedBottomNavigationBar showBottomNavBar(context, currentIndex) {

  const List<Widget> widgetOptions = <Widget>[
    Home(),
    Home(),

  ];

  final iconList = <IconData>[
    FontAwesomeIcons.house,
    FontAwesomeIcons.list,
  ];

  return AnimatedBottomNavigationBar(
    gapLocation: GapLocation.center,
    notchSmoothness: NotchSmoothness.defaultEdge,
    activeColor: AppColors.primaryColor,
    backgroundColor: AppColors.white,
    inactiveColor: AppColors.gry1,
    icons: iconList,
    activeIndex: currentIndex,
    onTap: (index) async {
      if(index == 0)
      {
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (_) => const Home()));
      }
      if(index == 1)
      {
        bool guest = await GeneralFunctions.checkIfGuest();

        if (guest) {
          if (context.mounted)
          {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('من فضلك قم بتسجيل الدخول'),
            ),);

          }


        }else{
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (_) => const Orders()));
        }

      }


    },
  );


}
