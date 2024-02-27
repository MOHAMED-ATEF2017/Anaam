import 'package:en3am_app/pages/profile/delete_account.dart';
import 'package:en3am_app/pages/profile/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/colors.dart';
import '../../widget/appbar.dart';
import '../../widget/bottom.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userName = "";
  String phone = "";

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    userName = prefs.getString('name') ?? '';
    phone = prefs.getString('phone') ?? '';

    if (context.mounted) {
      setState(() {});
    }
  }

  @override
  initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(
        title: 'الملف الشخصي',
        cart: false,
      ),
      bottomNavigationBar: showBottomNavBar(context, 2),
      floatingActionButton: buildFloatingActionBtn(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.width / 3,
              width: MediaQuery.of(context).size.width,
              color: AppColors.primaryColor,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    right: 0,
                    left: 0,
                    bottom: -40,
                    child: Center(
                        child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 45,
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Image.asset('assets/images/logo.png'),
                            ))),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 45,
            ),
            Center(
              child: Text(
                userName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                phone,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 45,
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const UpdateProfile()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      padding: const EdgeInsets.all(7),
                      child: const Center(
                        child: Text('تعديل الملف الشخصي'),
                      ),
                    ))),
            const SizedBox(
              height: 25,
            ),
            Center(
              child: InkWell(
                onTap: (){
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const DeleteAccount()));
                },
                child: const Text(
                  'حذف الحساب',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
