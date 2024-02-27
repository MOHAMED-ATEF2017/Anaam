import 'package:en3am_app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../functions/general_function.dart';
import '../pages/cart/cart_home.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool cart;
  AppBarWidget({Key? key, this.title = "انعام بيشة",this.cart = true}) : super(key: key);

  final AppBar appBar = AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 1,
      iconTheme: IconThemeData(color: AppColors.blackColor),

      actions: [
        if(cart)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: InkWell(
            onTap: () async {
              bool guest = await GeneralFunctions.checkIfGuest();

              if (guest) {
                if (context.mounted)
                {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('من فضلك قم بتسجيل الدخول'),
                  ),);

                }


              }else{
                if (context.mounted) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const CartHome()));
                }
              }

            },

            child: Icon(FontAwesomeIcons.cartShopping,color: AppColors.primaryColor,),

            
          ),
        ),

      ],
      titleSpacing: 0.00,
      title: Container(

          height: 50,
          child: Center(
        child:
          Text(
            title,
            style:  TextStyle(fontSize: 18, color: AppColors.blackColor,fontWeight: FontWeight.bold),
          ),
      )),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
