
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/colors.dart';
import '../../widget/AssetsWidget.dart';
import '../../widget/appbar.dart';
import 'cart_shipping.dart';

class CartDetails extends StatefulWidget {
  const CartDetails({Key? key}) : super(key: key);

  @override
  State<CartDetails> createState() => _CartDetailsState();
}

class _CartDetailsState extends State<CartDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: 'تفاصيل الطلب',),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child:Stack(
      children: [
        SingleChildScrollView(
                child: Column(
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 15),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  //details
                                  Container(
                                    width: 60,
                                    height: 60,
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                                    ),
                                    child: const Icon(FontAwesomeIcons.cartShopping,color: Colors.white,),
                                  ),

                                  Expanded(child: Divider(thickness: 2,color: AppColors.primaryColorDisabled,)),
                                  //shipping
                                  Container(
                                    width: 60,
                                    height: 60,
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColorDisabled,
                                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                                    ),
                                    child: const Icon(FontAwesomeIcons.truckFast,color: Colors.white,),
                                  ),

                                  Expanded(child: Divider(thickness: 2,color: AppColors.primaryColorDisabled,)),
                                  //payment
                                  Container(
                                    width: 60,
                                    height: 60,
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColorDisabled,
                                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                                    ),
                                    child: const Icon(FontAwesomeIcons.creditCard,color: Colors.white,),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  SizedBox(
                                    width: 60,
                                    child: Center(
                                      child: Text('التفاصيل',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    child: Center(
                                      child: Text('الشحن',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    child: Center(
                                      child: Text('الدفع',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                    ),
                                  ),



                                ],
                              ),
                              const SizedBox(height: 5,),
                            ],
                          ),
                        ),


                      listBox(),
                      listBox(),
                      listBox(),

                      SizedBox(height: 100,),

                    ])),

        //button
        Positioned(
            bottom: 0,
            child: Container(

                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 15),
                child: AssetWidgets.buttonWidget(context, 'التالي', (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const CartShipping()));
                })
            )

        ),

      ]),
    ));
  }

  Widget listBox()
  {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.blackColor,width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.blackColor,width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              padding: const EdgeInsets.all(2),
              child: Image.asset(
                'assets/images/1.png',
                width: MediaQuery.of(context).size.width /4,
                height: MediaQuery.of(context).size.width /4 *1.4,
                fit: BoxFit.cover,
              )
          ),

          Expanded(child: Padding(padding: const EdgeInsets.only(right: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text('حري',style: TextStyle(color: AppColors.blackColor,fontWeight: FontWeight.bold,fontSize: 22)),
                      Text('57.50 SAR',style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),
                    ],
                  ),
                  const SizedBox(height: 10,),

                  const Text('سكواني - ثلاجة - أصناف - قوائم',style: TextStyle(fontSize: 18),),
                  const SizedBox(height: 10,),

                  const Text('ملاحظات : يكون الخروغ منظف جيداً',style: TextStyle(fontSize: 18),),
                  const SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      //increase or decrease quantity
                      Text('العدد 2',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                      Icon(FontAwesomeIcons.trashCan,color: Colors.red,size: 25,),



                    ],
                  )
                ],
              )))
        ],
      ),
    );
  }
}
