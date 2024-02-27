import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/colors.dart';
import '../../controller/UserController.dart';
import '../../functions/general_function.dart';
import '../../widget/AssetsWidget.dart';
import '../../widget/appbar.dart';
import '../../widget/bottom.dart';
import '../auth/auth_home.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {

  bool loading = false;

  deleteAccount() async {
    try {

      setState(() {
        loading = true;
      });

      String res = await UserController().deleteAccount();

      if(res == "error")
      {
        setState(() {
          loading = false;
        });
        GeneralFunctions.showSnack(context, 'حدث خطأ يرجى المحاولة مرة أخرى');
      }

      var data = json.decode(res);

      if(data['success'] == 'true')
      {

          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();


        if(context.mounted)
        {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => const AuthHome()));
        }
      }else{
        setState(() {
          loading = false;
        });
        GeneralFunctions.showSnack(context, 'حدث خطأ يرجى المحاولة مرة أخرى');
      }

    }catch(e){
      setState(() {
        loading = false;
      });

      GeneralFunctions.showSnack(context, 'حدث خطأ يرجى المحاولة مرة أخرى');

    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(
        title: 'حذف حسابك',
        cart: false,
      ),
      bottomNavigationBar: showBottomNavBar(context, 2),
      floatingActionButton: buildFloatingActionBtn(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body:  SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(
              height: 25,
            ),

            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width-50,
                child: const Text('هل أنت متأكد من رغبتك في حذف حسابك؟ سيم حذف حسابك والمعلومات المرتبطة به نهائياً ولن تتمكن من استعادتها لاحقاً.')
              ),
            ),

            Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: InkWell(
                    onTap: () {

                      deleteAccount();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                          border: Border.all(width: 0.5),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(5))),
                      padding: const EdgeInsets.all(7),
                      child:  Center(
                        child: loading?Center(
                            child: AssetWidgets.loadingWidget(AppColors.white))
                        : Text('حذف الحساب',style: TextStyle(color: Colors.white),),
                      ),
                    ))),

          ],
        ),
      ),
    );
  }


}
