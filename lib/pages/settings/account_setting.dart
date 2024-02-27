
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/colors.dart';
import '../../widget/appbar.dart';
import '../../widget/bottom.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({Key? key}) : super(key: key);

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: 'إعدادات الحساب',cart: false,),
      bottomNavigationBar: showBottomNavBar(context, 2),
      floatingActionButton: buildFloatingActionBtn(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        children: [
          const SizedBox(height: 30,),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(5))
                ),
                padding: const EdgeInsets.all(7),
                child: Row(
                  children: [
                    Expanded(child: Text('تغيير كلمة المرور'),),
                    Padding(padding: EdgeInsets.all(5),
                    child: Icon(FontAwesomeIcons.volumeMute),)
                  ],
                ),
              )),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                padding: EdgeInsets.all(7),
                child: Row(
                  children: [
                    Expanded(child: Text('تغيير كلمة المرور'),),
                    Padding(padding: EdgeInsets.all(5),
                    child: Switch(
                      value: true,
                      onChanged: (bool value) {
                        setState(() {

                        });
                      },
                    ),)
                  ],
                ),
              )),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                padding: EdgeInsets.all(7),
                child: Row(
                  children: [
                    Expanded(child: Text('تغيير كلمة المرور'),),
                    Padding(padding: EdgeInsets.all(5),
                    child: Switch(
                      value: false,
                      onChanged: (bool value) {
                        setState(() {

                        });
                      },
                    ),)
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
