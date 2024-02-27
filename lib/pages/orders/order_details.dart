
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/api_urls.dart';
import '../../config/colors.dart';
import '../../models/order_item.dart';
import '../../models/orders.dart';
import '../../widget/appbar.dart';
import '../../widget/bottom.dart';

class OrderDetails extends StatefulWidget {
  final OrderModel order;
  const OrderDetails({Key? key,required this.order}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  Color statusColor = AppColors.gry1;
  String statusText = 'بانتظار الدفع';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.order.status == 1)
    {
      statusText = 'قيد التنفيذ';
    }

    if(widget.order.status == 2)
    {
      statusColor = AppColors.primaryColor2;
      statusText = 'تم التسليم';
    }

    if(widget.order.status == 3)
    {
      statusColor = Colors.redAccent;
      statusText = 'ملغي';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: "تفاصيل الطلب",cart: false,),
      bottomNavigationBar: showBottomNavBar(context, 1),
      floatingActionButton: buildFloatingActionBtn(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
          child:Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('رقم الطلب: ${widget.order.orderNumber}',style: TextStyle(color: AppColors.blackColor,fontWeight: FontWeight.bold,fontSize: 16)),
                    Text('${widget.order.totalPrice} ر.س',style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),
                  ],
                ),

                const SizedBox(height: 20,),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width/2,
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: statusColor,
                    ),
                    child: Center(child:Text(statusText,style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),)),
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.primaryColor,)),
                    Text('  تفاصيل الشحن  ',style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 18)),
                    Expanded(child: Divider(color: AppColors.primaryColor,)),
                  ],
                ),

                const SizedBox(height: 15,),
                Row(
                  children: [
                    const SizedBox(width: 10,),
                    Icon(FontAwesomeIcons.user,color: AppColors.gry1,size: 15,),
                    const SizedBox(width: 5,),
                    Text("المستلم: ${widget.order.shipName}"),
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    const SizedBox(width: 10,),

                    Icon(FontAwesomeIcons.phone,color: AppColors.gry1,size: 15,),
                    const SizedBox(width: 5,),
                    Text("الهاتف: ${widget.order.shipPhone}"),
                    const SizedBox(width: 10,),
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    const SizedBox(width: 10,),
                    Icon(FontAwesomeIcons.city,color: AppColors.gry1,size: 15,),
                    const SizedBox(width: 5,),
                    Text("المدينة: ${widget.order.city.title}"),
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    const SizedBox(width: 10,),

                    Icon(FontAwesomeIcons.addressCard,color: AppColors.gry1,size: 15,),
                    const SizedBox(width: 5,),
                    Text("العنوان: ${widget.order.shipAddress}"),

                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    const SizedBox(width: 10,),

                    Icon(FontAwesomeIcons.calendar,color: AppColors.gry1,size: 15,),
                    const SizedBox(width: 5,),
                    Text("تاريخ ارسال الطلب: ${widget.order.createdAt?.split('T').first}"),

                  ],
                ),
                const SizedBox(height: 15,),

                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.primaryColor,)),
                    Text('  وقت التسليم والتاريخ  ',style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 18)),
                    Expanded(child: Divider(color: AppColors.primaryColor,)),
                  ],
                ),

                const SizedBox(height: 15,),
                Row(
                  children: [
                    const SizedBox(width: 10,),
                    Icon(FontAwesomeIcons.calendar,color: AppColors.primaryColor2,size: 15,),
                    const SizedBox(width: 5,),
                    Text(widget.order.shipDate,style: const TextStyle(fontSize: 14)),
                    const Expanded(child: SizedBox()),
                    Icon(FontAwesomeIcons.clock,color: AppColors.primaryColor2,size: 15,),
                    const SizedBox(width: 5,),
                    Text(widget.order.shipTime,style: const TextStyle(fontSize: 14),),
                    const SizedBox(width: 10,),
                  ],
                ),
                const SizedBox(height: 15,),

                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.primaryColor,)),
                    Text('  الاختيارات  ',style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 18)),
                    Expanded(child: Divider(color: AppColors.primaryColor,)),
                  ],
                ),

                for(int i=0; i< widget.order.items.length; i++)
                  listBox(widget.order.items[i]),



                const SizedBox(height: 15,),

                if(widget.order.adminDes.isNotEmpty)...[
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.primaryColor,)),
                      Text('  ملاحظات  ',style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 18)),
                      Expanded(child: Divider(color: AppColors.primaryColor,)),
                    ],
                  ),

                  const SizedBox(height: 15,),
                  Text('',style: TextStyle(color: AppColors.blackColor,fontWeight: FontWeight.normal,fontSize: 14)),
                  const SizedBox(height: 15,),
                ],



                const SizedBox(height: 15,),


              ],
            ),
          )),
    );
  }

  Widget listBox(OrderItemModel item)
  {

    String head = "سلخ";
    String rumen = "لا";
    String note = "لا يوجد";

    //note
    if(item.note.isNotEmpty)
      {
        note = item.note;
      }

    String minced = 'غير مطلوب';
    if(item.mincedCount != 0)
    {
      minced = "${item.mincedCount} كيلو - ${item.mincedPrice} ر.س";
    }

    //rumen
    if(item.rumen == 1)
    {
      rumen = "نعم";
    }else if(item.rumen == 2)
    {
      rumen = "لا";
    }

    //head
    if(item.head == 1)
    {
      head = "سلخ";
    }else if(item.head == 2)
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
      child: Padding(padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text('${item.product.title} - العدد: ${item.quantity}',style: TextStyle(color: AppColors.blackColor,fontWeight: FontWeight.bold,fontSize: 18)),
                  const Expanded(child: SizedBox()),
                  Text('${item.price} ر.س',style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 18),),

                ],
              ),
              const SizedBox(height: 10,),



              Text('الحجم: ${item.size.title} - ${item.size.price * item.quantity} ر.س',style: const TextStyle(fontSize: 14),),
              const SizedBox(height: 5,),

              Text('التقطيع: ${item.cutting.title} - ${item.cuttingPrice} ر.س',style: const TextStyle(fontSize: 14),),
              const SizedBox(height: 5,),

              Text('التغليف: ${item.packaging.title} - ${item.packagingPrice} ر.س',style: const TextStyle(fontSize: 14),),
              const SizedBox(height: 5,),

              Text('الرأس: $head',style: const TextStyle(fontSize: 14),),
              const SizedBox(height: 5,),

              Text('الكرش (المصران): $rumen',style: const TextStyle(fontSize: 14),),
              const SizedBox(height: 5,),

              Text('الملاحظات: $note',style: const TextStyle(fontSize: 14),),
              const SizedBox(height: 5,),

              Text('اللحم المفروم: $minced',style: const TextStyle(fontSize: 14),),
              const SizedBox(height: 5,),

            ],
          )),
    );
  }
}
