
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/api_urls.dart';
import '../../config/colors.dart';
import '../../controller/CartController.dart';
import '../../models/cart.dart';
import '../../widget/AssetsWidget.dart';
import '../../widget/appbar.dart';
import 'cart_shipping.dart';

class CartHome extends StatefulWidget {
  const CartHome({Key? key}) : super(key: key);

  @override
  State<CartHome> createState() => _CartHomeState();
}

class _CartHomeState extends State<CartHome> {

  bool loading = true;
  double totalPrice = 0;

  List<Cart> cartItems = [];

  final CartController _api = CartController();

  void getData() async {
    setState(() {
      loading = true;
    });

    Map<String,dynamic> data = await _api.getUserCart();

    cartItems = List<Cart>.from(
        data['data'].map((x) => Cart.fromJson(x)));

    totalPrice = 0;
    for (var item in cartItems) {
      //getting the key direectly from the name of the key
      totalPrice += item.price;
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> deleteItem(String id) async {
    setState(() {
      loading = true;
    });

    bool data = await _api.deleteItem(id);

    if(data)
      {

        getData();
        if(context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('تم إزالة العنصر من السلة بنجاح'),
          ),);
        }
      }else{
      if(context.mounted) {
        AssetWidgets.AlertDia(context, 'فشل العملية', 'حدث الخطأ يرجى المحاولة لاحقاً');
        setState(() {
          loading = false;
        });
      }
    }
  }
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: 'السلة',),
      body: loading
          ? AssetWidgets.loadingWidget(AppColors.primaryColor)
          :SizedBox(
          height: MediaQuery.of(context).size.height,
          child:cartItems.isNotEmpty ?
          Stack(
          children: [


            SingleChildScrollView(
            child: Column(
              children: <Widget>[

                //top bar
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          //details
                          Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: const BorderRadius.all(Radius.circular(50)),
                            ),
                            child: const Icon(FontAwesomeIcons.cartShopping,color: Colors.white,size: 15,),
                          ),

                          Expanded(child: Divider(thickness: 2,color: AppColors.primaryColorDisabled,)),
                          //shipping
                          Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColorDisabled,
                              borderRadius: const BorderRadius.all(Radius.circular(50)),
                            ),
                            child: const Icon(FontAwesomeIcons.truckFast,color: Colors.white,size: 15,),
                          ),

                          Expanded(child: Divider(thickness: 2,color: AppColors.primaryColorDisabled,)),
                          //payment
                          Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColorDisabled,
                              borderRadius: const BorderRadius.all(Radius.circular(50)),
                            ),
                            child: const Icon(FontAwesomeIcons.creditCard,color: Colors.white,size: 15,),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5,),

                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 40,
                            child: Center(
                              child: Text('السلة',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: Center(
                              child: Text('الشحن',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: AppColors.gry1),),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: Center(
                              child: Text('الدفع',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: AppColors.gry1),),
                            ),
                          ),



                        ],
                      ),
                      const SizedBox(height: 5,),
                    ],
                  ),
                ),

                const SizedBox(height: 5,),

                for(int i=0; i<cartItems.length;i++)
                listBox(cartItems[i]),

                const SizedBox(height: 150,),
              ])),

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
              child: AssetWidgets.buttonWidget(context, 'شراء الآن', (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const CartShipping()));
              })
            )

            ),

            Positioned(
              bottom: 100,
              child:SizedBox(
                  width: MediaQuery.of(context).size.width,
                child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(7),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.gry1),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('المجموع الكلي',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    Text('$totalPrice ر.س',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                  ],
                ),
              )),
            )
        ])
              : emptyCart()
      ),
    );
  }

  Widget listBox(Cart cart)
  {

    String head = "سلخ";
    String rumen = "لا";

    //rumen
    if(cart.rumen == 1)
      {
        rumen = "نعم";
      }else if(cart.rumen == 2)
      {
        rumen = "لا";
      }

    String minced = 'غير مطلوب';
    if(cart.mincedCount != 0)
      {
        minced = "${cart.mincedCount} كيلو - ${cart.mincedPrice} ر.س";
      }
    //head
    if(cart.head == 1)
      {
        head = "سلخ";
      }else if(cart.head == 2)
      {
        head = "لا";
      }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.blackColor,width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: ApiUrls.mediaUrl+cart.product.image,
            width: MediaQuery.of(context).size.width ,
            height: MediaQuery.of(context).size.width /2 ,
            fit: BoxFit.cover,
          ),
           Padding(padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text('${cart.product.title} (${cart.quantity})',style: TextStyle(color: AppColors.blackColor,fontWeight: FontWeight.bold,fontSize: 18)),
                      const Expanded(child: SizedBox()),
                      Text('${cart.price} ر.س',style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 18),),
                      const SizedBox(width: 5,),
                      InkWell(
                        onTap: () => deleteItem(cart.id.toString()),
                        child: const Icon(FontAwesomeIcons.trashCan,color: Colors.red,size: 20,),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),



                  Text('الحجم: ${cart.size.title} - ${cart.size.price * cart.quantity} ر.س',style: const TextStyle(fontSize: 14),),
                  const SizedBox(height: 5,),

                  Text('التقطيع: ${cart.cutting.title} - ${cart.cuttingPrice} ر.س',style: const TextStyle(fontSize: 14),),
                  const SizedBox(height: 5,),

                  Text('التغليف: ${cart.packaging.title} - ${cart.packagingPrice} ر.س',style: const TextStyle(fontSize: 14),),
                  const SizedBox(height: 5,),

                  Text('الرأس: $head',style: const TextStyle(fontSize: 14),),
                  const SizedBox(height: 5,),

                  Text('الكرش (المصران): $rumen',style: const TextStyle(fontSize: 14),),
                  const SizedBox(height: 5,),

                  Text('اللحم المفروم: $minced',style: const TextStyle(fontSize: 14),),
                  const SizedBox(height: 5,),




                ],
              ))
        ],
      ),
    );
  }

  Widget emptyCart(){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/images/sheep.jpg',width: MediaQuery.of(context).size.width/2,),
        const SizedBox(height: 20,),
        Text('السلة فارغة!',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: AppColors.primaryColor),),
      ],
    ));
  }
}
