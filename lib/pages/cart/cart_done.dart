import 'package:en3am_app/pages/home/home.dart';
import 'package:flutter/material.dart';

import '../../config/colors.dart';
import '../../widget/AssetsWidget.dart';
import '../../widget/appbar.dart';
import '../orders/orders.dart';

class CartDone extends StatefulWidget {
  final String orderNumber;
  const CartDone({Key? key,required this.orderNumber}) : super(key: key);

  @override
  State<CartDone> createState() => _CartDoneState();
}

class _CartDoneState extends State<CartDone> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (_) => const Home()));
          return true;
    },
    child:Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: 'تم بنجاح',),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/done.jpg',width: 200,),
              const SizedBox(height: 10,),
              const Text('تم ارسال طلبك بنجاح، سيتم التواصل معك عبر الواتساب لمتابعة تنفيذ الطلب',textAlign: TextAlign.center,),
              const SizedBox(height: 30,),
              Text('رقم الطلب: ${widget.orderNumber}',style: const TextStyle(fontWeight: FontWeight.bold),),
              const SizedBox(height: 30,),
              AssetWidgets.buttonWidget(context, 'عرض طلباتك', (){
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (_) => const Orders()));
              }),
            ],
          ),
        ),
      ),
    ));
  }
}
