import 'package:en3am_app/config/colors.dart';
import 'package:en3am_app/functions/general_function.dart';
import 'package:en3am_app/pages/pages/banks.dart';
import 'package:en3am_app/pages/pages/privacy.dart';
import 'package:en3am_app/pages/pages/social.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/auth/auth_home.dart';
import '../pages/pages/about.dart';
import '../pages/pages/terms.dart';
import '../pages/profile/profile.dart';
import '../pages/settings/account_setting.dart';


class InkWellDrawer extends StatefulWidget {
  const InkWellDrawer({super.key});

  @override
  State<InkWellDrawer> createState() => _InkWellDrawerState();
}

class _InkWellDrawerState extends State<InkWellDrawer> {

  var guest = false;



   _logout() async {
    if (guest == false) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    }

    if(context.mounted)
      {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => const AuthHome()));
      }

  }


  gustCheck()
  async {
    guest = await GeneralFunctions.checkIfGuest();
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    gustCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child:  ListView(

            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColors.white
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // image and name
                      Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Image.asset("assets/images/logo.png",width: MediaQuery.of(context).size.width/3,),),

                    ],
                  )),
              Container(
              color: AppColors.primaryColor,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  //My Account
                  if(!guest)
                  Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 6),
                      child: CustomListTile(FontAwesomeIcons.solidUser, 'حسابي', () => {
                      Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const Profile()))
                      }),
                    ),

                  //Bank Account
                  if(!guest)
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 6),
                    child: CustomListTile(FontAwesomeIcons.buildingColumns, 'الحسابات البنكية', () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const Banks()))
                    }),
                  ),

                  //Terms
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 6),
                    child: CustomListTile(FontAwesomeIcons.solidNoteSticky, 'الشروط والأحكام', () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const Terms()))
                    }),
                  ),

                  //privacy policy
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 6),
                    child: CustomListTile(FontAwesomeIcons.solidNoteSticky, 'سياسة الخصوصية', () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const PrivacyPolice()))
                    }),
                  ),

                  //Social
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 6),
                    child: CustomListTile(FontAwesomeIcons.instagram, 'حسابات التواصل الاجتماعي', () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const Social()))
                    }),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 6),
                    child: CustomListTile(FontAwesomeIcons.circleInfo, 'عن التطبيق', () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const AboutApp()))
                    }),
                  ),

                  if(!guest)
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 6),
                    child: CustomListTile(FontAwesomeIcons.signOut, 'تسجيل الخروج', () => _logout()),
                  ),

                  if(guest)
                    Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 6),
                      child: CustomListTile(FontAwesomeIcons.arrowRightToBracket, 'تسجيل الدخول', () => _logout()),
                    ),
                ],
              )
              ),
            ],
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;

  const CustomListTile(this.icon, this.text, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    //ToDO
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: InkWell(
          splashColor: Colors.blue,
          onTap: () {
            onTap();
          },
          child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[

                        const SizedBox(
                          width: 10,
                        ),
                        Icon(
                          icon,
                          color: AppColors.white,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          text,
                          style: TextStyle(
                              fontSize: 16, color: AppColors.white,fontWeight: FontWeight.bold),
                        ),



                    ],
                  ),

                   Icon(
                      FontAwesomeIcons.angleLeft,
                      color: AppColors.white,
                    ),
                ],
              ))),
    );
  }
}
